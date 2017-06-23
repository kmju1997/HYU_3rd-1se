4850 // Long-term locks for processes
4851 struct sleeplock {
4852   uint locked;       // Is the lock held?
4853   struct spinlock lk; // spinlock protecting this sleep lock
4854 
4855   // For debugging:
4856   char *name;        // Name of lock.
4857   int pid;           // Process holding lock
4858 };
4859 
4860 
4861 
4862 
4863 
4864 
4865 
4866 
4867 
4868 
4869 
4870 
4871 
4872 
4873 
4874 
4875 
4876 
4877 
4878 
4879 
4880 
4881 
4882 
4883 
4884 
4885 
4886 
4887 
4888 
4889 
4890 
4891 
4892 
4893 
4894 
4895 
4896 
4897 
4898 
4899 
