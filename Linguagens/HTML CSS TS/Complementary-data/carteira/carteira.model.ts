export interface CarteiraAtributos {
  id?: number;
  nomeAssistente?: string;
  descricao?: string;
}

export class Carteira implements CarteiraAtributos {
  id?: number;
  nomeAssistente?: string;
  descricao?: string;

  constructor(attr: CarteiraAtributos = {}) {
    this.id = attr.id;
    this.nomeAssistente = attr.nomeAssistente;
    this.descricao = attr.descricao;
  }
}
