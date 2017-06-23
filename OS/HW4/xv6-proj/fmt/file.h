5100 struct file {
5101   enum { FD_NONE, FD_PIPE, FD_INODE } type;
5102   int ref; // reference count
5103   char readable;
5104   char writable;
5105   struct pipe *pipe;
5106   struct inode *ip;
5107   uint off;
5108 };
5109 
5110 
5111 // in-memory copy of an inode
5112 struct inode {
5113   uint dev;           // Device number
5114   uint inum;          // Inode number
5115   int ref;            // Reference count
5116   struct sleeplock lock;
5117   int flags;          // I_VALID
5118 
5119   short type;         // copy of disk inode
5120   short major;
5121   short minor;
5122   short nlink;
5123   uint size;
5124   uint addrs[NDIRECT+1];
5125 };
5126 #define I_VALID 0x2
5127 
5128 // table mapping major device number to
5129 // device functions
5130 struct devsw {
5131   int (*read)(struct inode*, char*, int);
5132   int (*write)(struct inode*, char*, int);
5133 };
5134 
5135 extern struct devsw devsw[];
5136 
5137 #define CONSOLE 1
5138 
5139 
5140 
5141 
5142 
5143 
5144 
5145 
5146 
5147 
5148 
5149 
5150 // Blank page.
5151 
5152 
5153 
5154 
5155 
5156 
5157 
5158 
5159 
5160 
5161 
5162 
5163 
5164 
5165 
5166 
5167 
5168 
5169 
5170 
5171 
5172 
5173 
5174 
5175 
5176 
5177 
5178 
5179 
5180 
5181 
5182 
5183 
5184 
5185 
5186 
5187 
5188 
5189 
5190 
5191 
5192 
5193 
5194 
5195 
5196 
5197 
5198 
5199 
