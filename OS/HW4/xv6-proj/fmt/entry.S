1150 # The xv6 kernel starts executing in this file. This file is linked with
1151 # the kernel C code, so it can refer to kernel symbols such as main().
1152 # The boot block (bootasm.S and bootmain.c) jumps to entry below.
1153 
1154 # Multiboot header, for multiboot boot loaders like GNU Grub.
1155 # http://www.gnu.org/software/grub/manual/multiboot/multiboot.html
1156 #
1157 # Using GRUB 2, you can boot xv6 from a file stored in a
1158 # Linux file system by copying kernel or kernelmemfs to /boot
1159 # and then adding this menu entry:
1160 #
1161 # menuentry "xv6" {
1162 # 	insmod ext2
1163 # 	set root='(hd0,msdos1)'
1164 # 	set kernel='/boot/kernel'
1165 # 	echo "Loading ${kernel}..."
1166 # 	multiboot ${kernel} ${kernel}
1167 # 	boot
1168 # }
1169 
1170 #include "asm.h"
1171 #include "memlayout.h"
1172 #include "mmu.h"
1173 #include "param.h"
1174 
1175 # Multiboot header.  Data to direct multiboot loader.
1176 .p2align 2
1177 .text
1178 .globl multiboot_header
1179 multiboot_header:
1180   #define magic 0x1badb002
1181   #define flags 0
1182   .long magic
1183   .long flags
1184   .long (-magic-flags)
1185 
1186 # By convention, the _start symbol specifies the ELF entry point.
1187 # Since we haven't set up virtual memory yet, our entry point is
1188 # the physical address of 'entry'.
1189 .globl _start
1190 _start = V2P_WO(entry)
1191 
1192 # Entering xv6 on boot processor, with paging off.
1193 .globl entry
1194 entry:
1195   # Turn on page size extension for 4Mbyte pages
1196   movl    %cr4, %eax
1197   orl     $(CR4_PSE), %eax
1198   movl    %eax, %cr4
1199   # Set page directory
1200   movl    $(V2P_WO(entrypgdir)), %eax
1201   movl    %eax, %cr3
1202   # Turn on paging.
1203   movl    %cr0, %eax
1204   orl     $(CR0_PG|CR0_WP), %eax
1205   movl    %eax, %cr0
1206 
1207   # Set up the stack pointer.
1208   movl $(stack + KSTACKSIZE), %esp
1209 
1210   # Jump to main(), and switch to executing at
1211   # high addresses. The indirect call is needed because
1212   # the assembler produces a PC-relative instruction
1213   # for a direct jump.
1214   mov $main, %eax
1215   jmp *%eax
1216 
1217 .comm stack, KSTACKSIZE
1218 
1219 
1220 
1221 
1222 
1223 
1224 
1225 
1226 
1227 
1228 
1229 
1230 
1231 
1232 
1233 
1234 
1235 
1236 
1237 
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
