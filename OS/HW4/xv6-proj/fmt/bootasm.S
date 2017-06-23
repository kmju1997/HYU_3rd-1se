10450 #include "asm.h"
10451 #include "memlayout.h"
10452 #include "mmu.h"
10453 
10454 # Start the first CPU: switch to 32-bit protected mode, jump into C.
10455 # The BIOS loads this code from the first sector of the hard disk into
10456 # memory at physical address 0x7c00 and starts executing in real mode
10457 # with %cs=0 %ip=7c00.
10458 
10459 .code16                       # Assemble for 16-bit mode
10460 .globl start
10461 start:
10462   cli                         # BIOS enabled interrupts; disable
10463 
10464   # Zero data segment registers DS, ES, and SS.
10465   xorw    %ax,%ax             # Set %ax to zero
10466   movw    %ax,%ds             # -> Data Segment
10467   movw    %ax,%es             # -> Extra Segment
10468   movw    %ax,%ss             # -> Stack Segment
10469 
10470   # Physical address line A20 is tied to zero so that the first PCs
10471   # with 2 MB would run software that assumed 1 MB.  Undo that.
10472 seta20.1:
10473   inb     $0x64,%al               # Wait for not busy
10474   testb   $0x2,%al
10475   jnz     seta20.1
10476 
10477   movb    $0xd1,%al               # 0xd1 -> port 0x64
10478   outb    %al,$0x64
10479 
10480 seta20.2:
10481   inb     $0x64,%al               # Wait for not busy
10482   testb   $0x2,%al
10483   jnz     seta20.2
10484 
10485   movb    $0xdf,%al               # 0xdf -> port 0x60
10486   outb    %al,$0x60
10487 
10488   # Switch from real to protected mode.  Use a bootstrap GDT that makes
10489   # virtual addresses map directly to physical addresses so that the
10490   # effective memory map doesn't change during the transition.
10491   lgdt    gdtdesc
10492   movl    %cr0, %eax
10493   orl     $CR0_PE, %eax
10494   movl    %eax, %cr0
10495 
10496 
10497 
10498 
10499 
10500   # Complete the transition to 32-bit protected mode by using a long jmp
10501   # to reload %cs and %eip.  The segment descriptors are set up with no
10502   # translation, so that the mapping is still the identity mapping.
10503   ljmp    $(SEG_KCODE<<3), $start32
10504 
10505 .code32  # Tell assembler to generate 32-bit code now.
10506 start32:
10507   # Set up the protected-mode data segment registers
10508   movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
10509   movw    %ax, %ds                # -> DS: Data Segment
10510   movw    %ax, %es                # -> ES: Extra Segment
10511   movw    %ax, %ss                # -> SS: Stack Segment
10512   movw    $0, %ax                 # Zero segments not ready for use
10513   movw    %ax, %fs                # -> FS
10514   movw    %ax, %gs                # -> GS
10515 
10516   # Set up the stack pointer and call into C.
10517   movl    $start, %esp
10518   call    bootmain
10519 
10520   # If bootmain returns (it shouldn't), trigger a Bochs
10521   # breakpoint if running under Bochs, then loop.
10522   movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
10523   movw    %ax, %dx
10524   outw    %ax, %dx
10525   movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
10526   outw    %ax, %dx
10527 spin:
10528   jmp     spin
10529 
10530 # Bootstrap GDT
10531 .p2align 2                                # force 4 byte alignment
10532 gdt:
10533   SEG_NULLASM                             # null seg
10534   SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)   # code seg
10535   SEG_ASM(STA_W, 0x0, 0xffffffff)         # data seg
10536 
10537 gdtdesc:
10538   .word   (gdtdesc - gdt - 1)             # sizeof(gdt) - 1
10539   .long   gdt                             # address gdt
10540 
10541 
10542 
10543 
10544 
10545 
10546 
10547 
10548 
10549 
