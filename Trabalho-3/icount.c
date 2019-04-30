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

		printf("%s\n", full_path);

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
		if(buf.st_mode == S_IFREG){
			contador++;
		}
	}
	printf("%d\n", contador);
}

int main(int argc, char **argv){
    int opt;

    if(argc < 2 || argc > 3){
    	fprintf(stderr, "Favor utilizar o formato: %s <modificador> <diretorio>\n", argv[0]);
    	return 1;
    }

    walk_dir(".", (void*) conta);

    if(strlen(argv[1]) == 2){

	    opt = getopt(argc, argv, "rdlbc");

	    switch(opt){
	    	case 'r':
	    		file_type = 0;
	    		break; 
	    	case 'd':
	    		printf("oi2\n");
	    		break;
	    	case 'l':
	    		break;
	    	case 'b':
	    		break;
	    	case 'c':
	    		break;
	    	default:
	    		break;
	    }

	}

    // for(nopen = fd = 0; fd < getdtablesize(); fd++){
    //     if(isopen(fd)){
    //         nopen++;
    //     }
    // }

    // printf ("\nExistem %d descritores abertos\n", nopen);
    return (0);
}