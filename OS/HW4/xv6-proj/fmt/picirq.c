8850 // Intel 8259A programmable interrupt controllers.
8851 
8852 #include "types.h"
8853 #include "x86.h"
8854 #include "traps.h"
8855 
8856 // I/O Addresses of the two programmable interrupt controllers
8857 #define IO_PIC1         0x20    // Master (IRQs 0-7)
8858 #define IO_PIC2         0xA0    // Slave (IRQs 8-15)
8859 
8860 #define IRQ_SLAVE       2       // IRQ at which slave connects to master
8861 
8862 // Current IRQ mask.
8863 // Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
8864 static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);
8865 
8866 static void
8867 picsetmask(ushort mask)
8868 {
8869   irqmask = mask;
8870   outb(IO_PIC1+1, mask);
8871   outb(IO_PIC2+1, mask >> 8);
8872 }
8873 
8874 void
8875 picenable(int irq)
8876 {
8877   picsetmask(irqmask & ~(1<<irq));
8878 }
8879 
8880 // Initialize the 8259A interrupt controllers.
8881 void
8882 picinit(void)
8883 {
8884   // mask all interrupts
8885   outb(IO_PIC1+1, 0xFF);
8886   outb(IO_PIC2+1, 0xFF);
8887 
8888   // Set up master (8259A-1)
8889 
8890   // ICW1:  0001g0hi
8891   //    g:  0 = edge triggering, 1 = level triggering
8892   //    h:  0 = cascaded PICs, 1 = master only
8893   //    i:  0 = no ICW4, 1 = ICW4 required
8894   outb(IO_PIC1, 0x11);
8895 
8896   // ICW2:  Vector offset
8897   outb(IO_PIC1+1, T_IRQ0);
8898 
8899 
8900   // ICW3:  (master PIC) bit mask of IR lines connected to slaves
8901   //        (slave PIC) 3-bit # of slave's connection to master
8902   outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8903 
8904   // ICW4:  000nbmap
8905   //    n:  1 = special fully nested mode
8906   //    b:  1 = buffered mode
8907   //    m:  0 = slave PIC, 1 = master PIC
8908   //      (ignored when b is 0, as the master/slave role
8909   //      can be hardwired).
8910   //    a:  1 = Automatic EOI mode
8911   //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
8912   outb(IO_PIC1+1, 0x3);
8913 
8914   // Set up slave (8259A-2)
8915   outb(IO_PIC2, 0x11);                  // ICW1
8916   outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
8917   outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
8918   // NB Automatic EOI mode doesn't tend to work on the slave.
8919   // Linux source code says it's "to be investigated".
8920   outb(IO_PIC2+1, 0x3);                 // ICW4
8921 
8922   // OCW3:  0ef01prs
8923   //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
8924   //    p:  0 = no polling, 1 = polling mode
8925   //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
8926   outb(IO_PIC1, 0x68);             // clear specific mask
8927   outb(IO_PIC1, 0x0a);             // read IRR by default
8928 
8929   outb(IO_PIC2, 0x68);             // OCW3
8930   outb(IO_PIC2, 0x0a);             // OCW3
8931 
8932   if(irqmask != 0xFFFF)
8933     picsetmask(irqmask);
8934 }
8935 
8936 
8937 
8938 
8939 
8940 
8941 
8942 
8943 
8944 
8945 
8946 
8947 
8948 
8949 
8950 // Blank page.
8951 
8952 
8953 
8954 
8955 
8956 
8957 
8958 
8959 
8960 
8961 
8962 
8963 
8964 
8965 
8966 
8967 
8968 
8969 
8970 
8971 
8972 
8973 
8974 
8975 
8976 
8977 
8978 
8979 
8980 
8981 
8982 
8983 
8984 
8985 
8986 
8987 
8988 
8989 
8990 
8991 
8992 
8993 
8994 
8995 
8996 
8997 
8998 
8999 
