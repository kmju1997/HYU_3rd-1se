0750 // This file contains definitions for the
0751 // x86 memory management unit (MMU).
0752 
0753 // Eflags register
0754 #define FL_CF           0x00000001      // Carry Flag
0755 #define FL_PF           0x00000004      // Parity Flag
0756 #define FL_AF           0x00000010      // Auxiliary carry Flag
0757 #define FL_ZF           0x00000040      // Zero Flag
0758 #define FL_SF           0x00000080      // Sign Flag
0759 #define FL_TF           0x00000100      // Trap Flag
0760 #define FL_IF           0x00000200      // Interrupt Enable
0761 #define FL_DF           0x00000400      // Direction Flag
0762 #define FL_OF           0x00000800      // Overflow Flag
0763 #define FL_IOPL_MASK    0x00003000      // I/O Privilege Level bitmask
0764 #define FL_IOPL_0       0x00000000      //   IOPL == 0
0765 #define FL_IOPL_1       0x00001000      //   IOPL == 1
0766 #define FL_IOPL_2       0x00002000      //   IOPL == 2
0767 #define FL_IOPL_3       0x00003000      //   IOPL == 3
0768 #define FL_NT           0x00004000      // Nested Task
0769 #define FL_RF           0x00010000      // Resume Flag
0770 #define FL_VM           0x00020000      // Virtual 8086 mode
0771 #define FL_AC           0x00040000      // Alignment Check
0772 #define FL_VIF          0x00080000      // Virtual Interrupt Flag
0773 #define FL_VIP          0x00100000      // Virtual Interrupt Pending
0774 #define FL_ID           0x00200000      // ID flag
0775 
0776 // Control Register flags
0777 #define CR0_PE          0x00000001      // Protection Enable
0778 #define CR0_MP          0x00000002      // Monitor coProcessor
0779 #define CR0_EM          0x00000004      // Emulation
0780 #define CR0_TS          0x00000008      // Task Switched
0781 #define CR0_ET          0x00000010      // Extension Type
0782 #define CR0_NE          0x00000020      // Numeric Errror
0783 #define CR0_WP          0x00010000      // Write Protect
0784 #define CR0_AM          0x00040000      // Alignment Mask
0785 #define CR0_NW          0x20000000      // Not Writethrough
0786 #define CR0_CD          0x40000000      // Cache Disable
0787 #define CR0_PG          0x80000000      // Paging
0788 
0789 #define CR4_PSE         0x00000010      // Page size extension
0790 
0791 // various segment selectors.
0792 #define SEG_KCODE 1  // kernel code
0793 #define SEG_KDATA 2  // kernel data+stack
0794 #define SEG_KCPU  3  // kernel per-cpu data
0795 #define SEG_UCODE 4  // user code
0796 #define SEG_UDATA 5  // user data+stack
0797 #define SEG_TSS   6  // this process's task state
0798 
0799 
0800 // cpu->gdt[NSEGS] holds the above segments.
0801 #define NSEGS     7
0802 
0803 
0804 
0805 
0806 
0807 
0808 
0809 
0810 
0811 
0812 
0813 
0814 
0815 
0816 
0817 
0818 
0819 
0820 
0821 
0822 
0823 
0824 
0825 
0826 
0827 
0828 
0829 
0830 
0831 
0832 
0833 
0834 
0835 
0836 
0837 
0838 
0839 
0840 
0841 
0842 
0843 
0844 
0845 
0846 
0847 
0848 
0849 
0850 #ifndef __ASSEMBLER__
0851 // Segment Descriptor
0852 struct segdesc {
0853   uint lim_15_0 : 16;  // Low bits of segment limit
0854   uint base_15_0 : 16; // Low bits of segment base address
0855   uint base_23_16 : 8; // Middle bits of segment base address
0856   uint type : 4;       // Segment type (see STS_ constants)
0857   uint s : 1;          // 0 = system, 1 = application
0858   uint dpl : 2;        // Descriptor Privilege Level
0859   uint p : 1;          // Present
0860   uint lim_19_16 : 4;  // High bits of segment limit
0861   uint avl : 1;        // Unused (available for software use)
0862   uint rsv1 : 1;       // Reserved
0863   uint db : 1;         // 0 = 16-bit segment, 1 = 32-bit segment
0864   uint g : 1;          // Granularity: limit scaled by 4K when set
0865   uint base_31_24 : 8; // High bits of segment base address
0866 };
0867 
0868 // Normal segment
0869 #define SEG(type, base, lim, dpl) (struct segdesc)    \
0870 { ((lim) >> 12) & 0xffff, (uint)(base) & 0xffff,      \
0871   ((uint)(base) >> 16) & 0xff, type, 1, dpl, 1,       \
0872   (uint)(lim) >> 28, 0, 0, 1, 1, (uint)(base) >> 24 }
0873 #define SEG16(type, base, lim, dpl) (struct segdesc)  \
0874 { (lim) & 0xffff, (uint)(base) & 0xffff,              \
0875   ((uint)(base) >> 16) & 0xff, type, 1, dpl, 1,       \
0876   (uint)(lim) >> 16, 0, 0, 1, 0, (uint)(base) >> 24 }
0877 #endif
0878 
0879 #define DPL_USER    0x3     // User DPL
0880 
0881 // Application segment type bits
0882 #define STA_X       0x8     // Executable segment
0883 #define STA_E       0x4     // Expand down (non-executable segments)
0884 #define STA_C       0x4     // Conforming code segment (executable only)
0885 #define STA_W       0x2     // Writeable (non-executable segments)
0886 #define STA_R       0x2     // Readable (executable segments)
0887 #define STA_A       0x1     // Accessed
0888 
0889 // System segment type bits
0890 #define STS_T16A    0x1     // Available 16-bit TSS
0891 #define STS_LDT     0x2     // Local Descriptor Table
0892 #define STS_T16B    0x3     // Busy 16-bit TSS
0893 #define STS_CG16    0x4     // 16-bit Call Gate
0894 #define STS_TG      0x5     // Task Gate / Coum Transmitions
0895 #define STS_IG16    0x6     // 16-bit Interrupt Gate
0896 #define STS_TG16    0x7     // 16-bit Trap Gate
0897 #define STS_T32A    0x9     // Available 32-bit TSS
0898 #define STS_T32B    0xB     // Busy 32-bit TSS
0899 #define STS_CG32    0xC     // 32-bit Call Gate
0900 #define STS_IG32    0xE     // 32-bit Interrupt Gate
0901 #define STS_TG32    0xF     // 32-bit Trap Gate
0902 
0903 // A virtual address 'la' has a three-part structure as follows:
0904 //
0905 // +--------10------+-------10-------+---------12----------+
0906 // | Page Directory |   Page Table   | Offset within Page  |
0907 // |      Index     |      Index     |                     |
0908 // +----------------+----------------+---------------------+
0909 //  \--- PDX(va) --/ \--- PTX(va) --/
0910 
0911 // page directory index
0912 #define PDX(va)         (((uint)(va) >> PDXSHIFT) & 0x3FF)
0913 
0914 // page table index
0915 #define PTX(va)         (((uint)(va) >> PTXSHIFT) & 0x3FF)
0916 
0917 // construct virtual address from indexes and offset
0918 #define PGADDR(d, t, o) ((uint)((d) << PDXSHIFT | (t) << PTXSHIFT | (o)))
0919 
0920 // Page directory and page table constants.
0921 #define NPDENTRIES      1024    // # directory entries per page directory
0922 #define NPTENTRIES      1024    // # PTEs per page table
0923 #define PGSIZE          4096    // bytes mapped by a page
0924 
0925 #define PGSHIFT         12      // log2(PGSIZE)
0926 #define PTXSHIFT        12      // offset of PTX in a linear address
0927 #define PDXSHIFT        22      // offset of PDX in a linear address
0928 
0929 #define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
0930 #define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))
0931 
0932 // Page table/directory entry flags.
0933 #define PTE_P           0x001   // Present
0934 #define PTE_W           0x002   // Writeable
0935 #define PTE_U           0x004   // User
0936 #define PTE_PWT         0x008   // Write-Through
0937 #define PTE_PCD         0x010   // Cache-Disable
0938 #define PTE_A           0x020   // Accessed
0939 #define PTE_D           0x040   // Dirty
0940 #define PTE_PS          0x080   // Page Size
0941 #define PTE_MBZ         0x180   // Bits must be zero
0942 
0943 // Address in page table or page directory entry
0944 #define PTE_ADDR(pte)   ((uint)(pte) & ~0xFFF)
0945 #define PTE_FLAGS(pte)  ((uint)(pte) &  0xFFF)
0946 
0947 #ifndef __ASSEMBLER__
0948 typedef uint pte_t;
0949 
0950 // Task state segment format
0951 struct taskstate {
0952   uint link;         // Old ts selector
0953   uint esp0;         // Stack pointers and segment selectors
0954   ushort ss0;        //   after an increase in privilege level
0955   ushort padding1;
0956   uint *esp1;
0957   ushort ss1;
0958   ushort padding2;
0959   uint *esp2;
0960   ushort ss2;
0961   ushort padding3;
0962   void *cr3;         // Page directory base
0963   uint *eip;         // Saved state from last task switch
0964   uint eflags;
0965   uint eax;          // More saved state (registers)
0966   uint ecx;
0967   uint edx;
0968   uint ebx;
0969   uint *esp;
0970   uint *ebp;
0971   uint esi;
0972   uint edi;
0973   ushort es;         // Even more saved state (segment selectors)
0974   ushort padding4;
0975   ushort cs;
0976   ushort padding5;
0977   ushort ss;
0978   ushort padding6;
0979   ushort ds;
0980   ushort padding7;
0981   ushort fs;
0982   ushort padding8;
0983   ushort gs;
0984   ushort padding9;
0985   ushort ldt;
0986   ushort padding10;
0987   ushort t;          // Trap on task switch
0988   ushort iomb;       // I/O map base address
0989 };
0990 
0991 
0992 
0993 
0994 
0995 
0996 
0997 
0998 
0999 
1000 // Gate descriptors for interrupts and traps
1001 struct gatedesc {
1002   uint off_15_0 : 16;   // low 16 bits of offset in segment
1003   uint cs : 16;         // code segment selector
1004   uint args : 5;        // # args, 0 for interrupt/trap gates
1005   uint rsv1 : 3;        // reserved(should be zero I guess)
1006   uint type : 4;        // type(STS_{TG,IG32,TG32})
1007   uint s : 1;           // must be 0 (system)
1008   uint dpl : 2;         // descriptor(meaning new) privilege level
1009   uint p : 1;           // Present
1010   uint off_31_16 : 16;  // high bits of offset in segment
1011 };
1012 
1013 // Set up a normal interrupt/trap gate descriptor.
1014 // - istrap: 1 for a trap (= exception) gate, 0 for an interrupt gate.
1015 //   interrupt gate clears FL_IF, trap gate leaves FL_IF alone
1016 // - sel: Code segment selector for interrupt/trap handler
1017 // - off: Offset in code segment for interrupt/trap handler
1018 // - dpl: Descriptor Privilege Level -
1019 //        the privilege level required for software to invoke
1020 //        this interrupt/trap gate explicitly using an int instruction.
1021 #define SETGATE(gate, istrap, sel, off, d)                \
1022 {                                                         \
1023   (gate).off_15_0 = (uint)(off) & 0xffff;                \
1024   (gate).cs = (sel);                                      \
1025   (gate).args = 0;                                        \
1026   (gate).rsv1 = 0;                                        \
1027   (gate).type = (istrap) ? STS_TG32 : STS_IG32;           \
1028   (gate).s = 0;                                           \
1029   (gate).dpl = (d);                                       \
1030   (gate).p = 1;                                           \
1031   (gate).off_31_16 = (uint)(off) >> 16;                  \
1032 }
1033 
1034 #endif
1035 
1036 
1037 
1038 
1039 
1040 
1041 
1042 
1043 
1044 
1045 
1046 
1047 
1048 
1049 
