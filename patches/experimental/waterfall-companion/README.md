# Waterfall experimental companion — waterfall profile + Butterfly flap

**Experimental. C1 is the external timing core only. This add-on includes
droplets, mist opacity/motion, white surface foam/waves, shared emission and
Butterfly wing phase. Butterfly movement and steering are uncorrected.**

The former `mist40` name and “no waves” profile description are SUPERSEDED:
the owner-assisted emission suppression identified the 0x40 family as white
surface shapes. Separate `WaterWaves` code/data remain unchanged. Legacy file
names are retained. v5-v7 lacked the 0x50 packed-alpha correction.

RAM components were tested on PPSSPP v1.20.4 / UCES00420 LEVEL_01; see the
[alpha007 report](../../../research/live-tests/pokitaru/waterfall-007-mist-visual-20260926/REPORT.md)
and the [earlier component report](../../../research/live-tests/pokitaru/waterfall-004-20260926/REPORT.md).
The [startup/Butterfly report](../../../research/live-tests/pokitaru/waterfall-008-prx-butterfly-20260926/REPORT.md)
records the v8 startup failure, heap recovery and resolver correction.
The v12 standalone PRX is installed. Fresh normal-save installation,344 checks,
exact emitter rates, wing recurrence, binding-conflict/core-removal/disarm controls
and owner visual check passed. Per-record PRX alpha/motion/lifetime captures and
broader lifecycle/gameplay gates remain open; this is **experimental**.
v13 changes recovery logging only; same291word recipe, built/reviewed, not installed.
Startup intermittently crashes in AMD `amdxc64.dll`, including a no-plugin
control and frontend-only launch. Original settings are restored; a frontend
survived bounded retries and owner confirmed it open. Game acceptance is pending.
Earlier v11 started but could not resolve LEVEL_01, so it did not install hooks.
Original ISO/PRXs and the existing core companion remain
unchanged. No validated-patch promotion or publication occurred.

## Exact composition

- Droplets006 retains droplets004 v5 gravity/countdown correction. Three new
  position hooks preserve its default half step and use `1/(1+sqrt(.97))`
  for damped X/Z and positive Y in the bound zero-gravity second family.
- Second 0x50-family damping config+4: `.97 ->sqrt(.97)` for new records.
- Scoped 0x50 rotation initialization derives half coefficients from the
  emitted sine/cosine pair; scalar initialization halves the emitted scalar
  step for the two bound configurations. Initial velocities are unchanged.
- Surface foam40 lifetime denominators: `60/90 ->120/180`; damping: `.97 ->sqrt(.97)`.
  Scoped X/Z integration uses `1/(1+sqrt(.97))`; Y uses `.5`.
  Scoped rotation initialization uses the same coefficient-root method.
- Alpha007 scopes the 0x50 packed-alpha decrement to the two current Waterfall
  pool IDs. It executes the original subtract/clamp/truncate on odd shared
  phases and holds alpha on even phases. Original quantization is preserved;
  halving the floating decrement would change integer rounding.
- Shared Waterfall emission gate: admit every fourth C1 update rather than
  every second A0 update. This restores all three measured emitter cadences.
  The delay-slot edit requires refreshing the preceding branch's code cache.
- Foam40 phase parameter stays at its original `1/3`. The superseded separate
  `1/6` correction and the rejected four-word spawn-speed probe are excluded.
- The all-site 005 patch is excluded. C1 core and separate `WaterWaves` are unchanged.
- Butterfly flap: replace the phase addition at `0x122C98` with a register-
  preserving half-step cave at `0x2C1CC0`. The per-instance `+0x5C` stays intact.
  A0/C1/apply/remove/reapply atomic controls and owner wing observation passed.
  Movement `+0x50`, counters, steering config and helpers are unchanged.
  The former `.1 ->.05` rotation proposal changes a damped pursuit coefficient;
  it is not an angular half-step and is excluded. Full Butterfly parity is open.

The owner observed that foam40 suppression removed the white water shapes;
alpha007 restored mist density close to A0 with droplets/surface shapes still
present. Complete gameplay parity remains open. Random endpoints and finite precision prevent a claim of
matched-seed or bitwise equality from the current measurements.

## Guards and ownership

The component applies only to the `rcp1` module fingerprint matching the
hash-pinned LEVEL_01 source, extent and 47 context guards, while all four C1
core guards match. Module identity is inferred from these fingerprints; the
plugin mapping restricts loading to UCES00420. Every original/cave word is
also checked. Existing droplet/mist hooks or occupied caves cause refusal.

The kernel segment extent is derived from vanilla PT_LOAD memory extents:
`0x46B830`. The debugger's rounded allocation is `0x46B900`; these are separate
measurements. Both resolver/ownership checks use the generated kernel extent.
Newlib heap is explicitly64KiB and verified in the linked ELF. Logging uses
bounded direct file writes; the SDK's default nearly-all-free-memory heap policy
caused a startup concern. Heap-capped v11 language startup was owner-confirmed.

291 rules include owned zero cave spans. Jumps and configuration immediates
are rebased to the resolved module, checked at three bases by the builder.
Caves precede redirects. Bounded preflight/install/readback/rollback suspend
dispatch; cache synchronization includes the branch plus edited delay slot.
Query failures preserve ownership and stop writes. Ownership expires only
when successful module enumeration proves the old module ID gone.
Installation also waits for distinct Waterfall pool IDs below64 and a shared
phase in0..3, rechecked while dispatch is suspended. Later pool/object reuse
and scene transitions still require runtime testing.
Restoration conflicts stay pending. Normal removal retains caves so a
preempted game thread can finish. A complete module reload clears these caves.

## Build

Use the existing PSPDEV SDK; no installation or archived-source modification:

```
python patches/experimental/waterfall-companion/build.py --name WaterfallExperimental-v13-recovery-log
```

The builder refuses an existing output directory. Choose a new revision name
when rebuilding; keep previous artifacts. Outputs are local under
`build/<name>/WaterfallExperimental/`; the manifest records inputs/source/
recipe/PRX hashes. Strict compilation uses warnings as errors.
v1-v4 are superseded recipes/review artifacts. v5-v7 retain the historical006
recipe, superseded as a complete profile because packed-alpha decay was missing.
v8 adds alpha007 and corrects the surface-foam labels. Strict compilation and
three-base rebasing passed. PRX164746 bytes, SHA-256:
`7a9adba5921b9d82097ff8a84378b64ed27b9c57b6fd45b9cc441007d13a4343`.
Final live RAM verification passed266 recipe+39 context+6 excluded-original
checks, unchanged over five seconds with advancing ticks and no breakpoint.
This historical test compared v8 to RAM; it did not validate PRX loading.
v8 blocked the language screen. v11 restored startup with a64KiB heap, but
waited indefinitely due to the wrong extent guard. v12 fixes both extent guards
and adds the measured flap cave:291rules/47guards/three-base checks PASS,
PRX165482bytes SHA-256:
`94ea2063bc4a52b9b473d28bc5b4244b0326fa36ccd12e64f8ca3c18ce78904f`.

## Next gate — startup recovery, then normal-save acceptance

The last pre-restart RAM was C1 core +Butterfly flap only. Owner closed PPSSPP
and v12 was deployed with binary/log backups and exact hash checks. Five launches
failed in the AMD module; bounded retries then recovered an open frontend.
Preserve that instance and use a normal game save for the acceptance test.
That v12 test is now completed as scoped above. Final RAM is A0 with add-on
disarmed/caves retained after the removal test. Owner must close PPSSPP for
guarded v13 replacement, then reload normally. v13 fixes a stale binding-warning
indicator; game recipe header is identical to v12. PRX165642bytes, SHA256
`e220dda1bd30653203b4bf56c6cb8607481ac55dfe4f503c280528ebc771e6ec`.
Keep the legacy profiler disabled: its full_layers15 profile is not C1 alone.
Start in A0, then arm C1 with the reviewed three-word host transaction.
Do not layer this PRX over the current RAM candidate, or load a savestate
containing patched code/caves/plugin state. Reverting redirects alone retains
caves and therefore does not satisfy this package's zero-cave preflight.

Read `status.log`, independently verify module/core/recipe words and ticks,
and repeat owner-bound motion, scalar, lifetime and exact emission controls.
Module transitions, core removal, conflicts and PRX stop require live tests
before acceptance. Query/restoration conflicts require investigation; a
confirmed core change removes the add-on and disarms it until restart.
Broader effects, visuals and gameplay regressions remain open. Raw tests and
binaries stay local; RAM acceptance does not establish PRX acceptance.
