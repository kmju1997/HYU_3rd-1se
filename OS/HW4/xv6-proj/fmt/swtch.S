3800 # Context switch
3801 #
3802 #   void swtch(struct context **old, struct context *new);
3803 #
3804 # Save current register context in old
3805 # and then load register context from new.
3806 
3807 .globl swtch
3808 swtch:
3809   movl 4(%esp), %eax
3810   movl 8(%esp), %edx
3811 
3812   # Save old callee-save registers
3813   pushl %ebp
3814   pushl %ebx
3815   pushl %esi
3816   pushl %edi
3817 
3818   # Switch stacks
3819   movl %esp, (%eax)
3820   movl %edx, %esp
3821 
3822   # Load new callee-save registers
3823   popl %edi
3824   popl %esi
3825   popl %ebx
3826   popl %ebp
3827   ret
3828 
3829 
3830 
3831 
3832 
3833 
3834 
3835 
3836 
3837 
3838 
3839 
3840 
3841 
3842 
3843 
3844 
3845 
3846 
3847 
3848 
3849 
