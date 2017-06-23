9900 // Shell.
9901 
9902 #include "types.h"
9903 #include "user.h"
9904 #include "fcntl.h"
9905 
9906 // Parsed command representation
9907 #define EXEC  1
9908 #define REDIR 2
9909 #define PIPE  3
9910 #define LIST  4
9911 #define BACK  5
9912 
9913 #define MAXARGS 10
9914 
9915 struct cmd {
9916   int type;
9917 };
9918 
9919 struct execcmd {
9920   int type;
9921   char *argv[MAXARGS];
9922   char *eargv[MAXARGS];
9923 };
9924 
9925 struct redircmd {
9926   int type;
9927   struct cmd *cmd;
9928   char *file;
9929   char *efile;
9930   int mode;
9931   int fd;
9932 };
9933 
9934 struct pipecmd {
9935   int type;
9936   struct cmd *left;
9937   struct cmd *right;
9938 };
9939 
9940 struct listcmd {
9941   int type;
9942   struct cmd *left;
9943   struct cmd *right;
9944 };
9945 
9946 struct backcmd {
9947   int type;
9948   struct cmd *cmd;
9949 };
9950 int fork1(void);  // Fork but panics on failure.
9951 void panic(char*);
9952 struct cmd *parsecmd(char*);
9953 
9954 // Execute cmd.  Never returns.
9955 void
9956 runcmd(struct cmd *cmd)
9957 {
9958   int p[2];
9959   struct backcmd *bcmd;
9960   struct execcmd *ecmd;
9961   struct listcmd *lcmd;
9962   struct pipecmd *pcmd;
9963   struct redircmd *rcmd;
9964 
9965   if(cmd == 0)
9966     exit();
9967 
9968   switch(cmd->type){
9969   default:
9970     panic("runcmd");
9971 
9972   case EXEC:
9973     ecmd = (struct execcmd*)cmd;
9974     if(ecmd->argv[0] == 0)
9975       exit();
9976     exec(ecmd->argv[0], ecmd->argv);
9977     printf(2, "exec %s failed\n", ecmd->argv[0]);
9978     break;
9979 
9980   case REDIR:
9981     rcmd = (struct redircmd*)cmd;
9982     close(rcmd->fd);
9983     if(open(rcmd->file, rcmd->mode) < 0){
9984       printf(2, "open %s failed\n", rcmd->file);
9985       exit();
9986     }
9987     runcmd(rcmd->cmd);
9988     break;
9989 
9990   case LIST:
9991     lcmd = (struct listcmd*)cmd;
9992     if(fork1() == 0)
9993       runcmd(lcmd->left);
9994     wait();
9995     runcmd(lcmd->right);
9996     break;
9997 
9998 
9999 
10000   case PIPE:
10001     pcmd = (struct pipecmd*)cmd;
10002     if(pipe(p) < 0)
10003       panic("pipe");
10004     if(fork1() == 0){
10005       close(1);
10006       dup(p[1]);
10007       close(p[0]);
10008       close(p[1]);
10009       runcmd(pcmd->left);
10010     }
10011     if(fork1() == 0){
10012       close(0);
10013       dup(p[0]);
10014       close(p[0]);
10015       close(p[1]);
10016       runcmd(pcmd->right);
10017     }
10018     close(p[0]);
10019     close(p[1]);
10020     wait();
10021     wait();
10022     break;
10023 
10024   case BACK:
10025     bcmd = (struct backcmd*)cmd;
10026     if(fork1() == 0)
10027       runcmd(bcmd->cmd);
10028     break;
10029   }
10030   exit();
10031 }
10032 
10033 int
10034 getcmd(char *buf, int nbuf)
10035 {
10036   printf(2, "$ ");
10037   memset(buf, 0, nbuf);
10038   gets(buf, nbuf);
10039   if(buf[0] == 0) // EOF
10040     return -1;
10041   return 0;
10042 }
10043 
10044 
10045 
10046 
10047 
10048 
10049 
10050 int
10051 main(void)
10052 {
10053   static char buf[100];
10054   int fd;
10055 
10056   // Ensure that three file descriptors are open.
10057   while((fd = open("console", O_RDWR)) >= 0){
10058     if(fd >= 3){
10059       close(fd);
10060       break;
10061     }
10062   }
10063 
10064   // Read and run input commands.
10065   while(getcmd(buf, sizeof(buf)) >= 0){
10066     if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
10067       // Chdir must be called by the parent, not the child.
10068       buf[strlen(buf)-1] = 0;  // chop \n
10069       if(chdir(buf+3) < 0)
10070         printf(2, "cannot cd %s\n", buf+3);
10071       continue;
10072     }
10073     if(fork1() == 0)
10074       runcmd(parsecmd(buf));
10075     wait();
10076   }
10077   exit();
10078 }
10079 
10080 void
10081 panic(char *s)
10082 {
10083   printf(2, "%s\n", s);
10084   exit();
10085 }
10086 
10087 int
10088 fork1(void)
10089 {
10090   int pid;
10091 
10092   pid = fork();
10093   if(pid == -1)
10094     panic("fork");
10095   return pid;
10096 }
10097 
10098 
10099 
10100 // Constructors
10101 
10102 struct cmd*
10103 execcmd(void)
10104 {
10105   struct execcmd *cmd;
10106 
10107   cmd = malloc(sizeof(*cmd));
10108   memset(cmd, 0, sizeof(*cmd));
10109   cmd->type = EXEC;
10110   return (struct cmd*)cmd;
10111 }
10112 
10113 struct cmd*
10114 redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
10115 {
10116   struct redircmd *cmd;
10117 
10118   cmd = malloc(sizeof(*cmd));
10119   memset(cmd, 0, sizeof(*cmd));
10120   cmd->type = REDIR;
10121   cmd->cmd = subcmd;
10122   cmd->file = file;
10123   cmd->efile = efile;
10124   cmd->mode = mode;
10125   cmd->fd = fd;
10126   return (struct cmd*)cmd;
10127 }
10128 
10129 struct cmd*
10130 pipecmd(struct cmd *left, struct cmd *right)
10131 {
10132   struct pipecmd *cmd;
10133 
10134   cmd = malloc(sizeof(*cmd));
10135   memset(cmd, 0, sizeof(*cmd));
10136   cmd->type = PIPE;
10137   cmd->left = left;
10138   cmd->right = right;
10139   return (struct cmd*)cmd;
10140 }
10141 
10142 
10143 
10144 
10145 
10146 
10147 
10148 
10149 
10150 struct cmd*
10151 listcmd(struct cmd *left, struct cmd *right)
10152 {
10153   struct listcmd *cmd;
10154 
10155   cmd = malloc(sizeof(*cmd));
10156   memset(cmd, 0, sizeof(*cmd));
10157   cmd->type = LIST;
10158   cmd->left = left;
10159   cmd->right = right;
10160   return (struct cmd*)cmd;
10161 }
10162 
10163 struct cmd*
10164 backcmd(struct cmd *subcmd)
10165 {
10166   struct backcmd *cmd;
10167 
10168   cmd = malloc(sizeof(*cmd));
10169   memset(cmd, 0, sizeof(*cmd));
10170   cmd->type = BACK;
10171   cmd->cmd = subcmd;
10172   return (struct cmd*)cmd;
10173 }
10174 
10175 
10176 
10177 
10178 
10179 
10180 
10181 
10182 
10183 
10184 
10185 
10186 
10187 
10188 
10189 
10190 
10191 
10192 
10193 
10194 
10195 
10196 
10197 
10198 
10199 
10200 // Parsing
10201 
10202 char whitespace[] = " \t\r\n\v";
10203 char symbols[] = "<|>&;()";
10204 
10205 int
10206 gettoken(char **ps, char *es, char **q, char **eq)
10207 {
10208   char *s;
10209   int ret;
10210 
10211   s = *ps;
10212   while(s < es && strchr(whitespace, *s))
10213     s++;
10214   if(q)
10215     *q = s;
10216   ret = *s;
10217   switch(*s){
10218   case 0:
10219     break;
10220   case '|':
10221   case '(':
10222   case ')':
10223   case ';':
10224   case '&':
10225   case '<':
10226     s++;
10227     break;
10228   case '>':
10229     s++;
10230     if(*s == '>'){
10231       ret = '+';
10232       s++;
10233     }
10234     break;
10235   default:
10236     ret = 'a';
10237     while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
10238       s++;
10239     break;
10240   }
10241   if(eq)
10242     *eq = s;
10243 
10244   while(s < es && strchr(whitespace, *s))
10245     s++;
10246   *ps = s;
10247   return ret;
10248 }
10249 
10250 int
10251 peek(char **ps, char *es, char *toks)
10252 {
10253   char *s;
10254 
10255   s = *ps;
10256   while(s < es && strchr(whitespace, *s))
10257     s++;
10258   *ps = s;
10259   return *s && strchr(toks, *s);
10260 }
10261 
10262 struct cmd *parseline(char**, char*);
10263 struct cmd *parsepipe(char**, char*);
10264 struct cmd *parseexec(char**, char*);
10265 struct cmd *nulterminate(struct cmd*);
10266 
10267 struct cmd*
10268 parsecmd(char *s)
10269 {
10270   char *es;
10271   struct cmd *cmd;
10272 
10273   es = s + strlen(s);
10274   cmd = parseline(&s, es);
10275   peek(&s, es, "");
10276   if(s != es){
10277     printf(2, "leftovers: %s\n", s);
10278     panic("syntax");
10279   }
10280   nulterminate(cmd);
10281   return cmd;
10282 }
10283 
10284 struct cmd*
10285 parseline(char **ps, char *es)
10286 {
10287   struct cmd *cmd;
10288 
10289   cmd = parsepipe(ps, es);
10290   while(peek(ps, es, "&")){
10291     gettoken(ps, es, 0, 0);
10292     cmd = backcmd(cmd);
10293   }
10294   if(peek(ps, es, ";")){
10295     gettoken(ps, es, 0, 0);
10296     cmd = listcmd(cmd, parseline(ps, es));
10297   }
10298   return cmd;
10299 }
10300 struct cmd*
10301 parsepipe(char **ps, char *es)
10302 {
10303   struct cmd *cmd;
10304 
10305   cmd = parseexec(ps, es);
10306   if(peek(ps, es, "|")){
10307     gettoken(ps, es, 0, 0);
10308     cmd = pipecmd(cmd, parsepipe(ps, es));
10309   }
10310   return cmd;
10311 }
10312 
10313 struct cmd*
10314 parseredirs(struct cmd *cmd, char **ps, char *es)
10315 {
10316   int tok;
10317   char *q, *eq;
10318 
10319   while(peek(ps, es, "<>")){
10320     tok = gettoken(ps, es, 0, 0);
10321     if(gettoken(ps, es, &q, &eq) != 'a')
10322       panic("missing file for redirection");
10323     switch(tok){
10324     case '<':
10325       cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
10326       break;
10327     case '>':
10328       cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
10329       break;
10330     case '+':  // >>
10331       cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
10332       break;
10333     }
10334   }
10335   return cmd;
10336 }
10337 
10338 
10339 
10340 
10341 
10342 
10343 
10344 
10345 
10346 
10347 
10348 
10349 
10350 struct cmd*
10351 parseblock(char **ps, char *es)
10352 {
10353   struct cmd *cmd;
10354 
10355   if(!peek(ps, es, "("))
10356     panic("parseblock");
10357   gettoken(ps, es, 0, 0);
10358   cmd = parseline(ps, es);
10359   if(!peek(ps, es, ")"))
10360     panic("syntax - missing )");
10361   gettoken(ps, es, 0, 0);
10362   cmd = parseredirs(cmd, ps, es);
10363   return cmd;
10364 }
10365 
10366 struct cmd*
10367 parseexec(char **ps, char *es)
10368 {
10369   char *q, *eq;
10370   int tok, argc;
10371   struct execcmd *cmd;
10372   struct cmd *ret;
10373 
10374   if(peek(ps, es, "("))
10375     return parseblock(ps, es);
10376 
10377   ret = execcmd();
10378   cmd = (struct execcmd*)ret;
10379 
10380   argc = 0;
10381   ret = parseredirs(ret, ps, es);
10382   while(!peek(ps, es, "|)&;")){
10383     if((tok=gettoken(ps, es, &q, &eq)) == 0)
10384       break;
10385     if(tok != 'a')
10386       panic("syntax");
10387     cmd->argv[argc] = q;
10388     cmd->eargv[argc] = eq;
10389     argc++;
10390     if(argc >= MAXARGS)
10391       panic("too many args");
10392     ret = parseredirs(ret, ps, es);
10393   }
10394   cmd->argv[argc] = 0;
10395   cmd->eargv[argc] = 0;
10396   return ret;
10397 }
10398 
10399 
10400 // NUL-terminate all the counted strings.
10401 struct cmd*
10402 nulterminate(struct cmd *cmd)
10403 {
10404   int i;
10405   struct backcmd *bcmd;
10406   struct execcmd *ecmd;
10407   struct listcmd *lcmd;
10408   struct pipecmd *pcmd;
10409   struct redircmd *rcmd;
10410 
10411   if(cmd == 0)
10412     return 0;
10413 
10414   switch(cmd->type){
10415   case EXEC:
10416     ecmd = (struct execcmd*)cmd;
10417     for(i=0; ecmd->argv[i]; i++)
10418       *ecmd->eargv[i] = 0;
10419     break;
10420 
10421   case REDIR:
10422     rcmd = (struct redircmd*)cmd;
10423     nulterminate(rcmd->cmd);
10424     *rcmd->efile = 0;
10425     break;
10426 
10427   case PIPE:
10428     pcmd = (struct pipecmd*)cmd;
10429     nulterminate(pcmd->left);
10430     nulterminate(pcmd->right);
10431     break;
10432 
10433   case LIST:
10434     lcmd = (struct listcmd*)cmd;
10435     nulterminate(lcmd->left);
10436     nulterminate(lcmd->right);
10437     break;
10438 
10439   case BACK:
10440     bcmd = (struct backcmd*)cmd;
10441     nulterminate(bcmd->cmd);
10442     break;
10443   }
10444   return cmd;
10445 }
10446 
10447 
10448 
10449 
