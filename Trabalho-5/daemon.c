#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){

    FILE *log_file;
    int segundos = 2;
    
    if(argc == 2){
        segundos = atoi(argv[1]);
    }else{
        printf("Nenhum argumento passado. Utilizando valor padrão (2s)\n");
    }
    
    log_file = fopen("daemon_log.txt", "w");
    
    system("ps aux | grep \"Z\"");
    
    fprintf(log_file, "%d\n", segundos);
    
    fclose(log_file);
    
}
