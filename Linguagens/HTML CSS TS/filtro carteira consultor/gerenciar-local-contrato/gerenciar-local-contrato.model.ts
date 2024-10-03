import { TipoGrupoAcompanhamentoAprendizEnum } from "app/core/enums/tipoGrupoAcompanhamentoAprendiz.enum";

export interface GerenciarLocalContratoPesquisar {
  name?: string;
  contractId?: number;
  contractPlaceId?: number;
  document?: string;
  address?: string;
  managementId?: number;
  cieeUnitIds?: number[];
  cep?: string;
  idLocalContrato?: number;
  descricaoLocal?: string;
  carteiraConsultor?: number;
  descricaoCarteira?: string;
  nomeAssistente?: string;
}

export enum PurposeTypeEnum {
  INTERNSHIP = 'ESTAGIO',
  APPRENTICESHIP = 'APRENDIZ',
}

interface GerenciarLocalContratoAttributes {
  id?: number;
  contract?: number;
  address?: string;
  cep?: string;
  managementDescription?: string;
  cieeUnitDescription?: string;
  descricaoUnidadeCieeLocal?: string;
  name?: string;
  companyName?: string;
  cpf?: string;
  cnpj?: string;
  status?: string;
  blocked?: boolean;
  companyPersonType?: string;
  siglaGerencia?: string;
  descricaoLocal?: string;
  carteiraConsultor?: number;
  descricaoCarteira?: string;
  nomeAssistente?: string;
}

export class GerenciarLocalContrato implements GerenciarLocalContratoAttributes {
  id?: number;
  contract?: number;
  address?: string;
  cep?: string;
  managementDescription?: string;
  cieeUnitDescription?: string;
  descricaoUnidadeCieeLocal?: string;
  name?: string;
  companyName?: string;
  cpf?: string;
  cnpj?: string;
  status?: string;
  blocked?: boolean;
  companyPersonType?: string;
  siglaGerencia?: string;
  descricaoLocal?: string;
  carteiraConsultor?: number;
  descricaoCarteira?: string;
  nomeAssistente?: string;

  constructor( attr:  GerenciarLocalContratoAttributes = {}) {
    this.id = attr.id;
    this.contract = attr.contract;
    this.address = attr.address;
    this.cep = attr.cep;
    this.managementDescription = attr.managementDescription;
    this.cieeUnitDescription = attr.cieeUnitDescription;
    this.descricaoUnidadeCieeLocal = attr.descricaoUnidadeCieeLocal ? attr.descricaoUnidadeCieeLocal : null;
    this.name = attr.name;
    this.companyName = attr.companyName;
    this.cpf = attr.cpf;
    this.cnpj = attr.cnpj;
    this.status = attr.status;
    this.blocked = attr.blocked;
    this.companyPersonType = attr.companyPersonType;
    this.siglaGerencia = attr.siglaGerencia;
    this.descricaoLocal = attr.descricaoLocal;
    this.carteiraConsultor = attr.carteiraConsultor;
    this.descricaoCarteira = attr.descricaoCarteira;
    this.nomeAssistente = attr.nomeAssistente;
  }
}
