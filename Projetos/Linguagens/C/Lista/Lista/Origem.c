#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
	int val;
	struct Node* next;
}node;

void add(node* base);
void remover(node* base);
void show(node* base);
void crescente(node* base);

int main() {
	node* base = (node*)malloc(sizeof(node));
	base->next = NULL;

	int op;

	do {
		printf("\n\n=======MENU=======\n");
		printf("|   1 - Inserir  |\n");
		printf("|   2 - Remover  |\n");
		printf("|   3 - Exibir   |\n");
		printf("|  4 - Crescente |\n");
		printf("|   0 - Sair     |\n");
		printf("==================\n");
		printf("Entre com a opcao desejada: ");
		scanf_s("%d", &op);

		switch (op)
		{
		case 1:
			add(base);
			break;

		case 2:
			remover(base);
			break;

		case 3:
			show(base);
			break;

		case 4:
			crescente(base);
			break;
		}
		
	} while (op);

	return 0;
}

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