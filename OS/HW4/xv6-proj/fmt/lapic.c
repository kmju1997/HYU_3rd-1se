8400 // The local APIC manages internal (non-I/O) interrupts.
8401 // See Chapter 8 & Appendix C of Intel processor manual volume 3.
8402 
8403 #include "param.h"
8404 #include "types.h"
8405 #include "defs.h"
8406 #include "date.h"
8407 #include "memlayout.h"
8408 #include "traps.h"
8409 #include "mmu.h"
8410 #include "x86.h"
8411 #include "proc.h"  // ncpu
8412 
8413 // Local APIC registers, divided by 4 for use as uint[] indices.
8414 #define ID      (0x0020/4)   // ID
8415 #define VER     (0x0030/4)   // Version
8416 #define TPR     (0x0080/4)   // Task Priority
8417 #define EOI     (0x00B0/4)   // EOI
8418 #define SVR     (0x00F0/4)   // Spurious Interrupt Vector
8419   #define ENABLE     0x00000100   // Unit Enable
8420 #define ESR     (0x0280/4)   // Error Status
8421 #define ICRLO   (0x0300/4)   // Interrupt Command
8422   #define INIT       0x00000500   // INIT/RESET
8423   #define STARTUP    0x00000600   // Startup IPI
8424   #define DELIVS     0x00001000   // Delivery status
8425   #define ASSERT     0x00004000   // Assert interrupt (vs deassert)
8426   #define DEASSERT   0x00000000
8427   #define LEVEL      0x00008000   // Level triggered
8428   #define BCAST      0x00080000   // Send to all APICs, including self.
8429   #define BUSY       0x00001000
8430   #define FIXED      0x00000000
8431 #define ICRHI   (0x0310/4)   // Interrupt Command [63:32]
8432 #define TIMER   (0x0320/4)   // Local Vector Table 0 (TIMER)
8433   #define X1         0x0000000B   // divide counts by 1
8434   #define PERIODIC   0x00020000   // Periodic
8435 #define PCINT   (0x0340/4)   // Performance Counter LVT
8436 #define LINT0   (0x0350/4)   // Local Vector Table 1 (LINT0)
8437 #define LINT1   (0x0360/4)   // Local Vector Table 2 (LINT1)
8438 #define ERROR   (0x0370/4)   // Local Vector Table 3 (ERROR)
8439   #define MASKED     0x00010000   // Interrupt masked
8440 #define TICR    (0x0380/4)   // Timer Initial Count
8441 #define TCCR    (0x0390/4)   // Timer Current Count
8442 #define TDCR    (0x03E0/4)   // Timer Divide Configuration
8443 
8444 volatile uint *lapic;  // Initialized in mp.c
8445 
8446 
8447 
8448 
8449 
8450 static void
8451 lapicw(int index, int value)
8452 {
8453   lapic[index] = value;
8454   lapic[ID];  // wait for write to finish, by reading
8455 }
8456 
8457 
8458 
8459 
8460 
8461 
8462 
8463 
8464 
8465 
8466 
8467 
8468 
8469 
8470 
8471 
8472 
8473 
8474 
8475 
8476 
8477 
8478 
8479 
8480 
8481 
8482 
8483 
8484 
8485 
8486 
8487 
8488 
8489 
8490 
8491 
8492 
8493 
8494 
8495 
8496 
8497 
8498 
8499 
8500 void
8501 lapicinit(void)
8502 {
8503   if(!lapic)
8504     return;
8505 
8506   // Enable local APIC; set spurious interrupt vector.
8507   lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8508 
8509   // The timer repeatedly counts down at bus frequency
8510   // from lapic[TICR] and then issues an interrupt.
8511   // If xv6 cared more about precise timekeeping,
8512   // TICR would be calibrated using an external time source.
8513   lapicw(TDCR, X1);
8514   lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8515   lapicw(TICR, 10000000);
8516 
8517   // Disable logical interrupt lines.
8518   lapicw(LINT0, MASKED);
8519   lapicw(LINT1, MASKED);
8520 
8521   // Disable performance counter overflow interrupts
8522   // on machines that provide that interrupt entry.
8523   if(((lapic[VER]>>16) & 0xFF) >= 4)
8524     lapicw(PCINT, MASKED);
8525 
8526   // Map error interrupt to IRQ_ERROR.
8527   lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8528 
8529   // Clear error status register (requires back-to-back writes).
8530   lapicw(ESR, 0);
8531   lapicw(ESR, 0);
8532 
8533   // Ack any outstanding interrupts.
8534   lapicw(EOI, 0);
8535 
8536   // Send an Init Level De-Assert to synchronise arbitration ID's.
8537   lapicw(ICRHI, 0);
8538   lapicw(ICRLO, BCAST | INIT | LEVEL);
8539   while(lapic[ICRLO] & DELIVS)
8540     ;
8541 
8542   // Enable interrupts on the APIC (but not on the processor).
8543   lapicw(TPR, 0);
8544 }
8545 
8546 
8547 
8548 
8549 
8550 int
8551 cpunum(void)
8552 {
8553   int apicid, i;
8554 
8555   // Cannot call cpu when interrupts are enabled:
8556   // result not guaranteed to last long enough to be used!
8557   // Would prefer to panic but even printing is chancy here:
8558   // almost everything, including cprintf and panic, calls cpu,
8559   // often indirectly through acquire and release.
8560   if(readeflags()&FL_IF){
8561     static int n;
8562     if(n++ == 0)
8563       cprintf("cpu called from %x with interrupts enabled\n",
8564         __builtin_return_address(0));
8565   }
8566 
8567   if (!lapic)
8568     return 0;
8569 
8570   apicid = lapic[ID] >> 24;
8571   for (i = 0; i < ncpu; ++i) {
8572     if (cpus[i].apicid == apicid)
8573       return i;
8574   }
8575   panic("unknown apicid\n");
8576 }
8577 
8578 // Acknowledge interrupt.
8579 void
8580 lapiceoi(void)
8581 {
8582   if(lapic)
8583     lapicw(EOI, 0);
8584 }
8585 
8586 // Spin for a given number of microseconds.
8587 // On real hardware would want to tune this dynamically.
8588 void
8589 microdelay(int us)
8590 {
8591 }
8592 
8593 
8594 
8595 
8596 
8597 
8598 
8599 
8600 #define CMOS_PORT    0x70
8601 #define CMOS_RETURN  0x71
8602 
8603 // Start additional processor running entry code at addr.
8604 // See Appendix B of MultiProcessor Specification.
8605 void
8606 lapicstartap(uchar apicid, uint addr)
8607 {
8608   int i;
8609   ushort *wrv;
8610 
8611   // "The BSP must initialize CMOS shutdown code to 0AH
8612   // and the warm reset vector (DWORD based at 40:67) to point at
8613   // the AP startup code prior to the [universal startup algorithm]."
8614   outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8615   outb(CMOS_PORT+1, 0x0A);
8616   wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8617   wrv[0] = 0;
8618   wrv[1] = addr >> 4;
8619 
8620   // "Universal startup algorithm."
8621   // Send INIT (level-triggered) interrupt to reset other CPU.
8622   lapicw(ICRHI, apicid<<24);
8623   lapicw(ICRLO, INIT | LEVEL | ASSERT);
8624   microdelay(200);
8625   lapicw(ICRLO, INIT | LEVEL);
8626   microdelay(100);    // should be 10ms, but too slow in Bochs!
8627 
8628   // Send startup IPI (twice!) to enter code.
8629   // Regular hardware is supposed to only accept a STARTUP
8630   // when it is in the halted state due to an INIT.  So the second
8631   // should be ignored, but it is part of the official Intel algorithm.
8632   // Bochs complains about the second one.  Too bad for Bochs.
8633   for(i = 0; i < 2; i++){
8634     lapicw(ICRHI, apicid<<24);
8635     lapicw(ICRLO, STARTUP | (addr>>12));
8636     microdelay(200);
8637   }
8638 }
8639 
8640 
8641 
8642 
8643 
8644 
8645 
8646 
8647 
8648 
8649 
8650 #define CMOS_STATA   0x0a
8651 #define CMOS_STATB   0x0b
8652 #define CMOS_UIP    (1 << 7)        // RTC update in progress
8653 
8654 #define SECS    0x00
8655 #define MINS    0x02
8656 #define HOURS   0x04
8657 #define DAY     0x07
8658 #define MONTH   0x08
8659 #define YEAR    0x09
8660 
8661 static uint cmos_read(uint reg)
8662 {
8663   outb(CMOS_PORT,  reg);
8664   microdelay(200);
8665 
8666   return inb(CMOS_RETURN);
8667 }
8668 
8669 static void fill_rtcdate(struct rtcdate *r)
8670 {
8671   r->second = cmos_read(SECS);
8672   r->minute = cmos_read(MINS);
8673   r->hour   = cmos_read(HOURS);
8674   r->day    = cmos_read(DAY);
8675   r->month  = cmos_read(MONTH);
8676   r->year   = cmos_read(YEAR);
8677 }
8678 
8679 // qemu seems to use 24-hour GWT and the values are BCD encoded
8680 void cmostime(struct rtcdate *r)
8681 {
8682   struct rtcdate t1, t2;
8683   int sb, bcd;
8684 
8685   sb = cmos_read(CMOS_STATB);
8686 
8687   bcd = (sb & (1 << 2)) == 0;
8688 
8689   // make sure CMOS doesn't modify time while we read it
8690   for(;;) {
8691     fill_rtcdate(&t1);
8692     if(cmos_read(CMOS_STATA) & CMOS_UIP)
8693         continue;
8694     fill_rtcdate(&t2);
8695     if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8696       break;
8697   }
8698 
8699 
8700   // convert
8701   if(bcd) {
8702 #define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
8703     CONV(second);
8704     CONV(minute);
8705     CONV(hour  );
8706     CONV(day   );
8707     CONV(month );
8708     CONV(year  );
8709 #undef     CONV
8710   }
8711 
8712   *r = t1;
8713   r->year += 2000;
8714 }
8715 
8716 
8717 
8718 
8719 
8720 
8721 
8722 
8723 
8724 
8725 
8726 
8727 
8728 
8729 
8730 
8731 
8732 
8733 
8734 
8735 
8736 
8737 
8738 
8739 
8740 
8741 
8742 
8743 
8744 
8745 
8746 
8747 
8748 
8749 
