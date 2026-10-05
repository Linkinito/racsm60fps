// Targeted decompilation in a read-only headless session; no matching/annotations.
// Raw outputs stay local. The caller must use -readOnly -noanalysis.
// @category RAC.Damage
import ghidra.app.script.GhidraScript;
import ghidra.app.cmd.disassemble.DisassembleCommand;
import ghidra.app.cmd.function.CreateFunctionCmd;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.mem.MemoryBlock;
import ghidra.program.model.symbol.SourceType;
import com.google.gson.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.security.MessageDigest;
import java.util.*;

public class ExportDamageSlice extends GhidraScript {
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private static String sha(byte[] data) throws Exception {
        return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(data));
    }
    private Map<String,String> memoryHashes() throws Exception {
        Map<String,String> hashes = new TreeMap<>();
        byte[] chunk = new byte[65536];
        for (MemoryBlock block : currentProgram.getMemory().getBlocks()) {
            if (!block.isInitialized()) continue;
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            long remaining = block.getSize(); Address at = block.getStart();
            while (remaining > 0) {
                int count = (int)Math.min(remaining, chunk.length);
                int got = currentProgram.getMemory().getBytes(at, chunk,0,count);
                if (got != count) throw new IllegalStateException("Short memory read");
                digest.update(chunk,0,count); at = at.add(count); remaining -= count;
            }
            hashes.put(block.getName()+":"+block.getStart(),HexFormat.of().formatHex(digest.digest()));
        }
        return hashes;
    }
    @Override public void run() throws Exception {
        String[] args = getScriptArgs();
        if (args.length != 4 || !"READONLY_DISCARD".equals(args[3]))
            throw new IllegalArgumentException("expected-sha recipe output READONLY_DISCARD");
        if (!args[0].equalsIgnoreCase(currentProgram.getExecutableSHA256()) ||
            !"Allegrex:LE:32:default".equals(currentProgram.getLanguageID().toString()) ||
            currentProgram.getImageBase().getOffset() != 0)
            throw new IllegalStateException("Source identity mismatch");
        Path recipePath = Path.of(args[1]).toAbsolutePath().normalize();
        Path out = Path.of(args[2]).toAbsolutePath().normalize();
        if (!out.toString().replace('\\','/').contains("/research/v2/decomp-candidates/_local/"))
            throw new IllegalArgumentException("Raw exports must stay ignored/local");
        if (Files.exists(out.resolve("manifest.json"))) throw new IllegalArgumentException("Preserve prior output");
        JsonObject recipe = JsonParser.parseString(Files.readString(recipePath)).getAsJsonObject();
        JsonArray requested = recipe.getAsJsonArray("functions");
        if (requested.size() < 1 || requested.size() > 16) throw new IllegalArgumentException("Bounded slice required");
        Map<String,String> before = memoryHashes();
        int initialFunctions = currentProgram.getFunctionManager().getFunctionCount();
        MemoryBlock text = currentProgram.getMemory().getBlock(".text");
        AddressSet textRange = new AddressSet(text.getStart(),text.getEnd());
        Files.createDirectories(out);
        for (JsonElement item : requested) {
            JsonObject request = item.getAsJsonObject();
            long rva = Long.decode(request.get("rva").getAsString());
            if (!request.has("entryEvidence") || request.get("entryEvidence").getAsString().isBlank() ||
                (rva&3)!=0 || !textRange.contains(toAddr(rva))) throw new IllegalArgumentException("Unbound entry");
            Address entry = toAddr(rva);
            if (getFunctionAt(entry)==null) {
                if (getFunctionContaining(entry)!=null) throw new IllegalStateException("Overlapping entry "+entry);
                if (!new DisassembleCommand(entry,textRange,true).applyTo(currentProgram,monitor))
                    throw new IllegalStateException("Disassembly failed "+entry);
                if (!new CreateFunctionCmd("FUN_"+entry,entry,null,SourceType.ANALYSIS).applyTo(currentProgram,monitor))
                    throw new IllegalStateException("Function definition failed "+entry);
            }
        }
        DecompInterface decompiler = new DecompInterface();
        if (!decompiler.openProgram(currentProgram)) throw new IllegalStateException("Decompiler open failed");
        List<Object> rows = new ArrayList<>();
        try {
            for (JsonElement item : requested) {
                monitor.checkCancelled(); JsonObject request = item.getAsJsonObject();
                long rva = Long.decode(request.get("rva").getAsString()); Function f = getFunctionAt(toAddr(rva));
                DecompileResults result = decompiler.decompileFunction(f,90,monitor);
                if (!result.decompileCompleted() || result.getDecompiledFunction()==null)
                    throw new IllegalStateException("Decompilation failed "+f.getEntryPoint()+":"+result.getErrorMessage());
                String stem = String.format("%08x",rva);
                byte[] c = result.getDecompiledFunction().getC().getBytes(StandardCharsets.UTF_8);
                Files.write(out.resolve(stem+".c"),c);
                StringBuilder listing = new StringBuilder();
                for (Instruction i : currentProgram.getListing().getInstructions(f.getBody(),true))
                    listing.append(i.getAddress()).append('\t').append(i).append('\n');
                byte[] instructions = listing.toString().getBytes(StandardCharsets.UTF_8);
                Files.write(out.resolve(stem+".instructions.txt"),instructions);
                rows.add(Map.of("rva",String.format("0x%x",rva),"bodyBytes",f.getBody().getNumAddresses(),
                    "bodyMin",f.getBody().getMinAddress().toString(),"bodyMax",f.getBody().getMaxAddress().toString(),
                    "entryEvidence",request.get("entryEvidence").getAsString(),"cSha256",sha(c),
                    "instructionsSha256",sha(instructions),"decompiled",true));
            }
        } finally { decompiler.dispose(); }
        Map<String,String> after = memoryHashes();
        if (!before.equals(after)) throw new IllegalStateException("Initialized memory changed");
        Map<String,Object> manifest = new LinkedHashMap<>();
        manifest.put("module",currentProgram.getName()); manifest.put("programSha256",args[0]);
        manifest.put("recipeSha256",sha(Files.readAllBytes(recipePath)));
        manifest.put("mode","READONLY_HEADLESS_DISCARD_REQUIRED");
        manifest.put("initialFunctionCount",initialFunctions);
        manifest.put("ephemeralFunctionCount",currentProgram.getFunctionManager().getFunctionCount());
        manifest.put("initializedBefore",before); manifest.put("initializedAfter",after);
        manifest.put("functions",rows);
        Files.writeString(out.resolve("manifest.json"),gson.toJson(manifest)+"\n",StandardCharsets.UTF_8);
        println("DAMAGE_SLICE_COMPLETE "+currentProgram.getName()+" functions="+rows.size()+" bytes unchanged");
    }
}
