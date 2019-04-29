#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<errno.h>
#include<string.h>

extern int isopen(int fd);

int main(void){
    int nopen, fd;

    for(nopen = fd = 0; fd < getdtablesize(); fd++){
        if(isopen(fd)){
            nopen++;
        }
    }

    printf ("Existem %d descritores abertos\n", nopen);
    return (0);
}

int isopen(int fd){
    struct stat buf;
    
    if(fstat(fd, &buf) == 0){
    	return 1;
    }
    
    else{
    	printf("Erro fstat: %s\narquivo com fd = %d\n", strerror(errno), fd);
        return 0;
    }
}
