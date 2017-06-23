5000 // On-disk file system format.
5001 // Both the kernel and user programs use this header file.
5002 
5003 
5004 #define ROOTINO 1  // root i-number
5005 #define BSIZE 512  // block size
5006 
5007 // Disk layout:
5008 // [ boot block | super block | log | inode blocks |
5009 //                                          free bit map | data blocks]
5010 //
5011 // mkfs computes the super block and builds an initial file system. The
5012 // super block describes the disk layout:
5013 struct superblock {
5014   uint size;         // Size of file system image (blocks)
5015   uint nblocks;      // Number of data blocks
5016   uint ninodes;      // Number of inodes.
5017   uint nlog;         // Number of log blocks
5018   uint logstart;     // Block number of first log block
5019   uint inodestart;   // Block number of first inode block
5020   uint bmapstart;    // Block number of first free map block
5021 };
5022 
5023 #define NDIRECT 12
5024 #define NINDIRECT (BSIZE / sizeof(uint))
5025 #define MAXFILE (NDIRECT + NINDIRECT)
5026 
5027 // On-disk inode structure
5028 struct dinode {
5029   short type;           // File type
5030   short major;          // Major device number (T_DEV only)
5031   short minor;          // Minor device number (T_DEV only)
5032   short nlink;          // Number of links to inode in file system
5033   uint size;            // Size of file (bytes)
5034   uint addrs[NDIRECT+1];   // Data block addresses
5035 };
5036 
5037 
5038 
5039 
5040 
5041 
5042 
5043 
5044 
5045 
5046 
5047 
5048 
5049 
5050 // Inodes per block.
5051 #define IPB           (BSIZE / sizeof(struct dinode))
5052 
5053 // Block containing inode i
5054 #define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)
5055 
5056 // Bitmap bits per block
5057 #define BPB           (BSIZE*8)
5058 
5059 // Block of free map containing bit for block b
5060 #define BBLOCK(b, sb) (b/BPB + sb.bmapstart)
5061 
5062 // Directory is a file containing a sequence of dirent structures.
5063 #define DIRSIZ 14
5064 
5065 struct dirent {
5066   ushort inum;
5067   char name[DIRSIZ];
5068 };
5069 
5070 
5071 
5072 
5073 
5074 
5075 
5076 
5077 
5078 
5079 
5080 
5081 
5082 
5083 
5084 
5085 
5086 
5087 
5088 
5089 
5090 
5091 
5092 
5093 
5094 
5095 
5096 
5097 
5098 
5099 
