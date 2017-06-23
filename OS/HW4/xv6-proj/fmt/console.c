9200 // Console input and output.
9201 // Input is from the keyboard or serial port.
9202 // Output is written to the screen and serial port.
9203 
9204 #include "types.h"
9205 #include "defs.h"
9206 #include "param.h"
9207 #include "traps.h"
9208 #include "spinlock.h"
9209 #include "sleeplock.h"
9210 #include "fs.h"
9211 #include "file.h"
9212 #include "memlayout.h"
9213 #include "mmu.h"
9214 #include "proc.h"
9215 #include "x86.h"
9216 
9217 static void consputc(int);
9218 
9219 static int panicked = 0;
9220 
9221 static struct {
9222   struct spinlock lock;
9223   int locking;
9224 } cons;
9225 
9226 static void
9227 printint(int xx, int base, int sign)
9228 {
9229   static char digits[] = "0123456789abcdef";
9230   char buf[16];
9231   int i;
9232   uint x;
9233 
9234   if(sign && (sign = xx < 0))
9235     x = -xx;
9236   else
9237     x = xx;
9238 
9239   i = 0;
9240   do{
9241     buf[i++] = digits[x % base];
9242   }while((x /= base) != 0);
9243 
9244   if(sign)
9245     buf[i++] = '-';
9246 
9247   while(--i >= 0)
9248     consputc(buf[i]);
9249 }
9250 
9251 
9252 
9253 
9254 
9255 
9256 
9257 
9258 
9259 
9260 
9261 
9262 
9263 
9264 
9265 
9266 
9267 
9268 
9269 
9270 
9271 
9272 
9273 
9274 
9275 
9276 
9277 
9278 
9279 
9280 
9281 
9282 
9283 
9284 
9285 
9286 
9287 
9288 
9289 
9290 
9291 
9292 
9293 
9294 
9295 
9296 
9297 
9298 
9299 
9300 // Print to the console. only understands %d, %x, %p, %s.
9301 void
9302 cprintf(char *fmt, ...)
9303 {
9304   int i, c, locking;
9305   uint *argp;
9306   char *s;
9307 
9308   locking = cons.locking;
9309   if(locking)
9310     acquire(&cons.lock);
9311 
9312   if (fmt == 0)
9313     panic("null fmt");
9314 
9315   argp = (uint*)(void*)(&fmt + 1);
9316   for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
9317     if(c != '%'){
9318       consputc(c);
9319       continue;
9320     }
9321     c = fmt[++i] & 0xff;
9322     if(c == 0)
9323       break;
9324     switch(c){
9325     case 'd':
9326       printint(*argp++, 10, 1);
9327       break;
9328     case 'x':
9329     case 'p':
9330       printint(*argp++, 16, 0);
9331       break;
9332     case 's':
9333       if((s = (char*)*argp++) == 0)
9334         s = "(null)";
9335       for(; *s; s++)
9336         consputc(*s);
9337       break;
9338     case '%':
9339       consputc('%');
9340       break;
9341     default:
9342       // Print unknown % sequence to draw attention.
9343       consputc('%');
9344       consputc(c);
9345       break;
9346     }
9347   }
9348 
9349 
9350   if(locking)
9351     release(&cons.lock);
9352 }
9353 
9354 void
9355 panic(char *s)
9356 {
9357   int i;
9358   uint pcs[10];
9359 
9360   cli();
9361   cons.locking = 0;
9362   cprintf("cpu with apicid %d: panic: ", cpu->apicid);
9363   cprintf(s);
9364   cprintf("\n");
9365   getcallerpcs(&s, pcs);
9366   for(i=0; i<10; i++)
9367     cprintf(" %p", pcs[i]);
9368   panicked = 1; // freeze other CPU
9369   for(;;)
9370     ;
9371 }
9372 
9373 
9374 
9375 
9376 
9377 
9378 
9379 
9380 
9381 
9382 
9383 
9384 
9385 
9386 
9387 
9388 
9389 
9390 
9391 
9392 
9393 
9394 
9395 
9396 
9397 
9398 
9399 
9400 #define BACKSPACE 0x100
9401 #define CRTPORT 0x3d4
9402 static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory
9403 
9404 static void
9405 cgaputc(int c)
9406 {
9407   int pos;
9408 
9409   // Cursor position: col + 80*row.
9410   outb(CRTPORT, 14);
9411   pos = inb(CRTPORT+1) << 8;
9412   outb(CRTPORT, 15);
9413   pos |= inb(CRTPORT+1);
9414 
9415   if(c == '\n')
9416     pos += 80 - pos%80;
9417   else if(c == BACKSPACE){
9418     if(pos > 0) --pos;
9419   } else
9420     crt[pos++] = (c&0xff) | 0x0700;  // black on white
9421 
9422   if(pos < 0 || pos > 25*80)
9423     panic("pos under/overflow");
9424 
9425   if((pos/80) >= 24){  // Scroll up.
9426     memmove(crt, crt+80, sizeof(crt[0])*23*80);
9427     pos -= 80;
9428     memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
9429   }
9430 
9431   outb(CRTPORT, 14);
9432   outb(CRTPORT+1, pos>>8);
9433   outb(CRTPORT, 15);
9434   outb(CRTPORT+1, pos);
9435   crt[pos] = ' ' | 0x0700;
9436 }
9437 
9438 
9439 
9440 
9441 
9442 
9443 
9444 
9445 
9446 
9447 
9448 
9449 
9450 void
9451 consputc(int c)
9452 {
9453   if(panicked){
9454     cli();
9455     for(;;)
9456       ;
9457   }
9458 
9459   if(c == BACKSPACE){
9460     uartputc('\b'); uartputc(' '); uartputc('\b');
9461   } else
9462     uartputc(c);
9463   cgaputc(c);
9464 }
9465 
9466 #define INPUT_BUF 128
9467 struct {
9468   char buf[INPUT_BUF];
9469   uint r;  // Read index
9470   uint w;  // Write index
9471   uint e;  // Edit index
9472 } input;
9473 
9474 #define C(x)  ((x)-'@')  // Control-x
9475 
9476 void
9477 consoleintr(int (*getc)(void))
9478 {
9479   int c, doprocdump = 0;
9480 
9481   acquire(&cons.lock);
9482   while((c = getc()) >= 0){
9483     switch(c){
9484     case C('P'):  // Process listing.
9485       // procdump() locks cons.lock indirectly; invoke later
9486       doprocdump = 1;
9487       break;
9488     case C('U'):  // Kill line.
9489       while(input.e != input.w &&
9490             input.buf[(input.e-1) % INPUT_BUF] != '\n'){
9491         input.e--;
9492         consputc(BACKSPACE);
9493       }
9494       break;
9495     case C('H'): case '\x7f':  // Backspace
9496       if(input.e != input.w){
9497         input.e--;
9498         consputc(BACKSPACE);
9499       }
9500       break;
9501     default:
9502       if(c != 0 && input.e-input.r < INPUT_BUF){
9503         c = (c == '\r') ? '\n' : c;
9504         input.buf[input.e++ % INPUT_BUF] = c;
9505         consputc(c);
9506         if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
9507           input.w = input.e;
9508           wakeup(&input.r);
9509         }
9510       }
9511       break;
9512     }
9513   }
9514   release(&cons.lock);
9515   if(doprocdump) {
9516     procdump();  // now call procdump() wo. cons.lock held
9517   }
9518 }
9519 
9520 int
9521 consoleread(struct inode *ip, char *dst, int n)
9522 {
9523   uint target;
9524   int c;
9525 
9526   iunlock(ip);
9527   target = n;
9528   acquire(&cons.lock);
9529   while(n > 0){
9530     while(input.r == input.w){
9531       if(proc->killed){
9532         release(&cons.lock);
9533         ilock(ip);
9534         return -1;
9535       }
9536       sleep(&input.r, &cons.lock);
9537     }
9538     c = input.buf[input.r++ % INPUT_BUF];
9539     if(c == C('D')){  // EOF
9540       if(n < target){
9541         // Save ^D for next time, to make sure
9542         // caller gets a 0-byte result.
9543         input.r--;
9544       }
9545       break;
9546     }
9547     *dst++ = c;
9548     --n;
9549     if(c == '\n')
9550       break;
9551   }
9552   release(&cons.lock);
9553   ilock(ip);
9554 
9555   return target - n;
9556 }
9557 
9558 int
9559 consolewrite(struct inode *ip, char *buf, int n)
9560 {
9561   int i;
9562 
9563   iunlock(ip);
9564   acquire(&cons.lock);
9565   for(i = 0; i < n; i++)
9566     consputc(buf[i] & 0xff);
9567   release(&cons.lock);
9568   ilock(ip);
9569 
9570   return n;
9571 }
9572 
9573 void
9574 consoleinit(void)
9575 {
9576   initlock(&cons.lock, "console");
9577 
9578   devsw[CONSOLE].write = consolewrite;
9579   devsw[CONSOLE].read = consoleread;
9580   cons.locking = 1;
9581 
9582   picenable(IRQ_KBD);
9583   ioapicenable(IRQ_KBD, 0);
9584 }
9585 
9586 
9587 
9588 
9589 
9590 
9591 
9592 
9593 
9594 
9595 
9596 
9597 
9598 
9599 
