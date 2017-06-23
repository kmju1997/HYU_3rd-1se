
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <pthread.h>

#define NUM_THREAD 5


void*
execthreadmain(void *arg)
{
  char *args[3] = {"echo", "echo is executed!", 0};
  sleep(1);
  execvp("echo", args);

  printf("panic at execthreadmain\n");
  exit(0);
}

int
main(int argc, char *argv[])
{
  pthread_t pthreads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (pthread_create(&pthreads[i], NULL, execthreadmain, (void*)0) != 0){
      printf("panic at pthread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (pthread_join(pthreads[i], &retval) != 0){
      printf("panic at pthread_join\n");
      return -1;
    }
  }
  printf("panic at exectest\n");
  return 0;
}
