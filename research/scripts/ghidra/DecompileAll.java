// Decompile every function of the LOCAL annotated copy; write C and a call index.
// Args: <output-dir>
//@category RAC
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class DecompileAll extends GhidraScript {
    @Override
    public void run() throws Exception {
        File out = new File(getScriptArgs()[0]);
        new File(out, "c").mkdirs();
        DecompInterface d = new DecompInterface();
        d.openProgram(currentProgram);
        StringBuilder idx = new StringBuilder("[\n");
        int ok = 0, fail = 0, n = 0;
        for (Function f : currentProgram.getFunctionManager().getFunctions(true)) {
            if (monitor.isCancelled()) break;
            DecompileResults r = d.decompileFunction(f, 60, monitor);
            String c = r != null && r.decompileCompleted() && r.getDecompiledFunction() != null ? r.getDecompiledFunction().getC() : null;
            String rva = String.format("0x%x", f.getEntryPoint().getOffset());
            if (c != null) { Files.writeString(new File(out, "c/" + rva + ".c").toPath(), c, StandardCharsets.UTF_8); ok++; } else fail++;
            StringBuilder callees = new StringBuilder();
            for (Function cf : f.getCalledFunctions(monitor)) callees.append(callees.length() > 0 ? "," : "").append(String.format("\"0x%x\"", cf.getEntryPoint().getOffset()));
            idx.append(n++ > 0 ? ",\n" : "").append(String.format("{\"rva\":\"%s\",\"name\":\"%s\",\"size\":%d,\"decompiled\":%s,\"callees\":[%s]}",
                rva, f.getName(), f.getBody().getNumAddresses(), c != null, callees));
        }
        idx.append("\n]\n");
        Files.writeString(new File(out, "index.json").toPath(), idx.toString(), StandardCharsets.UTF_8);
        d.dispose();
        println("ALL decompiled ok=" + ok + " fail=" + fail);
        println("DECOMPILE_ALL_COMPLETE");
    }
}
