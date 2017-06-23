9650 // Intel 8250 serial port (UART).
9651 
9652 #include "types.h"
9653 #include "defs.h"
9654 #include "param.h"
9655 #include "traps.h"
9656 #include "spinlock.h"
9657 #include "sleeplock.h"
9658 #include "fs.h"
9659 #include "file.h"
9660 #include "mmu.h"
9661 #include "proc.h"
9662 #include "x86.h"
9663 
9664 #define COM1    0x3f8
9665 
9666 static int uart;    // is there a uart?
9667 
9668 void
9669 uartinit(void)
9670 {
9671   char *p;
9672 
9673   // Turn off the FIFO
9674   outb(COM1+2, 0);
9675 
9676   // 9600 baud, 8 data bits, 1 stop bit, parity off.
9677   outb(COM1+3, 0x80);    // Unlock divisor
9678   outb(COM1+0, 115200/9600);
9679   outb(COM1+1, 0);
9680   outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
9681   outb(COM1+4, 0);
9682   outb(COM1+1, 0x01);    // Enable receive interrupts.
9683 
9684   // If status is 0xFF, no serial port.
9685   if(inb(COM1+5) == 0xFF)
9686     return;
9687   uart = 1;
9688 
9689   // Acknowledge pre-existing interrupt conditions;
9690   // enable interrupts.
9691   inb(COM1+2);
9692   inb(COM1+0);
9693   picenable(IRQ_COM1);
9694   ioapicenable(IRQ_COM1, 0);
9695 
9696   // Announce that we're here.
9697   for(p="xv6...\n"; *p; p++)
9698     uartputc(*p);
9699 }
9700 void
9701 uartputc(int c)
9702 {
9703   int i;
9704 
9705   if(!uart)
9706     return;
9707   for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
9708     microdelay(10);
9709   outb(COM1+0, c);
9710 }
9711 
9712 static int
9713 uartgetc(void)
9714 {
9715   if(!uart)
9716     return -1;
9717   if(!(inb(COM1+5) & 0x01))
9718     return -1;
9719   return inb(COM1+0);
9720 }
9721 
9722 void
9723 uartintr(void)
9724 {
9725   consoleintr(uartgetc);
9726 }
9727 
9728 
9729 
9730 
9731 
9732 
9733 
9734 
9735 
9736 
9737 
9738 
9739 
9740 
9741 
9742 
9743 
9744 
9745 
9746 
9747 
9748 
9749 
