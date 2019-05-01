#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

int walk_dir(const char *path, void (*func) (const char *)){

	DIR *dirp;
	struct dirent *dp;
	char *p, *full_path;
	int len;

	/* abre o diretório */
	if ((dirp = opendir (path)) == NULL)
		return (-1);
	len = strlen (path);

	/* aloca uma área na qual,garantidamente, o caminho caberá */
	if ((full_path = malloc (len + NAME_MAX + 2)) == NULL){
		closedir (dirp);
		return (-1);
	}

	/* copia o prefixo e acrescenta a ‘/’ ao final */
	memcpy (full_path, path, len);
	p = full_path + len;
	*p++ = '/';

	/* deixa “p” no lugar certo! */
	while ((dp = readdir (dirp)) != NULL){
		/* ignora as entradas “.” e “..” */
		if (strcmp (dp->d_name, ".") == 0 || strcmp (dp->d_name, "..") == 0)
			continue;
		strcpy (p, dp->d_name);

		/* “full_path” armazena o caminho */(*func) (full_path);
	}

	free (full_path);
	closedir (dirp);

	return (0);
}
/* end walk_dir */

int file_type, contador = 0;

void conta(const char *path){

	struct stat buf;

	stat(path, &buf);

	if(file_type == 0){
		if(S_ISREG(buf.st_mode)){
			contador++;
		}
	}

	if(file_type == 1){
		if(S_ISDIR(buf.st_mode)){
			contador++;
		}
	}

	if(file_type == 2){
		if(S_ISLNK(buf.st_mode)){
			contador++;
		}
	}

	if(file_type == 3){
		if(S_ISBLK(buf.st_mode)){
			contador++;
		}
	}

	if(file_type == 4){
		if(S_ISCHR(buf.st_mode)){
			contador++;
		}
	}
}

int main(int argc, char **argv){
    int opt, mod_pos = -1;
    char *path;

    int num_mods = 0;

    while((opt = getopt(argc, argv, "rdlbc")) != -1){

    	switch(opt){
    		case 'r':
    			file_type = 0;
    			break; 
    		case 'd':
    			file_type = 1;
    			break;
    		case 'l':
    			file_type = 2;
    			break;
    		case 'b':
    			file_type = 3;
    			break;
    		case 'c':
    			file_type = 4;
    			break;
    		default:
    			file_type = 0;
    			break;
    	}

    	num_mods++;
    	mod_pos = optind - 1;

    	if(num_mods > 1){
    		fprintf(stderr, "Favor utilizar apenas um modificador\n");
    		fprintf(stderr, "Favor utilizar o formato: %s <modificador> <diretorio 1> <diretorio 2> ... <diretorio n>\n", argv[0]);
    		return 1;
    	}
    }

    printf("mod_pos: %d\n", mod_pos);

    if(argc < 2 || optind >= argc){
    	path = ".";
    	walk_dir(path, (void *) conta);
    	printf("%d\n", contador);
    }else{
    	for(int i = 1; i < argc; i++){
    		contador = 0;
    		if(i == mod_pos){
    			continue;
    		}

    		path = argv[i];
    		walk_dir(path, (void *) conta);
    		printf("\"%s\": %d\n", path, contador);
    	}
    }
    
    return (0);
}