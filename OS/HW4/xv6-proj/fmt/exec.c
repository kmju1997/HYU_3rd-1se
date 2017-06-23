7600 #include "types.h"
7601 #include "param.h"
7602 #include "memlayout.h"
7603 #include "mmu.h"
7604 #include "proc.h"
7605 #include "defs.h"
7606 #include "x86.h"
7607 #include "elf.h"
7608 #include "mlfq.h"
7609 
7610     int
7611 exec(char *path, char **argv)
7612 {
7613     char *s, *last;
7614     int i, off;
7615     uint argc, sz, sp, ustack[3+MAXARG+1];
7616     struct elfhdr elf;
7617     struct inode *ip;
7618     struct proghdr ph;
7619     pde_t *pgdir, *oldpgdir;
7620 
7621     begin_op();
7622 
7623     if((ip = namei(path)) == 0){
7624         end_op();
7625         return -1;
7626     }
7627     ilock(ip);
7628     pgdir = 0;
7629 
7630     // Check ELF header
7631     if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
7632         goto bad;
7633     if(elf.magic != ELF_MAGIC)
7634         goto bad;
7635 
7636     if((pgdir = setupkvm()) == 0)
7637         goto bad;
7638 
7639     // Load program into memory.
7640     sz = 0;
7641     for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
7642         if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
7643             goto bad;
7644         if(ph.type != ELF_PROG_LOAD)
7645             continue;
7646         if(ph.memsz < ph.filesz)
7647             goto bad;
7648         if(ph.vaddr + ph.memsz < ph.vaddr)
7649             goto bad;
7650         if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
7651             goto bad;
7652         if(ph.vaddr % PGSIZE != 0)
7653             goto bad;
7654         if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
7655             goto bad;
7656     }
7657     iunlockput(ip);
7658     end_op();
7659     ip = 0;
7660 
7661     // Allocate two pages at the next page boundary.
7662     // Make the first inaccessible.  Use the second as the user stack.
7663     sz = PGROUNDUP(sz);
7664     if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
7665         goto bad;
7666     clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
7667     sp = sz;
7668 
7669     // Push argument strings, prepare rest of stack in ustack.
7670     for(argc = 0; argv[argc]; argc++) {
7671         if(argc >= MAXARG)
7672             goto bad;
7673         sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
7674         if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
7675             goto bad;
7676         ustack[3+argc] = sp;
7677     }
7678     ustack[3+argc] = 0;
7679 
7680     ustack[0] = 0xffffffff;  // fake return PC
7681     ustack[1] = argc;
7682     ustack[2] = sp - (argc+1)*4;  // argv pointer
7683 
7684     sp -= (3+argc+1) * 4;
7685     if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
7686         goto bad;
7687 
7688     // Save program name for debugging.
7689     for(last=s=path; *s; s++)
7690         if(*s == '/')
7691             last = s+1;
7692     safestrcpy(proc->name, last, sizeof(proc->name));
7693 
7694     // Commit to the user image.
7695     oldpgdir = proc->pgdir;
7696     proc->pgdir = pgdir;
7697     proc->sz = sz;
7698     proc->tf->eip = elf.entry;  // main
7699     proc->tf->esp = sp;
7700     switchuvm(proc);
7701     if(proc->isthread ==0)
7702         freevm(oldpgdir);
7703 
7704     return 0;
7705 
7706 bad:
7707     if(pgdir)
7708         freevm(pgdir);
7709     if(ip){
7710         iunlockput(ip);
7711         end_op();
7712     }
7713     return -1;
7714 }
7715 
7716 
7717 
7718 
7719 
7720 
7721 
7722 
7723 
7724 
7725 
7726 
7727 
7728 
7729 
7730 
7731 
7732 
7733 
7734 
7735 
7736 
7737 
7738 
7739 
7740 
7741 
7742 
7743 
7744 
7745 
7746 
7747 
7748 
7749 
