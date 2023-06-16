#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
	int id;
	int val;
	char nome[60];
	struct Node* next;
	struct Node* prev;
	struct Node* ini;
	struct Node* fim;
}node;

//void add(node* base);
//void remover(node* base);
//void show(node* base);
void AddIni(node* base);
void AddFim(node* base);
void ImprimirIni(node* base);
void ImprimirFim(node* base);
//void mostrarIniFim(node* base);
void showRecursiva(node* base);
//void crescente(node* base);

int main() {
	node* base = (node*)malloc(sizeof(node));
	base->next = NULL;
	base->val = 0;
	base->prev = NULL;
	base->ini = NULL;
	base->fim = NULL;

	int op;

	do {
		printf("\n\n   MENU\n");
		printf("(1 - InserirINi)\n");
		printf("(2 - Imprimir)\n");
		printf("(5 - Mostrar inicio e fim  )\n");
		printf("(4 - Inserir next da cabeca)\n");
		printf("(0 - Sair)\n");
		printf("==================\n");
		printf("Entre com a opcao desejada: ");
		scanf_s("%d", &op);

		switch (op)
		{
		case 1:
			AddIni(base);
			break;
		case 2:
			ImprimirIni(base->ini);
			if(base->next != NULL)
			ImprimirFim(base->next);
			break;
		/*case 3:
			mostrarIniFim(base);
			break;
			*/
		case 4:
			AddFim(base);
			break;
			}

		} while (op);

		return 0;
	}
void ImprimirIni(node* ini) {
	if (ini->val != 0) {
		printf("->%d\n", ini->val);
		ImprimirIni(ini->next);
		return;
	}
}
void ImprimirFim(node* base) {
	printf("->%d\n", base->val);
	if (base->next != NULL) {
		ImprimirFim(base->next);
	}
}
/*
void mostrarIniFim(node* base) {
	node* aux = (node*)malloc(sizeof(node));
	aux = base;
	printf("Inicio>%d\nFim>%d\n", aux->ini, aux->fim);
	free(aux);
}
*/
void AddIni(node* base) {
	node* nova = (node*)malloc(sizeof(node));
	if (base->ini == NULL) {
		printf("Digite o valor escolhido:\n");
		scanf_s("%d", &nova->val);
		printf("%d adicionado", nova->val);
		base->ini = nova;
		base->prev = nova;
		nova->next = base;
	}
	else {
		node* anterior = (node*)malloc(sizeof(node));
		anterior = base->prev;
		anterior->next = nova;
		nova->prev = base->prev;
		nova->next = base;
		scanf_s("%d", &nova->val);
		printf("%d adicionado", nova->val);
		base->prev = nova;
	}
}
void AddFim(node* base) {
	node* fim = (node*)malloc(sizeof(node));

	printf("Qual o valor do novo no: ");
	scanf_s("%d", &fim->val);

	fim->next = base->next;
	base->fim = fim;
	base->next = fim;
}

void showRecursiva(node* base) {
	if (base->next != NULL) {
		printf("->%d\n", base->next->val);
		showRecursiva(base->next);
	}
}
/*
void add(node* base) {
	node* new = (node*)malloc(sizeof(node));

	printf("Qual o valor do novo no: ");
	scanf_s("%d", &new->val);

	new->next = base->next;
	base->next = new;
}

void remover(node* base) {
	node* ante = base;
	node* aux = base;
	int valRemov;

	printf("Entre com o valor a ser removido: ");
	scanf_s("%d", &valRemov);

	while (aux->next != NULL) {
		ante = aux;
		aux = aux->next;
		if (aux->val == valRemov) {
			ante->next = aux->next;
			printf("O valor %d foi removido. \n", valRemov);
			return;
		}
	}
	printf("O valor %d nao existe na lista. \n", valRemov);
}
*/
/*
void show(node* base) {
	node* aux = base;

	if (base->next == NULL) {
		printf("A lista esta vazia \n");
		return;
	}

	do {
		aux = aux->next;
		printf("-> %d \n", aux->val);
	} while (aux->next != NULL);
}
*/
/*
void crescente(node* base) {
	node* aux = base;
	node* ant = base;
	node* atual = base->next;
	node* proci = atual->next;

	while (proci != NULL) {
		if (atual->val > proci->val) {
			atual->next = proci->next;
			proci->next = atual;
			ant->next = proci;
			atual = base; //volta pro começo
		}
		ant = atual;
		atual = atual->next;
		proci = atual->next;
	}
}
*/