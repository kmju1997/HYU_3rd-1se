1750 #include "param.h"
1751 #include "types.h"
1752 #include "defs.h"
1753 #include "x86.h"
1754 #include "memlayout.h"
1755 #include "mmu.h"
1756 #include "proc.h"
1757 #include "elf.h"
1758 
1759 extern char data[];  // defined by kernel.ld
1760 pde_t *kpgdir;  // for use in scheduler()
1761 
1762 // Set up CPU's kernel segment descriptors.
1763 // Run once on entry on each CPU.
1764     void
1765 seginit(void)
1766 {
1767     struct cpu *c;
1768 
1769     // Map "logical" addresses to virtual addresses using identity map.
1770     // Cannot share a CODE descriptor for both kernel and user
1771     // because it would have to have DPL_USR, but the CPU forbids
1772     // an interrupt from CPL=0 to DPL=3.
1773     c = &cpus[cpunum()];
1774     c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
1775     c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
1776     c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
1777     c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
1778 
1779     // Map cpu and proc -- these are private per cpu.
1780     c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
1781 
1782     lgdt(c->gdt, sizeof(c->gdt));
1783     loadgs(SEG_KCPU << 3);
1784 
1785     // Initialize cpu-local storage.
1786     cpu = c;
1787     proc = 0;
1788 }
1789 
1790 
1791 
1792 
1793 
1794 
1795 
1796 
1797 
1798 
1799 
1800 // Return the address of the PTE in page table pgdir
1801 // that corresponds to virtual address va.  If alloc!=0,
1802 // create any required page table pages.
1803     static pte_t *
1804 walkpgdir(pde_t *pgdir, const void *va, int alloc)
1805 {
1806     pde_t *pde;
1807     pte_t *pgtab;
1808 
1809     pde = &pgdir[PDX(va)];
1810     if(*pde & PTE_P){
1811         pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
1812     } else {
1813         if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
1814             return 0;
1815         // Make sure all those PTE_P bits are zero.
1816         memset(pgtab, 0, PGSIZE);
1817         // The permissions here are overly generous, but they can
1818         // be further restricted by the permissions in the page table
1819         // entries, if necessary.
1820         *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
1821     }
1822     return &pgtab[PTX(va)];
1823 }
1824 
1825 // Create PTEs for virtual addresses starting at va that refer to
1826 // physical addresses starting at pa. va and size might not
1827 // be page-aligned.
1828     static int
1829 mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
1830 {
1831     char *a, *last;
1832     pte_t *pte;
1833 
1834     a = (char*)PGROUNDDOWN((uint)va);
1835     last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
1836     for(;;){
1837         if((pte = walkpgdir(pgdir, a, 1)) == 0)
1838             return -1;
1839         if(*pte & PTE_P)
1840             panic("remap");
1841         *pte = pa | perm | PTE_P;
1842         if(a == last)
1843             break;
1844         a += PGSIZE;
1845         pa += PGSIZE;
1846     }
1847     return 0;
1848 }
1849 
1850 // There is one page table per process, plus one that's used when
1851 // a CPU is not running any process (kpgdir). The kernel uses the
1852 // current process's page table during system calls and interrupts;
1853 // page protection bits prevent user code from using the kernel's
1854 // mappings.
1855 //
1856 // setupkvm() and exec() set up every page table like this:
1857 //
1858 //   0..KERNBASE: user memory (text+data+stack+heap), mapped to
1859 //                phys memory allocated by the kernel
1860 //   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
1861 //   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
1862 //                for the kernel's instructions and r/o data
1863 //   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
1864 //                                  rw data + free physical memory
1865 //   0xfe000000..0: mapped direct (devices such as ioapic)
1866 //
1867 // The kernel allocates physical memory for its heap and for user memory
1868 // between V2P(end) and the end of physical memory (PHYSTOP)
1869 // (directly addressable from end..P2V(PHYSTOP)).
1870 
1871 // This table defines the kernel's mappings, which are present in
1872 // every process's page table.
1873 static struct kmap {
1874     void *virt;
1875     uint phys_start;
1876     uint phys_end;
1877     int perm;
1878 } kmap[] = {
1879     { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
1880     { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
1881     { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
1882     { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
1883 };
1884 
1885 // Set up kernel part of a page table.
1886     pde_t*
1887 setupkvm(void)
1888 {
1889     pde_t *pgdir;
1890     struct kmap *k;
1891 
1892     if((pgdir = (pde_t*)kalloc()) == 0)
1893         return 0;
1894     memset(pgdir, 0, PGSIZE);
1895     if (P2V(PHYSTOP) > (void*)DEVSPACE)
1896         panic("PHYSTOP too high");
1897     for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
1898         if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
1899                     (uint)k->phys_start, k->perm) < 0)
1900             return 0;
1901     return pgdir;
1902 }
1903 
1904 // Allocate one page table for the machine for the kernel address
1905 // space for scheduler processes.
1906     void
1907 kvmalloc(void)
1908 {
1909     kpgdir = setupkvm();
1910     switchkvm();
1911 }
1912 
1913 // Switch h/w page table register to the kernel-only page table,
1914 // for when no process is running.
1915     void
1916 switchkvm(void)
1917 {
1918     lcr3(V2P(kpgdir));   // switch to the kernel page table
1919 }
1920 
1921 // Switch TSS and h/w page table to correspond to process p.
1922     void
1923 switchuvm(struct proc *p)
1924 {
1925     if(p == 0)
1926         panic("switchuvm: no process");
1927     if(p->kstack == 0)
1928         panic("switchuvm: no kstack");
1929     if(p->pgdir == 0)
1930         panic("switchuvm: no pgdir");
1931 
1932     pushcli();
1933     cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
1934     cpu->gdt[SEG_TSS].s = 0;
1935     cpu->ts.ss0 = SEG_KDATA << 3;
1936     cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
1937     // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
1938     // forbids I/O instructions (e.g., inb and outb) from user space
1939     cpu->ts.iomb = (ushort) 0xFFFF;
1940     ltr(SEG_TSS << 3);
1941     lcr3(V2P(p->pgdir));  // switch to process's address space
1942     popcli();
1943 }
1944 
1945 
1946 
1947 
1948 
1949 
1950 // Load the initcode into address 0 of pgdir.
1951 // sz must be less than a page.
1952     void
1953 inituvm(pde_t *pgdir, char *init, uint sz)
1954 {
1955     char *mem;
1956 
1957     if(sz >= PGSIZE)
1958         panic("inituvm: more than a page");
1959     mem = kalloc();
1960     memset(mem, 0, PGSIZE);
1961     mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
1962     memmove(mem, init, sz);
1963 }
1964 
1965 // Load a program segment into pgdir.  addr must be page-aligned
1966 // and the pages from addr to addr+sz must already be mapped.
1967     int
1968 loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
1969 {
1970     uint i, pa, n;
1971     pte_t *pte;
1972 
1973     if((uint) addr % PGSIZE != 0)
1974         panic("loaduvm: addr must be page aligned");
1975     for(i = 0; i < sz; i += PGSIZE){
1976         if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
1977             panic("loaduvm: address should exist");
1978         pa = PTE_ADDR(*pte);
1979         if(sz - i < PGSIZE)
1980             n = sz - i;
1981         else
1982             n = PGSIZE;
1983         if(readi(ip, P2V(pa), offset+i, n) != n)
1984             return -1;
1985     }
1986     return 0;
1987 }
1988 
1989 
1990 
1991 
1992 
1993 
1994 
1995 
1996 
1997 
1998 
1999 
2000 // Allocate page tables and physical memory to grow process from oldsz to
2001 // newsz, which need not be page aligned.  Returns new size or 0 on error.
2002     int
2003 allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
2004 {
2005     char *mem;
2006     uint a;
2007 
2008     if(newsz >= KERNBASE)
2009         return 0;
2010     if(newsz < oldsz)
2011         return oldsz;
2012 
2013     a = PGROUNDUP(oldsz);
2014     for(; a < newsz; a += PGSIZE){
2015         mem = kalloc();
2016         if(mem == 0){
2017             cprintf("allocuvm out of memory\n");
2018             deallocuvm(pgdir, newsz, oldsz);
2019             return 0;
2020         }
2021         memset(mem, 0, PGSIZE);
2022         if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
2023             cprintf("allocuvm out of memory (2)\n");
2024             deallocuvm(pgdir, newsz, oldsz);
2025             kfree(mem);
2026             return 0;
2027         }
2028     }
2029     return newsz;
2030 }
2031 
2032 // Deallocate user pages to bring the process size from oldsz to
2033 // newsz.  oldsz and newsz need not be page-aligned, nor does newsz
2034 // need to be less than oldsz.  oldsz can be larger than the actual
2035 // process size.  Returns the new process size.
2036     int
2037 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
2038 {
2039     pte_t *pte;
2040     uint a, pa;
2041 
2042     if(newsz >= oldsz)
2043         return oldsz;
2044 
2045     a = PGROUNDUP(newsz);
2046     for(; a  < oldsz; a += PGSIZE){
2047         pte = walkpgdir(pgdir, (char*)a, 0);
2048         if(!pte)
2049             a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
2050         else if((*pte & PTE_P) != 0){
2051             pa = PTE_ADDR(*pte);
2052             if(pa == 0)
2053                 panic("kfree");
2054             char *v = P2V(pa);
2055             kfree(v);
2056             *pte = 0;
2057         }
2058     }
2059     return newsz;
2060 }
2061 
2062 // Free a page table and all the physical memory pages
2063 // in the user part.
2064     void
2065 freevm(pde_t *pgdir)
2066 {
2067     uint i;
2068 
2069     if(pgdir == 0)
2070         panic("freevm: no pgdir");
2071     deallocuvm(pgdir, KERNBASE, 0);
2072     for(i = 0; i < NPDENTRIES; i++){
2073         if(pgdir[i] & PTE_P){
2074             char * v = P2V(PTE_ADDR(pgdir[i]));
2075             kfree(v);
2076         }
2077     }
2078     kfree((char*)pgdir);
2079 }
2080 
2081 // Clear PTE_U on a page. Used to create an inaccessible
2082 // page beneath the user stack.
2083     void
2084 clearpteu(pde_t *pgdir, char *uva)
2085 {
2086     pte_t *pte;
2087 
2088     pte = walkpgdir(pgdir, uva, 0);
2089     if(pte == 0)
2090         panic("clearpteu");
2091     *pte &= ~PTE_U;
2092 }
2093 
2094 
2095 
2096 
2097 
2098 
2099 
2100 // Given a parent process's page table, create a copy
2101 // of it for a child.
2102     pde_t*
2103 copyuvm(pde_t *pgdir, uint sz)
2104 {
2105     pde_t *d;
2106     pte_t *pte;
2107     uint pa, i, flags;
2108     char *mem;
2109 
2110     if((d = setupkvm()) == 0)
2111         return 0;
2112     for(i = 0; i < sz; i += PGSIZE){
2113         if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
2114             panic("copyuvm: pte should exist");
2115         if(!(*pte & PTE_P))
2116             panic("copyuvm: page not present");
2117         pa = PTE_ADDR(*pte);
2118         flags = PTE_FLAGS(*pte);
2119         if((mem = kalloc()) == 0)
2120             goto bad;
2121         memmove(mem, (char*)P2V(pa), PGSIZE);
2122         if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
2123             goto bad;
2124     }
2125     return d;
2126 
2127 bad:
2128     freevm(d);
2129     return 0;
2130 }
2131 
2132 
2133 
2134 
2135 
2136 
2137 
2138 
2139 
2140 
2141 
2142 
2143 
2144 
2145 
2146 
2147 
2148 
2149 
2150 // Map user virtual address to kernel address.
2151     char*
2152 uva2ka(pde_t *pgdir, char *uva)
2153 {
2154     pte_t *pte;
2155 
2156     pte = walkpgdir(pgdir, uva, 0);
2157     if((*pte & PTE_P) == 0)
2158         return 0;
2159     if((*pte & PTE_U) == 0)
2160         return 0;
2161     return (char*)P2V(PTE_ADDR(*pte));
2162 }
2163 
2164 // Copy len bytes from p to user address va in page table pgdir.
2165 // Most useful when pgdir is not the current page table.
2166 // uva2ka ensures this only works for PTE_U pages.
2167     int
2168 copyout(pde_t *pgdir, uint va, void *p, uint len)
2169 {
2170     char *buf, *pa0;
2171     uint n, va0;
2172 
2173     buf = (char*)p;
2174     while(len > 0){
2175         va0 = (uint)PGROUNDDOWN(va);
2176         pa0 = uva2ka(pgdir, (char*)va0);
2177         if(pa0 == 0)
2178             return -1;
2179         n = PGSIZE - (va - va0);
2180         if(n > len)
2181             n = len;
2182         memmove(pa0 + (va - va0), buf, n);
2183         len -= n;
2184         buf += n;
2185         va = va0 + PGSIZE;
2186     }
2187     return 0;
2188 }
2189 
2190 
2191 
2192 
2193 
2194 
2195 
2196 
2197 
2198 
2199 
2200 // Blank page.
2201 
2202 
2203 
2204 
2205 
2206 
2207 
2208 
2209 
2210 
2211 
2212 
2213 
2214 
2215 
2216 
2217 
2218 
2219 
2220 
2221 
2222 
2223 
2224 
2225 
2226 
2227 
2228 
2229 
2230 
2231 
2232 
2233 
2234 
2235 
2236 
2237 
2238 
2239 
2240 
2241 
2242 
2243 
2244 
2245 
2246 
2247 
2248 
2249 
2250 // Blank page.
2251 
2252 
2253 
2254 
2255 
2256 
2257 
2258 
2259 
2260 
2261 
2262 
2263 
2264 
2265 
2266 
2267 
2268 
2269 
2270 
2271 
2272 
2273 
2274 
2275 
2276 
2277 
2278 
2279 
2280 
2281 
2282 
2283 
2284 
2285 
2286 
2287 
2288 
2289 
2290 
2291 
2292 
2293 
2294 
2295 
2296 
2297 
2298 
2299 
2300 // Blank page.
2301 
2302 //ADDED
2303 //HW3
2304 void
2305 empty_stack_clean(struct proc *p){
2306     int* run;
2307     pte_t *pte;
2308     uint pa;
2309 
2310     run = (int*)p->sz;
2311     for(;(int)run > p->tf->ebp; run -= 1){
2312 
2313         pte = walkpgdir(p->pgdir, run, 0);
2314         if(!pte){
2315             run = (int*)(PGADDR(PDX(*run) + 1, 0, 0) - PGSIZE);
2316         }else if((*pte & PTE_P) != 0){
2317             pa = PTE_ADDR(*pte);
2318             if(pa == 0) continue;
2319             break;
2320         }
2321     }
2322     p->sz = (int)run;
2323 
2324 }
2325 // Given a parent process's page table, create a copy
2326 // of it for a child.
2327     pde_t*
2328 copyuvm_force(pde_t *pgdir, uint sz)
2329 {
2330     pde_t *d;
2331     pte_t *pte;
2332     uint pa, i, flags;
2333     char *mem;
2334 
2335     if((d = setupkvm()) == 0)
2336         return 0;
2337     for(i = 0; i < sz; i += PGSIZE){
2338         if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
2339             panic("copyuvm: pte should exist");
2340         if(!(*pte & PTE_P))
2341             continue;
2342         pa = PTE_ADDR(*pte);
2343         *pte = *pte | PTE_P;
2344         flags = PTE_FLAGS(*pte);
2345         if((mem = kalloc()) == 0)
2346             goto bad;
2347         memmove(mem, (char*)P2V(pa), PGSIZE);
2348         if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
2349             goto bad;
2350     }
2351     return d;
2352 
2353 bad:
2354     freevm(d);
2355     return 0;
2356 }
2357 
2358 
2359 
2360 
2361 
2362 
2363 
2364 
2365 
2366 
2367 
2368 
2369 
2370 
2371 
2372 
2373 
2374 
2375 
2376 
2377 
2378 
2379 
2380 
2381 
2382 
2383 
2384 
2385 
2386 
2387 
2388 
2389 
2390 
2391 
2392 
2393 
2394 
2395 
2396 
2397 
2398 
2399 
