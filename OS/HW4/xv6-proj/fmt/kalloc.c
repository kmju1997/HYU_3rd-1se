3850 // Physical memory allocator, intended to allocate
3851 // memory for user processes, kernel stacks, page table pages,
3852 // and pipe buffers. Allocates 4096-byte pages.
3853 
3854 #include "types.h"
3855 #include "defs.h"
3856 #include "param.h"
3857 #include "memlayout.h"
3858 #include "mmu.h"
3859 #include "spinlock.h"
3860 
3861 void freerange(void *vstart, void *vend);
3862 extern char end[]; // first address after kernel loaded from ELF file
3863 
3864 struct run {
3865   struct run *next;
3866 };
3867 
3868 struct {
3869   struct spinlock lock;
3870   int use_lock;
3871   struct run *freelist;
3872 } kmem;
3873 
3874 // Initialization happens in two phases.
3875 // 1. main() calls kinit1() while still using entrypgdir to place just
3876 // the pages mapped by entrypgdir on free list.
3877 // 2. main() calls kinit2() with the rest of the physical pages
3878 // after installing a full page table that maps them on all cores.
3879 void
3880 kinit1(void *vstart, void *vend)
3881 {
3882   initlock(&kmem.lock, "kmem");
3883   kmem.use_lock = 0;
3884   freerange(vstart, vend);
3885 }
3886 
3887 void
3888 kinit2(void *vstart, void *vend)
3889 {
3890   freerange(vstart, vend);
3891   kmem.use_lock = 1;
3892 }
3893 
3894 
3895 
3896 
3897 
3898 
3899 
3900 void
3901 freerange(void *vstart, void *vend)
3902 {
3903   char *p;
3904   p = (char*)PGROUNDUP((uint)vstart);
3905   for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
3906     kfree(p);
3907 }
3908 
3909 
3910 // Free the page of physical memory pointed at by v,
3911 // which normally should have been returned by a
3912 // call to kalloc().  (The exception is when
3913 // initializing the allocator; see kinit above.)
3914 void
3915 kfree(char *v)
3916 {
3917   struct run *r;
3918 
3919   if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
3920     panic("kfree");
3921 
3922   // Fill with junk to catch dangling refs.
3923   memset(v, 1, PGSIZE);
3924 
3925   if(kmem.use_lock)
3926     acquire(&kmem.lock);
3927   r = (struct run*)v;
3928   r->next = kmem.freelist;
3929   kmem.freelist = r;
3930   if(kmem.use_lock)
3931     release(&kmem.lock);
3932 }
3933 
3934 // Allocate one 4096-byte page of physical memory.
3935 // Returns a pointer that the kernel can use.
3936 // Returns 0 if the memory cannot be allocated.
3937 char*
3938 kalloc(void)
3939 {
3940   struct run *r;
3941 
3942   if(kmem.use_lock)
3943     acquire(&kmem.lock);
3944   r = kmem.freelist;
3945   if(r)
3946     kmem.freelist = r->next;
3947   if(kmem.use_lock)
3948     release(&kmem.lock);
3949   return (char*)r;
3950 }
3951 
3952 
3953 
3954 
3955 
3956 
3957 
3958 
3959 
3960 
3961 
3962 
3963 
3964 
3965 
3966 
3967 
3968 
3969 
3970 
3971 
3972 
3973 
3974 
3975 
3976 
3977 
3978 
3979 
3980 
3981 
3982 
3983 
3984 
3985 
3986 
3987 
3988 
3989 
3990 
3991 
3992 
3993 
3994 
3995 
3996 
3997 
3998 
3999 
