import { Moment } from "moment";
import { CompanyTypeIdentifier } from "app/core/ciee-company/company-type/company-type.model";
import { DadosConselhoClasse } from "app/core/ciee-company/dados-participante/consenho-classe-model";


interface DadosParticipanteAtributos {
  id: number;
  cei?: string;
  nome?: string;
  razaoSocial?: string;
  nomeFantasia?: string;
  cnpj?: string;
  cpf?: string;
  codigoAtividade?: number;
  homePage?: string;
  dataNascimento?: Moment,
  validade?: Moment;
  segmento?: CompanyTypeIdentifier;
  conselhoClasse?: DadosConselhoClasse;
  descricaoLocal?: string;
  carteiraConsultor?: number;
}


export class DadosParticipante implements DadosParticipanteAtributos {
  id: number;
  cei?: string;
  nome?: string;
  razaoSocial?: string;
  nomeFantasia?: string;
  cnpj?: string;
  cpf?: string;
  codigoAtividade?: number;
  homePage?: string;
  dataNascimento?: Moment;
  validade?: Moment;
  segmento?: CompanyTypeIdentifier;
  conselhoClasse?: DadosConselhoClasse;
  descricaoLocal?: string;
  carteiraConsultor?: number;

  constructor(dados: DadosParticipanteAtributos) {
    this.id = dados.id;
    this.cei = dados.cei;
    this.nome = dados.nome;
    this.razaoSocial = dados.razaoSocial;
    this.nomeFantasia = dados.nomeFantasia;
    this.cnpj = dados.cnpj;
    this.cpf = dados.cpf;
    this.codigoAtividade = dados.codigoAtividade;
    this.homePage = dados.homePage;
    this.validade = dados.validade;
    this.conselhoClasse = dados.conselhoClasse;
    this.segmento = dados.segmento;
    this.dataNascimento = dados.dataNascimento;
    this.descricaoLocal = dados.descricaoLocal;
    this.carteiraConsultor = dados.carteiraConsultor;
  }

}
