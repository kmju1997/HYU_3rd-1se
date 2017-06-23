1600 // Mutual exclusion spin locks.
1601 
1602 #include "types.h"
1603 #include "defs.h"
1604 #include "param.h"
1605 #include "x86.h"
1606 #include "memlayout.h"
1607 #include "mmu.h"
1608 #include "proc.h"
1609 #include "spinlock.h"
1610 
1611 void
1612 initlock(struct spinlock *lk, char *name)
1613 {
1614   lk->name = name;
1615   lk->locked = 0;
1616   lk->cpu = 0;
1617 }
1618 
1619 // Acquire the lock.
1620 // Loops (spins) until the lock is acquired.
1621 // Holding a lock for a long time may cause
1622 // other CPUs to waste time spinning to acquire it.
1623 void
1624 acquire(struct spinlock *lk)
1625 {
1626   pushcli(); // disable interrupts to avoid deadlock.
1627   if(holding(lk)){
1628       cprintf("%s acquire\n",lk->name);
1629     //panic("acquire");
1630   }
1631 
1632   // The xchg is atomic.
1633   while(xchg(&lk->locked, 1) != 0)
1634     ;
1635 
1636   // Tell the C compiler and the processor to not move loads or stores
1637   // past this point, to ensure that the critical section's memory
1638   // references happen after the lock is acquired.
1639   __sync_synchronize();
1640 
1641   // Record info about lock acquisition for debugging.
1642   lk->cpu = cpu;
1643   getcallerpcs(&lk, lk->pcs);
1644 }
1645 
1646 
1647 
1648 
1649 
1650 // Release the lock.
1651 void
1652 release(struct spinlock *lk)
1653 {
1654   if(!holding(lk))
1655     panic("release");
1656 
1657   lk->pcs[0] = 0;
1658   lk->cpu = 0;
1659 
1660   // Tell the C compiler and the processor to not move loads or stores
1661   // past this point, to ensure that all the stores in the critical
1662   // section are visible to other cores before the lock is released.
1663   // Both the C compiler and the hardware may re-order loads and
1664   // stores; __sync_synchronize() tells them both not to.
1665   __sync_synchronize();
1666 
1667   // Release the lock, equivalent to lk->locked = 0.
1668   // This code can't use a C assignment, since it might
1669   // not be atomic. A real OS would use C atomics here.
1670   asm volatile("movl $0, %0" : "+m" (lk->locked) : );
1671 
1672   popcli();
1673 }
1674 
1675 // Record the current call stack in pcs[] by following the %ebp chain.
1676 void
1677 getcallerpcs(void *v, uint pcs[])
1678 {
1679   uint *ebp;
1680   int i;
1681 
1682   ebp = (uint*)v - 2;
1683   for(i = 0; i < 10; i++){
1684     if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
1685       break;
1686     pcs[i] = ebp[1];     // saved %eip
1687     ebp = (uint*)ebp[0]; // saved %ebp
1688   }
1689   for(; i < 10; i++)
1690     pcs[i] = 0;
1691 }
1692 
1693 // Check whether this cpu is holding the lock.
1694 int
1695 holding(struct spinlock *lock)
1696 {
1697   return lock->locked && lock->cpu == cpu;
1698 }
1699 
1700 // Pushcli/popcli are like cli/sti except that they are matched:
1701 // it takes two popcli to undo two pushcli.  Also, if interrupts
1702 // are off, then pushcli, popcli leaves them off.
1703 
1704 void
1705 pushcli(void)
1706 {
1707   int eflags;
1708 
1709   eflags = readeflags();
1710   cli();
1711   if(cpu->ncli == 0)
1712     cpu->intena = eflags & FL_IF;
1713   cpu->ncli += 1;
1714 }
1715 
1716 void
1717 popcli(void)
1718 {
1719   if(readeflags()&FL_IF)
1720     panic("popcli - interruptible");
1721   if(--cpu->ncli < 0)
1722     panic("popcli");
1723   if(cpu->ncli == 0 && cpu->intena)
1724     sti();
1725 }
1726 
1727 
1728 
1729 
1730 
1731 
1732 
1733 
1734 
1735 
1736 
1737 
1738 
1739 
1740 
1741 
1742 
1743 
1744 
1745 
1746 
1747 
1748 
1749 
