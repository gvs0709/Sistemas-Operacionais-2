#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>

//int sair = 0;

void signal_handler(int sig){
    system("echo Encerrando daemon... >> daemon_log.txt");
    //sair = 1;
}

int main(int argc, char *argv[]){
    FILE *log_file;
    int segundos = 2; // Tempo padrão de verificação
    //clock_t parcial1, parcial2;
    //struct sigaction act;
    
    if(argc > 1){
        segundos = atoi(argv[1]); // Se foi passado um tempo de verificação, troca o padrão pelo tempo passado
        //printf("segundos = %d\n", segundos);
    }

    /*else{
        printf("Nenhum argumento passado. Utilizando valor padrão (2s)\n");
    }*/

    /*act.sa_handler = signal_handler;
    sigfillset(&act.sa_mask);
    sigdelset(&act.sa_mask, SIGINT);
    sigaction(SIGINT, &act, NULL);*/
    
    log_file = fopen("daemon_log.txt", "w");
    //parcial1 = clock(); // Começa a medir o tempo
    //parcial2 = parcial1; // Parciais começam iguais

    while(1){
        //if((parcial2 * 1000. / CLOCKS_PER_SEC) - (parcial1 * 1000. / CLOCKS_PER_SEC) >= segundos){
        if(fork() == 0){
            system("ps aux | grep \"Z\" >> daemon_log.txt && echo \"====================================================================\" >> daemon_log.txt");

            //parcial1 = clock(); // Nova parcial 1 para começar a contar até 'segundos' novamente
            exit(0);
        }

        //parcial2 = clock(); // Atualiza parcial 2 até diferença com parcial 1 ser >= a 'segundos'
        sleep(segundos);
        
        //fprintf(log_file, "%d\n", segundos);

        /*if(sair){
            break;
        }*/
    }
    
    fclose(log_file);
    
    return 0;
}
