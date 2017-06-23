4800 struct buf {
4801   int flags;
4802   uint dev;
4803   uint blockno;
4804   struct sleeplock lock;
4805   uint refcnt;
4806   struct buf *prev; // LRU cache list
4807   struct buf *next;
4808   struct buf *qnext; // disk queue
4809   uchar data[BSIZE];
4810 };
4811 #define B_VALID 0x2  // buffer has been read from disk
4812 #define B_DIRTY 0x4  // buffer needs to be written to disk
4813 
4814 
4815 
4816 
4817 
4818 
4819 
4820 
4821 
4822 
4823 
4824 
4825 
4826 
4827 
4828 
4829 
4830 
4831 
4832 
4833 
4834 
4835 
4836 
4837 
4838 
4839 
4840 
4841 
4842 
4843 
4844 
4845 
4846 
4847 
4848 
4849 
