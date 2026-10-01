// Mass decompilation of LEVEL_01 timing-relevant code on a guarded LOCAL copy.
// Seeds functions at every direct JAL target in .text and at every class-descriptor
// code pointer, runs Ghidra auto-analysis, then decompiles every function reachable
// within DEPTH calls from the 150 class update callbacks and from known engine roots.
// Writes C and an index under the output directory (local only, never committed).
// Args: <class-table.json> <output-dir> [depth]
//@category RAC
import ghidra.app.cmd.disassemble.DisassembleCommand;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.address.AddressSet;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionManager;
import ghidra.program.model.mem.MemoryBlock;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MassDecompile extends GhidraScript {
    static final long[] ROOTS = {0x1517C, 0x6B7F4, 0x6E6D4, 0x8CC18, 0x7E810, 0xDE23C, 0xDE8A8,
        0x2FFF0, 0x2FB8C, 0x28FFC, 0x29098, 0x292C0, 0x2A8F0, 0x76448, 0x76AA4, 0x191D7C,
        0x6C318, 0x1EBC4, 0x360A4, 0xA5AFC, 0x312AC, 0x14A74, 0xEE9C};

    @Override
    public void run() throws Exception {
        String[] args = getScriptArgs();
        File table = new File(args[0]);
        File out = new File(args[1]);
        int depth = args.length > 2 ? Integer.parseInt(args[2]) : 3;
        new File(out, "c").mkdirs();
        String json = Files.readString(table.toPath(), StandardCharsets.UTF_8);

        // class name -> update callback, and every descriptor code pointer
        Map<Long, String> updates = new TreeMap<>();
        Set<Long> seeds = new TreeSet<>();
        Matcher m = Pattern.compile("\"class\": \"([^\"]+)\",\\s*\"code\": \\[([^\\]]*)\\],\\s*\"update\": \"0x([0-9a-f]+)\"").matcher(json);
        while (m.find()) {
            updates.put(Long.parseLong(m.group(3), 16), m.group(1));
            Matcher h = Pattern.compile("0x([0-9a-f]+)").matcher(m.group(2));
            while (h.find()) seeds.add(Long.parseLong(h.group(1), 16));
        }
        Matcher x = Pattern.compile("\"extra\": \\[([^\\]]*)\\]").matcher(json);
        while (x.find()) {
            Matcher h = Pattern.compile("0x([0-9a-f]+)").matcher(x.group(1));
            while (h.find()) seeds.add(Long.parseLong(h.group(1), 16));
        }
        for (long r : ROOTS) seeds.add(r);
        MemoryBlock text = currentProgram.getMemory().getBlock(".text");
        Address ts = text.getStart(), te = text.getEnd();
        for (Address a = ts; a.compareTo(te) < 0; a = a.add(4)) {
            int w = currentProgram.getMemory().getInt(a);
            if ((w >>> 26) == 3) {
                long t = ((long) (w & 0x03FFFFFF)) << 2;
                if (t >= ts.getOffset() && t < te.getOffset()) seeds.add(t);
            }
        }
        println("MASS seeds " + seeds.size() + " updates " + updates.size());

        FunctionManager fm = currentProgram.getFunctionManager();
        int created = 0;
        for (long s : seeds) {
            if (monitor.isCancelled()) break;
            Address a = toAddr(s);
            if (fm.getFunctionAt(a) != null) continue;
            new DisassembleCommand(a, null, true).applyTo(currentProgram, monitor);
            if (createFunction(a, null) != null) created++;
        }
        println("MASS created " + created + " functions before analysis");
        analyzeAll(currentProgram);
        println("MASS functions after analysis " + fm.getFunctionCount());

        // reachable set
        Map<Long, Set<String>> reach = new TreeMap<>();
        Deque<long[]> q = new ArrayDeque<>();
        for (Map.Entry<Long, String> e : updates.entrySet()) q.add(new long[]{e.getKey(), 0, e.getKey()});
        for (long r : ROOTS) q.add(new long[]{r, 0, -1});
        Map<Long, String> label = new HashMap<>();
        while (!q.isEmpty()) {
            long[] it = q.poll();
            Function f = fm.getFunctionContaining(toAddr(it[0]));
            if (f == null) continue;
            long entry = f.getEntryPoint().getOffset();
            String who = it[2] >= 0 ? updates.get(it[2]) : "ENGINE";
            Set<String> s = reach.computeIfAbsent(entry, k -> new TreeSet<>());
            boolean fresh = s.isEmpty();
            if (!s.add(who) && !fresh) continue;
            if (it[1] >= depth) continue;
            for (Function c : f.getCalledFunctions(monitor)) q.add(new long[]{c.getEntryPoint().getOffset(), it[1] + 1, it[2]});
        }
        println("MASS reachable " + reach.size());

        DecompInterface d = new DecompInterface();
        d.openProgram(currentProgram);
        StringBuilder idx = new StringBuilder("[\n");
        int ok = 0, fail = 0, n = 0;
        for (Map.Entry<Long, Set<String>> e : reach.entrySet()) {
            if (monitor.isCancelled()) break;
            Function f = fm.getFunctionAt(toAddr(e.getKey()));
            if (f == null) continue;
            DecompileResults r = d.decompileFunction(f, 60, monitor);
            String c = r != null && r.decompileCompleted() && r.getDecompiledFunction() != null ? r.getDecompiledFunction().getC() : null;
            String rva = String.format("0x%x", e.getKey());
            if (c != null) { Files.writeString(new File(out, "c/" + rva + ".c").toPath(), c, StandardCharsets.UTF_8); ok++; } else fail++;
            StringBuilder callees = new StringBuilder();
            for (Function cf : f.getCalledFunctions(monitor)) callees.append(callees.length() > 0 ? "," : "").append(String.format("\"0x%x\"", cf.getEntryPoint().getOffset()));
            StringBuilder who = new StringBuilder();
            for (String w : e.getValue()) who.append(who.length() > 0 ? "," : "").append('"').append(w).append('"');
            idx.append(n++ > 0 ? ",\n" : "").append(String.format("{\"rva\":\"%s\",\"update\":%s,\"size\":%d,\"decompiled\":%s,\"reachedFrom\":[%s],\"callees\":[%s]}",
                rva, updates.containsKey(e.getKey()) ? "\"" + updates.get(e.getKey()) + "\"" : "null",
                f.getBody().getNumAddresses(), c != null, who, callees));
        }
        idx.append("\n]\n");
        Files.writeString(new File(out, "index.json").toPath(), idx.toString(), StandardCharsets.UTF_8);
        d.dispose();
        println("MASS decompiled ok=" + ok + " fail=" + fail);
        println("MASS_DECOMPILE_COMPLETE");
    }
}
