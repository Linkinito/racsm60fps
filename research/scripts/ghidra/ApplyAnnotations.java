// Apply level01-annotations.json (names, plate and address comments) to the LOCAL Ghidra copy.
// Functions: renamed only when the current name is a default FUN_ name or the entry gives a
// name; the plate comment is replaced by "[Overcompensated] <text>" (idempotent).
// Addresses: EOL comment "[OC] <text>". Then re-exports decompiled C for annotated functions.
// Args: <annotations.json> <export-dir>
//@category RAC
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.CodeUnit;
import ghidra.program.model.listing.Function;
import ghidra.program.model.symbol.SourceType;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Map;

public class ApplyAnnotations extends GhidraScript {
    @Override
    public void run() throws Exception {
        String[] a = getScriptArgs();
        JsonObject root = JsonParser.parseString(Files.readString(new File(a[0]).toPath(), StandardCharsets.UTF_8)).getAsJsonObject();
        File out = new File(a[1]); out.mkdirs();
        DecompInterface dec = new DecompInterface(); dec.openProgram(currentProgram);
        int named = 0, plates = 0, eol = 0, created = 0;
        for (Map.Entry<String, JsonElement> e : root.getAsJsonObject("functions").entrySet()) {
            Address at = toAddr(Long.decode(e.getKey()));
            JsonObject v = e.getValue().getAsJsonObject();
            Function f = getFunctionAt(at);
            if (f == null) { f = createFunction(at, null); if (f == null) continue; created++; }
            if (v.has("name") && !v.get("name").isJsonNull()) {
                String n = v.get("name").getAsString();
                if (!f.getName().equals(n)) { f.setName(n, SourceType.USER_DEFINED); named++; }
            }
            String text = "[Overcompensated] " + v.get("comment").getAsString();
            f.setComment(text); plates++;
            DecompileResults r = dec.decompileFunction(f, 60, monitor);
            if (r.decompileCompleted())
                Files.writeString(new File(out, e.getKey() + "_" + f.getName() + ".c").toPath(),
                    "/* " + text + " */\n" + r.getDecompiledFunction().getC(), StandardCharsets.UTF_8);
        }
        for (Map.Entry<String, JsonElement> e : root.getAsJsonObject("addresses").entrySet()) {
            Address at = toAddr(Long.decode(e.getKey()));
            currentProgram.getListing().setComment(at, CodeUnit.EOL_COMMENT, "[OC] " + e.getValue().getAsString());
            eol++;
        }
        println("APPLY_ANNOTATIONS named=" + named + " plates=" + plates + " created=" + created + " eol=" + eol);
    }
}
