1350 #include "types.h"
1351 #include "defs.h"
1352 #include "param.h"
1353 #include "memlayout.h"
1354 #include "mmu.h"
1355 #include "proc.h"
1356 #include "x86.h"
1357 
1358 static void startothers(void);
1359 static void mpmain(void)  __attribute__((noreturn));
1360 extern pde_t *kpgdir;
1361 extern char end[]; // first address after kernel loaded from ELF file
1362 
1363 // Bootstrap processor starts running C code here.
1364 // Allocate a real stack and switch to it, first
1365 // doing some setup required for memory allocator to work.
1366 int
1367 main(void)
1368 {
1369   kinit1(end, P2V(4*1024*1024)); // phys page allocator
1370   kvmalloc();      // kernel page table
1371   mpinit();        // detect other processors
1372   lapicinit();     // interrupt controller
1373   seginit();       // segment descriptors
1374   cprintf("\ncpu%d: starting xv6\n\n", cpunum());
1375   picinit();       // another interrupt controller
1376   ioapicinit();    // another interrupt controller
1377   consoleinit();   // console hardware
1378   uartinit();      // serial port
1379   pinit();         // process table
1380   tvinit();        // trap vectors
1381   binit();         // buffer cache
1382   fileinit();      // file table
1383   ideinit();       // disk
1384   if(!ismp)
1385     timerinit();   // uniprocessor timer
1386   startothers();   // start other processors
1387   kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
1388   userinit();      // first user process
1389   mpmain();        // finish this processor's setup
1390 }
1391 
1392 
1393 
1394 
1395 
1396 
1397 
1398 
1399 
1400 // Other CPUs jump here from entryother.S.
1401 static void
1402 mpenter(void)
1403 {
1404   switchkvm();
1405   seginit();
1406   lapicinit();
1407   mpmain();
1408 }
1409 
1410 // Common CPU setup code.
1411 static void
1412 mpmain(void)
1413 {
1414   cprintf("cpu%d: starting\n", cpunum());
1415   idtinit();       // load idt register
1416   xchg(&cpu->started, 1); // tell startothers() we're up
1417   scheduler();     // start running processes
1418 }
1419 
1420 pde_t entrypgdir[];  // For entry.S
1421 
1422 // Start the non-boot (AP) processors.
1423 static void
1424 startothers(void)
1425 {
1426   extern uchar _binary_entryother_start[], _binary_entryother_size[];
1427   uchar *code;
1428   struct cpu *c;
1429   char *stack;
1430 
1431   // Write entry code to unused memory at 0x7000.
1432   // The linker has placed the image of entryother.S in
1433   // _binary_entryother_start.
1434   code = P2V(0x7000);
1435   memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
1436 
1437   for(c = cpus; c < cpus+ncpu; c++){
1438     if(c == cpus+cpunum())  // We've started already.
1439       continue;
1440 
1441     // Tell entryother.S what stack to use, where to enter, and what
1442     // pgdir to use. We cannot use kpgdir yet, because the AP processor
1443     // is running in low  memory, so we use entrypgdir for the APs too.
1444     stack = kalloc();
1445     *(void**)(code-4) = stack + KSTACKSIZE;
1446     *(void**)(code-8) = mpenter;
1447     *(int**)(code-12) = (void *) V2P(entrypgdir);
1448 
1449     lapicstartap(c->apicid, V2P(code));
1450     // wait for cpu to finish mpmain()
1451     while(c->started == 0)
1452       ;
1453   }
1454 }
1455 
1456 // The boot page table used in entry.S and entryother.S.
1457 // Page directories (and page tables) must start on page boundaries,
1458 // hence the __aligned__ attribute.
1459 // PTE_PS in a page directory entry enables 4Mbyte pages.
1460 
1461 __attribute__((__aligned__(PGSIZE)))
1462 pde_t entrypgdir[NPDENTRIES] = {
1463   // Map VA's [0, 4MB) to PA's [0, 4MB)
1464   [0] = (0) | PTE_P | PTE_W | PTE_PS,
1465   // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
1466   [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,
1467 };
1468 
1469 
1470 
1471 
1472 
1473 
1474 
1475 
1476 
1477 
1478 
1479 
1480 
1481 
1482 
1483 
1484 
1485 
1486 
1487 
1488 
1489 
1490 
1491 
1492 
1493 
1494 
1495 
1496 
1497 
1498 
1499 
1500 // Blank page.
1501 
1502 
1503 
1504 
1505 
1506 
1507 
1508 
1509 
1510 
1511 
1512 
1513 
1514 
1515 
1516 
1517 
1518 
1519 
1520 
1521 
1522 
1523 
1524 
1525 
1526 
1527 
1528 
1529 
1530 
1531 
1532 
1533 
1534 
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 
1543 
1544 
1545 
1546 
1547 
1548 
1549 
