#include <stdio.h>
#include <stdlib.h>

typedef struct podcast {
	int valor;
	struct no* ini;
	struct no* fim;
	struct no* next;
	struct no* prev;
}podcast;

typedef podcast* celula;

int main()
{
	
}

void addINI(celula cabeca,int valor) {
			celula nova = (celula)malloc(sizeof(celula));
			if (cabeca->ini == NULL) {
				cabeca->ini = nova;
				cabeca->fim = nova;
				nova->valor = valor;
			}
			nova->valor = valor;
			nova->next = cabeca->next;
			cabeca->next = nova;
}
