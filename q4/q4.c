#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[10];
    int a, b;

    while (scanf("%s %d %d", op, &a, &b) == 3) {
        char libname[20] = "lib";
        strcat(libname, op);
        strcat(libname, ".so");
        void *handle = dlopen(libname, RTLD_LAZY);
        if (!handle) {
            printf("Error loading %s\n", libname);
            continue;
        }
        int (*func)(int, int);
        func = (int (*)(int, int)) dlsym(handle, op);

        if (!func) {
            printf("Error finding function %s\n", op);
            dlclose(handle);
            continue;
        }
        int result = func(a, b);
        printf("%d\n", result);
        dlclose(handle);
    }

    return 0;
}