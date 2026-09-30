// Automatic runtime base discovery for measurement profiles.
//
// The transaction owns exactly one true stop-breakpoint. It refuses to run in
// the presence of any pre-existing breakpoint, reads only the declared GPRs,
// removes its breakpoint, and resumes before returning a usable binding.
import {hexAddress, nowIso} from './util.mjs';

function gprValues(response) {
  const category = (response.categories ?? []).find((item) => item.name === 'GPR');
  if (!category || !Array.isArray(category.registerNames) || !Array.isArray(category.uintValues)) {
    throw new Error('cpu.getAllRegs returned no usable GPR category');
  }
  return Object.fromEntries(
    category.registerNames.map((name, index) => [String(name).replace(/^\$/, '').toLowerCase(), category.uintValues[index] >>> 0]),
  );
}

function requiredRegister(values, name) {
  const key = String(name).replace(/^\$/, '').toLowerCase();
  const value = values[key];
  if (!Number.isInteger(value) || value === 0) {
    throw new Error(`binding register ${name} is missing or null`);
  }
  return value >>> 0;
}

export async function autoBindProfile({
  client,
  identity,
  profile,
  signal = null,
  hitTimeoutMs = 300000,
  onEvent = null,
}) {
  if (!profile?.binding) throw new Error(`profile ${profile?.name ?? '(none)'} has no automatic binding recipe`);
  if (!identity?.module?.address) throw new Error('no active module base for automatic binding');

  const initialCpu = await client.request('cpu.status');
  if (initialCpu.paused || initialCpu.stepping) {
    throw new Error('automatic binding requires the game CPU to be running before start');
  }
  const listed = await client.request('cpu.breakpoint.list');
  const existing = listed.breakpoints ?? [];
  if (existing.length !== 0) {
    throw new Error(`automatic binding refuses to coexist with ${existing.length} existing breakpoint(s)`);
  }

  const breakpointAddress = (identity.module.address + profile.binding.breakpointRva) >>> 0;
  // An add can take effect remotely even when its acknowledgment is lost.
  let breakpointMayExist = false;
  let stoppedByOwnedBreakpoint = false;
  let operationError = null;
  let cleanupError = null;
  const localAbort = new AbortController();
  const propagateAbort = () => localAbort.abort(signal?.reason ?? 'binding cancelled');
  if (signal?.aborted) propagateAbort();
  else signal?.addEventListener('abort', propagateAbort, {once: true});

  const hitPromise = client.waitForEvent('cpu.stepping', {
    predicate: (event) => {
      const matches = (event.pc >>> 0) === breakpointAddress;
      if (matches && breakpointMayExist) stoppedByOwnedBreakpoint = true;
      return matches;
    },
    timeoutMs: hitTimeoutMs,
    signal: localAbort.signal,
  });
  // If setup fails before the awaited hit, aborting the wait must not surface
  // as an unhandled rejection; the same promise is still awaited on success.
  void hitPromise.catch(() => {});

  try {
    if (localAbort.signal.aborted) throw new Error(String(localAbort.signal.reason ?? 'binding cancelled'));
    breakpointMayExist = true;
    try {
      await client.request('cpu.breakpoint.add', {
        address: breakpointAddress,
        enabled: true,
        log: false,
      });
    } catch (error) {
      // A definite local refusal cannot own a remotely added breakpoint.
      // Missing metadata leaves installation uncertain and requires reconciliation.
      if (error.requestSent === false) breakpointMayExist = false;
      throw error;
    }
    onEvent?.('armed', {breakpointAddress, breakpointAddressHex: hexAddress(breakpointAddress)});

    const hit = await hitPromise;
    stoppedByOwnedBreakpoint = true;
    onEvent?.('hit', {pc: hit.pc >>> 0, ticks: Number.isInteger(hit.ticks) ? hit.ticks : null});

    const registerResponse = await client.request('cpu.getAllRegs');
    const registers = gprValues(registerResponse);
    const bases = {};
    for (const [base, register] of Object.entries(profile.binding.registers)) {
      bases[base] = requiredRegister(registers, register);
    }

    await client.request('cpu.breakpoint.remove', {address: breakpointAddress});
    const remaining = await client.request('cpu.breakpoint.list');
    if ((remaining.breakpoints ?? []).some((item) => (item.address >>> 0) === breakpointAddress)) {
      throw new Error(`owned breakpoint ${hexAddress(breakpointAddress)} remained after removal`);
    }
    breakpointMayExist = false;
    await client.request('cpu.resume');
    stoppedByOwnedBreakpoint = false;

    return {
      method: 'owned-true-stop-breakpoint',
      boundAtUtc: nowIso(),
      moduleBase: identity.module.address,
      moduleBaseHex: hexAddress(identity.module.address),
      breakpointRva: `0x${profile.binding.breakpointRva.toString(16).toUpperCase()}`,
      breakpointAddress,
      breakpointAddressHex: hexAddress(breakpointAddress),
      hitPc: hit.pc >>> 0,
      hitPcHex: hexAddress(hit.pc >>> 0),
      hitTicks: Number.isInteger(hit.ticks) ? hit.ticks : null,
      registers: Object.fromEntries(
        Object.entries(profile.binding.registers).map(([base, register]) => [base, {register, value: bases[base], valueHex: hexAddress(bases[base])}]),
      ),
      bases,
      cleanup: {breakpointRemoved: true, cpuResumed: true},
    };
  } catch (error) {
    operationError = error;
    localAbort.abort(error.message);
    throw error;
  } finally {
    signal?.removeEventListener('abort', propagateAbort);
    if ((breakpointMayExist || stoppedByOwnedBreakpoint) && !client.connected) {
      cleanupError = new Error('debugger disconnected before breakpoint/CPU cleanup could be verified');
    } else if (breakpointMayExist || stoppedByOwnedBreakpoint) {
      let pausedForCleanup = false;
      let removalVerified = false;
      try {
        const current = await client.request('cpu.breakpoint.list');
        const present = (current.breakpoints ?? []).some((item) => (item.address >>> 0) === breakpointAddress);
        if (present) {
          const cpu = await client.request('cpu.status');
          if (cpu.stepping && (cpu.pc >>> 0) === breakpointAddress) stoppedByOwnedBreakpoint = true;
          // Preserve an external pause. Only undo a stop made by this transaction.
          if (!cpu.stepping && !cpu.paused) {
            pausedForCleanup = true;
            await client.request('cpu.stepping');
          }
          await client.request('cpu.breakpoint.remove', {address: breakpointAddress});
          const remaining = await client.request('cpu.breakpoint.list');
          if ((remaining.breakpoints ?? []).some((item) => (item.address >>> 0) === breakpointAddress)) {
            throw new Error(`owned breakpoint ${hexAddress(breakpointAddress)} remained after cleanup`);
          }
        }
        removalVerified = true;
        breakpointMayExist = false;
      } catch (error) {
        cleanupError = error;
      }
      // Never resume into an unverified remaining breakpoint.
      if (removalVerified && (pausedForCleanup || stoppedByOwnedBreakpoint)) {
        try {
          await client.request('cpu.resume');
          stoppedByOwnedBreakpoint = false;
        } catch (error) {
          cleanupError = error;
        }
      }
    }
    if (cleanupError) {
      const message = `cleanup unresolved at ${hexAddress(breakpointAddress)}: ${cleanupError.message}; check debugger breakpoint and CPU state before another automatic binding`;
      if (operationError) {
        operationError.cleanup = {status: 'unresolved', breakpointAddress, message};
        operationError.message += `; ${message}`;
      }
      onEvent?.('cleanup-error', {breakpointAddress, message});
    }
  }
}
