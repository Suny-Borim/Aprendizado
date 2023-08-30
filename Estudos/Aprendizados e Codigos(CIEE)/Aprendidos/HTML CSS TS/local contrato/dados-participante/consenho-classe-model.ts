interface ConselhoClasseAtributos {
  id?: number;
  nome?: string;
  ativo?: boolean;
  numero?: string;
}


export class DadosConselhoClasse implements ConselhoClasseAtributos {
  id?: number;
  nome?: string;
  ativo?: boolean;
  numero?: string;

  constructor(dados: ConselhoClasseAtributos) {
    this.id = dados.id;
    this.nome = dados.nome;
    this.ativo = dados.ativo;
    this.numero = dados.numero;
  }

}
