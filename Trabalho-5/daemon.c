#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>

void signal_handler(){
    //code
}

int main(int argc, char *argv[]){
    FILE *log_file;
    int segundos = 2; // Tempo padrão de verificação
    clock_t parcial1, parcial2;
    
    if(argc > 1){
        segundos = atoi(argv[1]); // Se foi passado um tempo de verificação, troca o padrão pelo tempo passado
        printf("segundos = %d\n", segundos);
    }

    else{
        printf("Nenhum argumento passado. Utilizando valor padrão (2s)\n");
    }
    
    log_file = fopen("daemon_log.txt", "w");
    parcial1 = clock();
    parcial2 = parcial1;

    printf("parcial1 = %6.3f\nparcial2 = %6.3f\n", (parcial1 * 1000. / CLOCKS_PER_SEC), (parcial2* 1000. / CLOCKS_PER_SEC));

    while(1){
        if((parcial2 * 1000. / CLOCKS_PER_SEC) - (parcial1 * 1000. / CLOCKS_PER_SEC) >= segundos){
            system("ps aux | grep \"Z\" > daemon_log.txt");
            parcial1 = clock();

            printf("--> Nova parcial1\n");
        }

        parcial2 = clock();
        //printf("--> Nova parcial2: %6.3f\n", (parcial2* 1000. / CLOCKS_PER_SEC));
        
        //fprintf(log_file, "%d\n", segundos);
    }
    
    fclose(log_file);
    
    return 0;
}
