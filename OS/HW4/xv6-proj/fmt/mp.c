8200 // Multiprocessor support
8201 // Search memory for MP description structures.
8202 // http://developer.intel.com/design/pentium/datashts/24201606.pdf
8203 
8204 #include "types.h"
8205 #include "defs.h"
8206 #include "param.h"
8207 #include "memlayout.h"
8208 #include "mp.h"
8209 #include "x86.h"
8210 #include "mmu.h"
8211 #include "proc.h"
8212 
8213 struct cpu cpus[NCPU];
8214 int ismp;
8215 int ncpu;
8216 uchar ioapicid;
8217 
8218 static uchar
8219 sum(uchar *addr, int len)
8220 {
8221   int i, sum;
8222 
8223   sum = 0;
8224   for(i=0; i<len; i++)
8225     sum += addr[i];
8226   return sum;
8227 }
8228 
8229 // Look for an MP structure in the len bytes at addr.
8230 static struct mp*
8231 mpsearch1(uint a, int len)
8232 {
8233   uchar *e, *p, *addr;
8234 
8235   addr = P2V(a);
8236   e = addr+len;
8237   for(p = addr; p < e; p += sizeof(struct mp))
8238     if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8239       return (struct mp*)p;
8240   return 0;
8241 }
8242 
8243 
8244 
8245 
8246 
8247 
8248 
8249 
8250 // Search for the MP Floating Pointer Structure, which according to the
8251 // spec is in one of the following three locations:
8252 // 1) in the first KB of the EBDA;
8253 // 2) in the last KB of system base memory;
8254 // 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
8255 static struct mp*
8256 mpsearch(void)
8257 {
8258   uchar *bda;
8259   uint p;
8260   struct mp *mp;
8261 
8262   bda = (uchar *) P2V(0x400);
8263   if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8264     if((mp = mpsearch1(p, 1024)))
8265       return mp;
8266   } else {
8267     p = ((bda[0x14]<<8)|bda[0x13])*1024;
8268     if((mp = mpsearch1(p-1024, 1024)))
8269       return mp;
8270   }
8271   return mpsearch1(0xF0000, 0x10000);
8272 }
8273 
8274 // Search for an MP configuration table.  For now,
8275 // don't accept the default configurations (physaddr == 0).
8276 // Check for correct signature, calculate the checksum and,
8277 // if correct, check the version.
8278 // To do: check extended table checksum.
8279 static struct mpconf*
8280 mpconfig(struct mp **pmp)
8281 {
8282   struct mpconf *conf;
8283   struct mp *mp;
8284 
8285   if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8286     return 0;
8287   conf = (struct mpconf*) P2V((uint) mp->physaddr);
8288   if(memcmp(conf, "PCMP", 4) != 0)
8289     return 0;
8290   if(conf->version != 1 && conf->version != 4)
8291     return 0;
8292   if(sum((uchar*)conf, conf->length) != 0)
8293     return 0;
8294   *pmp = mp;
8295   return conf;
8296 }
8297 
8298 
8299 
8300 void
8301 mpinit(void)
8302 {
8303   uchar *p, *e;
8304   struct mp *mp;
8305   struct mpconf *conf;
8306   struct mpproc *proc;
8307   struct mpioapic *ioapic;
8308 
8309   if((conf = mpconfig(&mp)) == 0)
8310     return;
8311   ismp = 1;
8312   lapic = (uint*)conf->lapicaddr;
8313   for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8314     switch(*p){
8315     case MPPROC:
8316       proc = (struct mpproc*)p;
8317       if(ncpu < NCPU) {
8318         cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8319         ncpu++;
8320       }
8321       p += sizeof(struct mpproc);
8322       continue;
8323     case MPIOAPIC:
8324       ioapic = (struct mpioapic*)p;
8325       ioapicid = ioapic->apicno;
8326       p += sizeof(struct mpioapic);
8327       continue;
8328     case MPBUS:
8329     case MPIOINTR:
8330     case MPLINTR:
8331       p += 8;
8332       continue;
8333     default:
8334       ismp = 0;
8335       break;
8336     }
8337   }
8338   if(!ismp){
8339     // Didn't like what we found; fall back to no MP.
8340     ncpu = 1;
8341     lapic = 0;
8342     ioapicid = 0;
8343     return;
8344   }
8345 
8346 
8347 
8348 
8349 
8350   if(mp->imcrp){
8351     // Bochs doesn't support IMCR, so this doesn't run on Bochs.
8352     // But it would on real hardware.
8353     outb(0x22, 0x70);   // Select IMCR
8354     outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8355   }
8356 }
8357 
8358 
8359 
8360 
8361 
8362 
8363 
8364 
8365 
8366 
8367 
8368 
8369 
8370 
8371 
8372 
8373 
8374 
8375 
8376 
8377 
8378 
8379 
8380 
8381 
8382 
8383 
8384 
8385 
8386 
8387 
8388 
8389 
8390 
8391 
8392 
8393 
8394 
8395 
8396 
8397 
8398 
8399 
