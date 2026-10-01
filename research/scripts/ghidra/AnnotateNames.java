// Name LEVEL_01 functions on a guarded LOCAL copy from the class table and the
// engine map established on 2026-09-30, then re-export decompiled C with names.
// Names are tentative (prefix P_ for engine guesses); class slot names follow the
// descriptor order (slot 2 = pump-1 update, OBSERVED for 150/150).
// Args: <class-table.json> <output-dir>
//@category RAC
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import ghidra.program.model.symbol.SourceType;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class AnnotateNames extends GhidraScript {
    static final Object[][] ENGINE = {
        {0x1517CL, "P_MainUpdate_SharedDelta"}, {0x6B7F4L, "P_GroupPump1_EntityUpdates"},
        {0x6E6D4L, "P_GroupPump2"}, {0x2FFF0L, "P_Player_UpdateWrapper"}, {0x2FB8CL, "P_Player_SubstepLoop"},
        {0x360A4L, "P_Player_TimingFields"}, {0x1EBC4L, "P_Player_WeaponUpdate"},
        {0x8CC18L, "P_Particles_Walker"}, {0xDE23CL, "P_ParticleAnim_Waterfall"},
        {0x7E810L, "P_ParticleAnim_7E810"}, {0xDE8A8L, "P_ParticleAnim_DE8A8"},
        {0x28FFCL, "P_Nav_Step"}, {0x29098L, "P_Nav_MoveDispatch"}, {0x292C0L, "P_Nav_MoveForward"},
        {0x2A8F0L, "P_Nav_MoveByDisplacement"}, {0x76448L, "P_Anim_Setup"}, {0x76AA4L, "P_Anim_FireEvents"},
        {0x6AD50L, "P_Anim_Start"}, {0x191D7CL, "P_Shrapnel_Physics"}, {0x6C318L, "P_AnimDisplacement"},
        {0x6CF30L, "P_BoundsCentre"}, {0xA5AFCL, "P_HUD_RefreshHealth"}, {0x312ACL, "P_Player_GetHealth"},
        {0x14A74L, "P_DamageEvent"}, {0xEE9CL, "P_HitTest"}, {0x1A5F00L, "P_Sqrt"},
        {0x96650L, "P_VBlankWaitSite"}};

    @Override
    public void run() throws Exception {
        String[] args = getScriptArgs();
        String json = Files.readString(new File(args[0]).toPath(), StandardCharsets.UTF_8);
        File out = new File(args[1]);
        new File(out, "c").mkdirs();
        int named = 0;
        Matcher m = Pattern.compile("\"class\": \"([^\"]+)\",\\s*\"code\": \\[([^\\]]*)\\]").matcher(json);
        while (m.find()) {
            String cls = m.group(1);
            Matcher h = Pattern.compile("0x([0-9a-f]+)|null").matcher(m.group(2));
            int slot = 0;
            while (h.find()) {
                if (h.group(1) != null) {
                    String nm = slot == 2 ? cls + "_Update" : cls + "_slot" + slot;
                    if (rename(Long.parseLong(h.group(1), 16), nm)) named++;
                }
                slot++;
            }
        }
        for (Object[] e : ENGINE) if (rename((Long) e[0], (String) e[1])) named++;
        println("NAMES applied " + named);

        // re-export every function whose name we set plus their callees, with names
        DecompInterface d = new DecompInterface();
        d.openProgram(currentProgram);
        int ok = 0;
        for (Function f : currentProgram.getFunctionManager().getFunctions(true)) {
            if (monitor.isCancelled()) break;
            if (f.getName().startsWith("FUN_")) continue;
            DecompileResults r = d.decompileFunction(f, 60, monitor);
            if (r != null && r.decompileCompleted() && r.getDecompiledFunction() != null) {
                Files.writeString(new File(out, "c/" + String.format("0x%x_%s.c", f.getEntryPoint().getOffset(),
                    f.getName().replaceAll("[^A-Za-z0-9_]", "_"))).toPath(), r.getDecompiledFunction().getC(), StandardCharsets.UTF_8);
                ok++;
            }
        }
        d.dispose();
        println("NAMES exported " + ok);
        println("ANNOTATE_NAMES_COMPLETE");
    }

    boolean rename(long rva, String name) throws Exception {
        Function f = getFunctionAt(toAddr(rva));
        if (f == null) f = createFunction(toAddr(rva), null);
        if (f == null) return false;
        if (!f.getName().startsWith("FUN_") && !f.getName().startsWith("P_") && !f.getName().contains("_slot") && !f.getName().endsWith("_Update")) return false;
        f.setName(name, SourceType.USER_DEFINED);
        return true;
    }
}
