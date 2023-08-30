interface DadosLocalDTOAttributes {
  cnpj: string;
  idContrato: number;

}

export class DadosLocalDTO implements DadosLocalDTOAttributes {
  cnpj: string;
  idContrato: number;
  constructor(attr: DadosLocalDTOAttributes) {
    this.cnpj = attr.cnpj;
    this.idContrato = attr.idContrato;
  }
}

