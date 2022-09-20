import idc

def text_seg_addr_start():
    for seg in Segments():
        if SegName(seg) == '__text':
            addr = hex(SegStart(seg))
            print("text segment address start: " + addr)
            return int(addr[0:-1], 16)

def text_seg_addr_end():
    for seg in Segments():
        if SegName(seg) == '__text':
            addr = hex(SegEnd(seg))
            print("text segment address end: " + addr)
            return int(addr[0:-1], 16)
        
start = text_seg_addr_start()
end = text_seg_addr_end()

while start < end:
    m = idc.print_insn_mnem(start)
    n = idc.print_operand(start, 0)
    if m == 'SVC' and n == '0x80':
        # print(idc.GetDisasm(start))
        if idc.print_operand(idc.prev_head(start), 1) == '#0x1A':
            idc.PatchDword(start, 0xD503201F)
            print("patch {} success!".format(hex(start)))
    start += 4
    
    
