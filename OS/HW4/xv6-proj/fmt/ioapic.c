8750 // The I/O APIC manages hardware interrupts for an SMP system.
8751 // http://www.intel.com/design/chipsets/datashts/29056601.pdf
8752 // See also picirq.c.
8753 
8754 #include "types.h"
8755 #include "defs.h"
8756 #include "traps.h"
8757 
8758 #define IOAPIC  0xFEC00000   // Default physical address of IO APIC
8759 
8760 #define REG_ID     0x00  // Register index: ID
8761 #define REG_VER    0x01  // Register index: version
8762 #define REG_TABLE  0x10  // Redirection table base
8763 
8764 // The redirection table starts at REG_TABLE and uses
8765 // two registers to configure each interrupt.
8766 // The first (low) register in a pair contains configuration bits.
8767 // The second (high) register contains a bitmask telling which
8768 // CPUs can serve that interrupt.
8769 #define INT_DISABLED   0x00010000  // Interrupt disabled
8770 #define INT_LEVEL      0x00008000  // Level-triggered (vs edge-)
8771 #define INT_ACTIVELOW  0x00002000  // Active low (vs high)
8772 #define INT_LOGICAL    0x00000800  // Destination is CPU id (vs APIC ID)
8773 
8774 volatile struct ioapic *ioapic;
8775 
8776 // IO APIC MMIO structure: write reg, then read or write data.
8777 struct ioapic {
8778   uint reg;
8779   uint pad[3];
8780   uint data;
8781 };
8782 
8783 static uint
8784 ioapicread(int reg)
8785 {
8786   ioapic->reg = reg;
8787   return ioapic->data;
8788 }
8789 
8790 static void
8791 ioapicwrite(int reg, uint data)
8792 {
8793   ioapic->reg = reg;
8794   ioapic->data = data;
8795 }
8796 
8797 
8798 
8799 
8800 void
8801 ioapicinit(void)
8802 {
8803   int i, id, maxintr;
8804 
8805   if(!ismp)
8806     return;
8807 
8808   ioapic = (volatile struct ioapic*)IOAPIC;
8809   maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8810   id = ioapicread(REG_ID) >> 24;
8811   if(id != ioapicid)
8812     cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8813 
8814   // Mark all interrupts edge-triggered, active high, disabled,
8815   // and not routed to any CPUs.
8816   for(i = 0; i <= maxintr; i++){
8817     ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8818     ioapicwrite(REG_TABLE+2*i+1, 0);
8819   }
8820 }
8821 
8822 void
8823 ioapicenable(int irq, int cpunum)
8824 {
8825   if(!ismp)
8826     return;
8827 
8828   // Mark interrupt edge-triggered, active high,
8829   // enabled, and routed to the given cpunum,
8830   // which happens to be that cpu's APIC ID.
8831   ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8832   ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8833 }
8834 
8835 
8836 
8837 
8838 
8839 
8840 
8841 
8842 
8843 
8844 
8845 
8846 
8847 
8848 
8849 
