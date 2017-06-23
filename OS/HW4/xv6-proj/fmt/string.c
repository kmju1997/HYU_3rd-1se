7900 #include "types.h"
7901 #include "x86.h"
7902 
7903 void*
7904 memset(void *dst, int c, uint n)
7905 {
7906   if ((int)dst%4 == 0 && n%4 == 0){
7907     c &= 0xFF;
7908     stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
7909   } else
7910     stosb(dst, c, n);
7911   return dst;
7912 }
7913 
7914 int
7915 memcmp(const void *v1, const void *v2, uint n)
7916 {
7917   const uchar *s1, *s2;
7918 
7919   s1 = v1;
7920   s2 = v2;
7921   while(n-- > 0){
7922     if(*s1 != *s2)
7923       return *s1 - *s2;
7924     s1++, s2++;
7925   }
7926 
7927   return 0;
7928 }
7929 
7930 void*
7931 memmove(void *dst, const void *src, uint n)
7932 {
7933   const char *s;
7934   char *d;
7935 
7936   s = src;
7937   d = dst;
7938   if(s < d && s + n > d){
7939     s += n;
7940     d += n;
7941     while(n-- > 0)
7942       *--d = *--s;
7943   } else
7944     while(n-- > 0)
7945       *d++ = *s++;
7946 
7947   return dst;
7948 }
7949 
7950 // memcpy exists to placate GCC.  Use memmove.
7951 void*
7952 memcpy(void *dst, const void *src, uint n)
7953 {
7954   return memmove(dst, src, n);
7955 }
7956 
7957 int
7958 strncmp(const char *p, const char *q, uint n)
7959 {
7960   while(n > 0 && *p && *p == *q)
7961     n--, p++, q++;
7962   if(n == 0)
7963     return 0;
7964   return (uchar)*p - (uchar)*q;
7965 }
7966 
7967 char*
7968 strncpy(char *s, const char *t, int n)
7969 {
7970   char *os;
7971 
7972   os = s;
7973   while(n-- > 0 && (*s++ = *t++) != 0)
7974     ;
7975   while(n-- > 0)
7976     *s++ = 0;
7977   return os;
7978 }
7979 
7980 // Like strncpy but guaranteed to NUL-terminate.
7981 char*
7982 safestrcpy(char *s, const char *t, int n)
7983 {
7984   char *os;
7985 
7986   os = s;
7987   if(n <= 0)
7988     return os;
7989   while(--n > 0 && (*s++ = *t++) != 0)
7990     ;
7991   *s = 0;
7992   return os;
7993 }
7994 
7995 
7996 
7997 
7998 
7999 
8000 int
8001 strlen(const char *s)
8002 {
8003   int n;
8004 
8005   for(n = 0; s[n]; n++)
8006     ;
8007   return n;
8008 }
8009 
8010 
8011 
8012 
8013 
8014 
8015 
8016 
8017 
8018 
8019 
8020 
8021 
8022 
8023 
8024 
8025 
8026 
8027 
8028 
8029 
8030 
8031 
8032 
8033 
8034 
8035 
8036 
8037 
8038 
8039 
8040 
8041 
8042 
8043 
8044 
8045 
8046 
8047 
8048 
8049 
