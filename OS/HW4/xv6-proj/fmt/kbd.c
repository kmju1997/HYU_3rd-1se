9150 #include "types.h"
9151 #include "x86.h"
9152 #include "defs.h"
9153 #include "kbd.h"
9154 
9155 int
9156 kbdgetc(void)
9157 {
9158   static uint shift;
9159   static uchar *charcode[4] = {
9160     normalmap, shiftmap, ctlmap, ctlmap
9161   };
9162   uint st, data, c;
9163 
9164   st = inb(KBSTATP);
9165   if((st & KBS_DIB) == 0)
9166     return -1;
9167   data = inb(KBDATAP);
9168 
9169   if(data == 0xE0){
9170     shift |= E0ESC;
9171     return 0;
9172   } else if(data & 0x80){
9173     // Key released
9174     data = (shift & E0ESC ? data : data & 0x7F);
9175     shift &= ~(shiftcode[data] | E0ESC);
9176     return 0;
9177   } else if(shift & E0ESC){
9178     // Last character was an E0 escape; or with 0x80
9179     data |= 0x80;
9180     shift &= ~E0ESC;
9181   }
9182 
9183   shift |= shiftcode[data];
9184   shift ^= togglecode[data];
9185   c = charcode[shift & (CTL | SHIFT)][data];
9186   if(shift & CAPSLOCK){
9187     if('a' <= c && c <= 'z')
9188       c += 'A' - 'a';
9189     else if('A' <= c && c <= 'Z')
9190       c += 'a' - 'A';
9191   }
9192   return c;
9193 }
9194 
9195 void
9196 kbdintr(void)
9197 {
9198   consoleintr(kbdgetc);
9199 }
