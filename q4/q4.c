#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
int main(){
    char arr[15];
    int n=0,m=0;
    while(scanf("%s %d %d",arr,&n,&m)==3){
        char name[30];
        sprintf(name,"./lib%s.so",arr); 
        void *handle=dlopen(name, RTLD_LAZY);
        if(!handle){
            printf("ERROR LOADING LIBRARY\n");
            continue;
        }
        int (*func)(int,int);
        func=(int (*)(int,int))dlsym(handle,arr);
        if(!func){
            printf("FUNCTION NOT FOUND\n");
            dlclose(handle);
            continue;
        }
        int result=func(n,m);
        printf("%d\n",result);
        dlclose(handle);
    }
}