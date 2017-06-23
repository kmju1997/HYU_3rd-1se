1050 // Format of an ELF executable file
1051 
1052 #define ELF_MAGIC 0x464C457FU  // "\x7FELF" in little endian
1053 
1054 // File header
1055 struct elfhdr {
1056   uint magic;  // must equal ELF_MAGIC
1057   uchar elf[12];
1058   ushort type;
1059   ushort machine;
1060   uint version;
1061   uint entry;
1062   uint phoff;
1063   uint shoff;
1064   uint flags;
1065   ushort ehsize;
1066   ushort phentsize;
1067   ushort phnum;
1068   ushort shentsize;
1069   ushort shnum;
1070   ushort shstrndx;
1071 };
1072 
1073 // Program section header
1074 struct proghdr {
1075   uint type;
1076   uint off;
1077   uint vaddr;
1078   uint paddr;
1079   uint filesz;
1080   uint memsz;
1081   uint flags;
1082   uint align;
1083 };
1084 
1085 // Values for Proghdr type
1086 #define ELF_PROG_LOAD           1
1087 
1088 // Flag bits for Proghdr flags
1089 #define ELF_PROG_FLAG_EXEC      1
1090 #define ELF_PROG_FLAG_WRITE     2
1091 #define ELF_PROG_FLAG_READ      4
1092 
1093 
1094 
1095 
1096 
1097 
1098 
1099 
1100 // Blank page.
1101 
1102 
1103 
1104 
1105 
1106 
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 
1115 
1116 
1117 
1118 
1119 
1120 
1121 
1122 
1123 
1124 
1125 
1126 
1127 
1128 
1129 
1130 
1131 
1132 
1133 
1134 
1135 
1136 
1137 
1138 
1139 
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 
1148 
1149 
