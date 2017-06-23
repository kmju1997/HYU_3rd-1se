9600 // Intel 8253/8254/82C54 Programmable Interval Timer (PIT).
9601 // Only used on uniprocessors;
9602 // SMP machines use the local APIC timer.
9603 
9604 #include "types.h"
9605 #include "defs.h"
9606 #include "traps.h"
9607 #include "x86.h"
9608 
9609 #define IO_TIMER1       0x040           // 8253 Timer #1
9610 
9611 // Frequency of all three count-down timers;
9612 // (TIMER_FREQ/freq) is the appropriate count
9613 // to generate a frequency of freq Hz.
9614 
9615 #define TIMER_FREQ      1193182
9616 #define TIMER_DIV(x)    ((TIMER_FREQ+(x)/2)/(x))
9617 
9618 #define TIMER_MODE      (IO_TIMER1 + 3) // timer mode port
9619 #define TIMER_SEL0      0x00    // select counter 0
9620 #define TIMER_RATEGEN   0x04    // mode 2, rate generator
9621 #define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first
9622 
9623 void
9624 timerinit(void)
9625 {
9626   // Interrupt 100 times/sec.
9627   outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
9628   outb(IO_TIMER1, TIMER_DIV(100) % 256);
9629   outb(IO_TIMER1, TIMER_DIV(100) / 256);
9630   picenable(IRQ_TIMER);
9631 }
9632 
9633 
9634 
9635 
9636 
9637 
9638 
9639 
9640 
9641 
9642 
9643 
9644 
9645 
9646 
9647 
9648 
9649 
