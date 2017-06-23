10550 // Boot loader.
10551 //
10552 // Part of the boot block, along with bootasm.S, which calls bootmain().
10553 // bootasm.S has put the processor into protected 32-bit mode.
10554 // bootmain() loads an ELF kernel image from the disk starting at
10555 // sector 1 and then jumps to the kernel entry routine.
10556 
10557 #include "types.h"
10558 #include "elf.h"
10559 #include "x86.h"
10560 #include "memlayout.h"
10561 
10562 #define SECTSIZE  512
10563 
10564 void readseg(uchar*, uint, uint);
10565 
10566 void
10567 bootmain(void)
10568 {
10569   struct elfhdr *elf;
10570   struct proghdr *ph, *eph;
10571   void (*entry)(void);
10572   uchar* pa;
10573 
10574   elf = (struct elfhdr*)0x10000;  // scratch space
10575 
10576   // Read 1st page off disk
10577   readseg((uchar*)elf, 4096, 0);
10578 
10579   // Is this an ELF executable?
10580   if(elf->magic != ELF_MAGIC)
10581     return;  // let bootasm.S handle error
10582 
10583   // Load each program segment (ignores ph flags).
10584   ph = (struct proghdr*)((uchar*)elf + elf->phoff);
10585   eph = ph + elf->phnum;
10586   for(; ph < eph; ph++){
10587     pa = (uchar*)ph->paddr;
10588     readseg(pa, ph->filesz, ph->off);
10589     if(ph->memsz > ph->filesz)
10590       stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
10591   }
10592 
10593   // Call the entry point from the ELF header.
10594   // Does not return!
10595   entry = (void(*)(void))(elf->entry);
10596   entry();
10597 }
10598 
10599 
10600 void
10601 waitdisk(void)
10602 {
10603   // Wait for disk ready.
10604   while((inb(0x1F7) & 0xC0) != 0x40)
10605     ;
10606 }
10607 
10608 // Read a single sector at offset into dst.
10609 void
10610 readsect(void *dst, uint offset)
10611 {
10612   // Issue command.
10613   waitdisk();
10614   outb(0x1F2, 1);   // count = 1
10615   outb(0x1F3, offset);
10616   outb(0x1F4, offset >> 8);
10617   outb(0x1F5, offset >> 16);
10618   outb(0x1F6, (offset >> 24) | 0xE0);
10619   outb(0x1F7, 0x20);  // cmd 0x20 - read sectors
10620 
10621   // Read data.
10622   waitdisk();
10623   insl(0x1F0, dst, SECTSIZE/4);
10624 }
10625 
10626 // Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
10627 // Might copy more than asked.
10628 void
10629 readseg(uchar* pa, uint count, uint offset)
10630 {
10631   uchar* epa;
10632 
10633   epa = pa + count;
10634 
10635   // Round down to sector boundary.
10636   pa -= offset % SECTSIZE;
10637 
10638   // Translate from bytes to sectors; kernel starts at sector 1.
10639   offset = (offset / SECTSIZE) + 1;
10640 
10641   // If this is too slow, we could read lots of sectors at a time.
10642   // We'd write more to memory than asked, but it doesn't matter --
10643   // we load in increasing order.
10644   for(; pa < epa; pa += SECTSIZE, offset++)
10645     readsect(pa, offset);
10646 }
10647 
10648 
10649 
