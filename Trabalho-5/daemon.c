#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>

int pid;

void signal_handler(int sig){
    //printf("%d Entrando no signal handler\n", pid);

    //Se for o filho, atualiza o log
    if(pid == 0){
        system("ps aux | grep \"Z\" | grep -v \"grep\" > daemon_log.txt");
    }
    
    else{
        //Se for o pai e tiver recebido um SIGTERM, matar o filho e finalizar
        if(sig == SIGTERM){
            system("echo \"\nEncerrando daemon...\" >> daemon_log.txt");
            kill(pid, 9);
            exit(0);
        }
        
        /*else{
            fprintf(stdout, "Only SIGKILL and SIGTERM can end this daemon\n");
        }*/
    }
}

int main(int argc, char *argv[]){
    int segundos = 2; // Tempo padrão de verificação
    
    if(argc > 1){
        segundos = atoi(argv[1]); // Se foi passado um tempo de verificação, troca o padrão pelo tempo passado
        //printf("Segundos = %d\n", segundos);
    }

    pid = fork();

    sigset_t mask;
    sigfillset(&mask);//Cria máscara ignorando todos os sinais inicialmente
    sigdelset(&mask, SIGTERM);//Faz alteração para máscara não ignorar o SIGTERM
    sigdelset(&mask, SIGINT);//Faz alteração para máscara não ignorar o SIGTNT
    sigprocmask(SIG_SETMASK, &mask, NULL);

    struct sigaction act;

    //Inicializa infos da sigaction
    act.sa_handler = signal_handler;
    act.sa_mask = mask;
    act.sa_flags = SA_SIGINFO;

    //Seta os listerners dos signals SIGTERM e SIGINT
    sigaction(SIGTERM, &act, NULL);
    sigaction(SIGINT, &act, NULL);

    while(1){
        if(pid == 0){
            //printf("Aguardando sinal do pai\n");
            pause();
        }
        
        else{
            sleep(segundos);
            //printf("Enviando sinal para o filho\n");

            //A cada intervalo de segundos, envia um sinal para o filho para
            //avisar que tem que atualizar o log
            kill(pid, 2);
        }
    }
    
    return 0;
}