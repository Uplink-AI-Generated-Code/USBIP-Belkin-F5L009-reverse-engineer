# Ghidra script: apply symbols.txt to the reconstructed-RAM program.
# Load ram_reconstructed.bin as ARM:LE:32 Cortex (or ARMv5T), image base 0x0,
# then run this script (Script Manager). It renames/creates functions in Thumb.
# @category F5L009
import re, os

sym_path = os.path.join(os.path.dirname(getSourceFile().getAbsolutePath()), "symbols.txt") \
    if hasattr(getSourceFile(), "getAbsolutePath") else "symbols.txt"
try:
    lines = open(sym_path).read().splitlines()
except Exception:
    lines = open("symbols.txt").read().splitlines()

fm = currentProgram.getFunctionManager()
st = currentProgram.getSymbolTable()
af = currentProgram.getAddressFactory().getDefaultAddressSpace()
from ghidra.program.model.symbol import SourceType

applied = 0
for ln in lines:
    ln = ln.split("#", 1)[0].strip()
    m = re.match(r"(0x[0-9A-Fa-f]+)\s+(\S+)", ln)
    if not m:
        continue
    addr = af.getAddress(long(m.group(1), 16))
    name = m.group(2)
    fn = fm.getFunctionAt(addr)
    try:
        if fn is not None:
            fn.setName(name, SourceType.USER_DEFINED)
        else:
            # create a Thumb function if none exists, else just a label
            fn = createFunction(addr, name)
            if fn is None:
                st.createLabel(addr, name, SourceType.USER_DEFINED)
        applied += 1
    except Exception as e:
        print("skip %s %s: %s" % (m.group(1), name, e))

print("applied %d symbols" % applied)
