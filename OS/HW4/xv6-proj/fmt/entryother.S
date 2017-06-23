1250 #include "asm.h"
1251 #include "memlayout.h"
1252 #include "mmu.h"
1253 
1254 # Each non-boot CPU ("AP") is started up in response to a STARTUP
1255 # IPI from the boot CPU.  Section B.4.2 of the Multi-Processor
1256 # Specification says that the AP will start in real mode with CS:IP
1257 # set to XY00:0000, where XY is an 8-bit value sent with the
1258 # STARTUP. Thus this code must start at a 4096-byte boundary.
1259 #
1260 # Because this code sets DS to zero, it must sit
1261 # at an address in the low 2^16 bytes.
1262 #
1263 # Startothers (in main.c) sends the STARTUPs one at a time.
1264 # It copies this code (start) at 0x7000.  It puts the address of
1265 # a newly allocated per-core stack in start-4,the address of the
1266 # place to jump to (mpenter) in start-8, and the physical address
1267 # of entrypgdir in start-12.
1268 #
1269 # This code combines elements of bootasm.S and entry.S.
1270 
1271 .code16
1272 .globl start
1273 start:
1274   cli
1275 
1276   # Zero data segment registers DS, ES, and SS.
1277   xorw    %ax,%ax
1278   movw    %ax,%ds
1279   movw    %ax,%es
1280   movw    %ax,%ss
1281 
1282   # Switch from real to protected mode.  Use a bootstrap GDT that makes
1283   # virtual addresses map directly to physical addresses so that the
1284   # effective memory map doesn't change during the transition.
1285   lgdt    gdtdesc
1286   movl    %cr0, %eax
1287   orl     $CR0_PE, %eax
1288   movl    %eax, %cr0
1289 
1290   # Complete the transition to 32-bit protected mode by using a long jmp
1291   # to reload %cs and %eip.  The segment descriptors are set up with no
1292   # translation, so that the mapping is still the identity mapping.
1293   ljmpl    $(SEG_KCODE<<3), $(start32)
1294 
1295 
1296 
1297 
1298 
1299 
1300 .code32  # Tell assembler to generate 32-bit code now.
1301 start32:
1302   # Set up the protected-mode data segment registers
1303   movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
1304   movw    %ax, %ds                # -> DS: Data Segment
1305   movw    %ax, %es                # -> ES: Extra Segment
1306   movw    %ax, %ss                # -> SS: Stack Segment
1307   movw    $0, %ax                 # Zero segments not ready for use
1308   movw    %ax, %fs                # -> FS
1309   movw    %ax, %gs                # -> GS
1310 
1311   # Turn on page size extension for 4Mbyte pages
1312   movl    %cr4, %eax
1313   orl     $(CR4_PSE), %eax
1314   movl    %eax, %cr4
1315   # Use entrypgdir as our initial page table
1316   movl    (start-12), %eax
1317   movl    %eax, %cr3
1318   # Turn on paging.
1319   movl    %cr0, %eax
1320   orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
1321   movl    %eax, %cr0
1322 
1323   # Switch to the stack allocated by startothers()
1324   movl    (start-4), %esp
1325   # Call mpenter()
1326   call	 *(start-8)
1327 
1328   movw    $0x8a00, %ax
1329   movw    %ax, %dx
1330   outw    %ax, %dx
1331   movw    $0x8ae0, %ax
1332   outw    %ax, %dx
1333 spin:
1334   jmp     spin
1335 
1336 .p2align 2
1337 gdt:
1338   SEG_NULLASM
1339   SEG_ASM(STA_X|STA_R, 0, 0xffffffff)
1340   SEG_ASM(STA_W, 0, 0xffffffff)
1341 
1342 
1343 gdtdesc:
1344   .word   (gdtdesc - gdt - 1)
1345   .long   gdt
1346 
1347 
1348 
1349 
