#include <stdio.h>
#include <stdlib.h>

typedef struct Podcast {
	int id;
	char nome[60];
	struct Podcast* next;
	struct Podcast* ini;
}podcast;
typedef struct Playlist {
	podcast* podcast;
	int quantidade;
}playlist;
void add(playlist* base);
void imprimeRecursiva(playlist* base);
void imprimePodcast(podcast* podcast);
int main() {
	playlist* base = (playlist*)malloc(sizeof(playlist));
	base->podcast = NULL;
	base->quantidade = 0;

	int escolha;

	do {
		printf("\n\n  MENU\n");
		printf("  1 - Inserir  \n");
		printf("  2 - Exibir   \n");
		printf("   0 - Sair     \n");
		printf("\n");
		printf("Entre com a opcao desejada: ");
		scanf_s("%d", &escolha);

		switch (escolha)
		{
		case 1:
			add(base);
			break;
		case 2:
			imprimeRecursiva(base);
			break;
		}

	} while (escolha);

	return 0;
}

void add(playlist* base) {
	podcast* pod = base->podcast;
	podcast* novo = (podcast*)malloc(sizeof(podcast));
	novo->next = NULL;
	novo->ini = NULL;
	if (base->podcast == NULL) base->podcast = novo; 
	if (base->podcast->next != NULL) novo->next = base->podcast->next;
	base->quantidade = base->quantidade + 1;
	novo->id = base->quantidade;
	printf("Digite o podcast: ");
	scanf_s("%s", &novo->nome, 60);
}


void imprimeRecursiva(playlist* base) {

	if (base->podcast != NULL) {
		podcast* aux = base->podcast;
		imprimePodcast(aux);
	}
}
void imprimePodcast(podcast* podcast) {
	printf("\n [%d] %s", podcast->id, podcast->nome);
	if (podcast->next != NULL) imprimePodcast(podcast->next);
}
