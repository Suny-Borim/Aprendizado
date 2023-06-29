import { TipoAssinatura } from "app/core/ciee-documents/assinatura-eletronica/tipo-assinatura.enum";


export enum StatusContrato {
  EFETIVADO = 'EFETIVADO',
  ENCERRADO = 'ENCERRADO',
  CANCELADO = 'CANCELADO',
  PREENCHIDO = 'PREENCHIDO',
  MANUAL = 'MANUAL',
  EMITIDO = 'EMITIDO',
  ATIVO = 'ATIVO',
  INATIVO = 'INATIVO'
}

export function NomeEnumStatusContrato(tipo: StatusContrato) {
  switch (tipo) {
    case StatusContrato.EFETIVADO:
      return 'Efetivado';
    case StatusContrato.ENCERRADO:
      return 'Encerrado';
    case StatusContrato.CANCELADO:
      return 'Cancelado';
    case StatusContrato.PREENCHIDO:
      return 'Preenchido';
    case StatusContrato.MANUAL:
      return 'Manual';
    case StatusContrato.EMITIDO:
      return 'Emitido';
    case StatusContrato.ATIVO:
      return 'Ativo';
    case StatusContrato.INATIVO:
      return 'Inativo';
    default:
      return ' - ';
  }
}

export interface ListarMeusContratosPesquisa {
  idContratoEstudanteEmpresa?: string;
  nomeEmpresa?: string;
  codigoEstudante?: number;
  cpfEstudante?: string;
  nomeEstudante?: string;
  dataInicioDe?: string;
  dataInicioAte?: string;
  dataTerminoDe?: string;
  dataTerminoAte?: string;
  numeroAutorizacao?: string;
}

interface ListarMeusContratosAttributes {
  idEstudante?: number;
  codigoVaga?: number;
  cpfEstudante?: string;
  numeroContrato?: number;
  nomeEstudante?: string;
  tipoContrato?: string;
  dataInicio?: string;
  dataFim?: string;
  dataCancelamento?: string;
  dataRescisao?: string;
  pcd?: boolean;
  statusContrato?: StatusContrato;
  chaveAssinaturaEletronica?: string;
  idDocumento?: number;
  idCalendario?: number;
  tipoAssinatura?: TipoAssinatura;
  estagioAutonomo?: boolean;
  unidadeCiee?: string;
  numeroAutorizacao?: number;
}

export class ListarMeusContratos implements ListarMeusContratosAttributes {
  idEstudante?: number;
  codigoVaga?: number;
  cpfEstudante?: string;
  numeroContrato?: number;
  nomeEstudante?: string;
  tipoContrato?: string;
  dataInicio?: string;
  dataFim?: string;
  dataCancelamento?: string;
  dataRescisao?: string;
  pcd?: boolean;
  statusContrato?: StatusContrato;
  descricaoStatusContrato?: string;
  chaveAssinaturaEletronica?: string;
  idDocumento?: number;
  idCalendario?: number;
  tipoAssinatura?: TipoAssinatura;
  estagioAutonomo?: boolean;
  unidadeCiee?: string;
  numeroAutorizacao?: number;

  constructor(attr: ListarMeusContratosAttributes = {}) {
    this.idEstudante = attr.idEstudante;
    this.codigoVaga = attr.codigoVaga;
    this.cpfEstudante = attr.cpfEstudante;
    this.numeroContrato = attr.numeroContrato;
    this.nomeEstudante = attr.nomeEstudante;
    this.tipoContrato = attr.tipoContrato;
    this.dataInicio = attr.dataInicio;
    this.dataFim = attr.dataFim;
    this.dataCancelamento = attr.dataCancelamento;
    this.dataRescisao = attr.dataRescisao;
    this.pcd = attr.pcd;
    this.statusContrato = attr.statusContrato;
    this.descricaoStatusContrato = NomeEnumStatusContrato(attr.statusContrato);
    this.chaveAssinaturaEletronica = attr.chaveAssinaturaEletronica;
    this.idDocumento = attr.idDocumento;
    this.idCalendario = attr.idCalendario;
    this.tipoAssinatura = attr.tipoAssinatura;
    this.estagioAutonomo = attr.estagioAutonomo;
    this.unidadeCiee = attr.unidadeCiee;
    this.numeroAutorizacao = attr.numeroAutorizacao;
  }
}
