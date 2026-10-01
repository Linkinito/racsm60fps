// For each (function, literal) request, list instructions in the function whose
// scalar operand equals the literal (li/addiu/ori/slti/...), on the LOCAL copy.
// Args: <requests.json: [{"fn":"0x12461c","literals":["0x2d"]}, ...]> <out.json>
//@category RAC
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.scalar.Scalar;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FindImmediates extends GhidraScript {
    @Override
    public void run() throws Exception {
        String[] a = getScriptArgs();
        String req = Files.readString(new File(a[0]).toPath(), StandardCharsets.UTF_8);
        StringBuilder out = new StringBuilder("[\n");
        Matcher m = Pattern.compile("\\{\"fn\":\\s*\"0x([0-9a-f]+)\",\\s*\"literals\":\\s*\\[([^\\]]*)\\]\\}").matcher(req);
        int n = 0;
        while (m.find()) {
            Function f = getFunctionAt(toAddr(Long.parseLong(m.group(1), 16)));
            if (f == null) continue;
            Matcher l = Pattern.compile("\"(0x[0-9a-f]+|\\d+)\"").matcher(m.group(2));
            while (l.find()) {
                long want = Long.decode(l.group(1));
                for (Instruction ins : currentProgram.getListing().getInstructions(f.getBody(), true)) {
                    for (int i = 0; i < ins.getNumOperands(); i++) {
                        for (Object o : ins.getOpObjects(i)) {
                            if (o instanceof Scalar && ((Scalar) o).getUnsignedValue() == want) {
                                out.append(n++ > 0 ? ",\n" : "").append(String.format(
                                    "{\"fn\":\"0x%s\",\"literal\":\"%s\",\"site\":\"0x%x\",\"word\":\"0x%08x\",\"text\":\"%s\"}",
                                    m.group(1), l.group(1), ins.getAddress().getOffset(),
                                    currentProgram.getMemory().getInt(ins.getAddress()) & 0xffffffffL,
                                    ins.toString().replace("\"", "'")));
                            }
                        }
                    }
                }
            }
        }
        out.append("\n]\n");
        Files.writeString(new File(a[1]).toPath(), out.toString(), StandardCharsets.UTF_8);
        println("FIND_IMMEDIATES_COMPLETE " + n);
    }
}
