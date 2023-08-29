// tslint:disable
import { Injectable } from '@angular/core';
import { ServicoBase } from 'app/core/servico-base.service';
import { EducationInstitutionCampus } from 'app/core/ciee-unit/education-institution-campus/education-institution-campus.model';
import { Page } from 'app/core/page.model';
import { PagedData } from 'app/core/paged-data';
import { Response } from '@angular/http';
import { ToastrService } from 'ngx-toastr';
import { HttpClient } from '@angular/common/http';
import { SessionService } from 'app/core/session/session.service';
import { Observable } from 'rxjs/Observable';
import { IECampusFiltro } from './ie-filtro-request.model';
// tslint:enable


interface ContatoAttributos {
  id?: number
}

export class Contato implements ContatoAttributos {
  id?: number;

  constructor(attr: ContatoAttributos) {
    this.id = attr.id
  }
}

interface EnderecoAttributos {
  bairro?: string;
  cep?: string
  cidade?: string;
  complemento?: string;
  endereco?: string;
  estado?: string;
  numero?: string;
  tipo?: string;
}

export class Endereco implements EnderecoAttributos {
  bairro?: string;
  cep?: string
  cidade?: string;
  complemento?: string;
  endereco?: string;
  estado?: string;
  numero?: string;
  tipo?: string;

  constructor(attr: EnderecoAttributos) {
    this.bairro = attr.bairro;
    this.cep = attr.cep;
    this.cidade = attr.cidade;
    this.complemento = attr.complemento;
    this.endereco = attr.endereco;
    this.estado = attr.estado;
    this.numero = attr.numero;
    this.tipo = attr.tipo;
  }
}

interface CampusFiltro {
  ativo?: string,
  carteiraId?: number,
  cnpj?: string,
  id?: number,
  nome?: string,
  nomeFantasia?: string,
}


interface CampusAtributos {
  ativo?: boolean,
  carteiraId?: number,
  carteira?: Carteira;
  cnpj?: string,
  contatosIds?: number[],
  endereco?: Endereco,
  id?: number,
  nome?: string,
  nomeFantasia?: string,
  principalContatoId?: number,
  pronatec?: boolean,
  isUnicoCampus?: boolean,
  copiarInformacoes?: boolean,
}

export class Campus implements CampusAtributos {
  ativo?: boolean;
  carteiraId?: number;
  carteira?: Carteira;
  cnpj?: string;
  contatosIds?: number[] = [];
  endereco?: Endereco;
  id?: number;
  nome?: string;
  nomeFantasia?: string;
  principalContatoId?: number;
  pronatec?: boolean;
  isUnicoCampus?: boolean;
  copiarInformacoes?: boolean;

  constructor(attr: CampusAtributos) {
    this.ativo = attr.ativo;
    this.carteiraId = attr.carteiraId;
    this.cnpj = attr.cnpj;
    this.contatosIds = attr.contatosIds;
    this.endereco = attr.endereco;
    this.id = attr.id;
    this.nome = attr.nome;
    this.nomeFantasia = attr.nomeFantasia;
    this.principalContatoId = attr.principalContatoId;
    this.pronatec = attr.pronatec;
    this.isUnicoCampus = attr.isUnicoCampus;
    this.copiarInformacoes = attr.copiarInformacoes;
  }

}

interface EducationInstitutionCampusAtributos {
  campus: EducationInstitutionCampus,
  modifiable: boolean,
}

interface CampusFilter {
  code?: number;
  name?: string;
  address?: string;
  neighborhood?: string;
  city?: string;
  active?: boolean;
}



export class EducationInstitutionCampusNew implements EducationInstitutionCampusAtributos {
  campus: EducationInstitutionCampus;
  modifiable: boolean;

  constructor(attr: EducationInstitutionCampusAtributos) {
    this.campus = attr.campus;
    this.modifiable = attr.modifiable;
  }
}

interface CarteiraAtributos {
  endereco?: Endereco;
  nomeAssistente?: string;
  cadastroAssistente?: string;
  unidadeCieeDescricao?: string;
  unidadeCieeId?: number;
  descricao?: string;
  id?: number;
}

export class Carteira implements CarteiraAtributos {
  endereco?: Endereco;
  nomeAssistente?: string;
  cadastroAssistente?: string;
  unidadeCieeDescricao?: string;
  unidadeCieeId?: number;
  descricao?: string;
  id?: number;

  constructor(attr: CarteiraAtributos) {
    this.endereco = attr.endereco;
    this.nomeAssistente = attr.nomeAssistente;
    this.cadastroAssistente = attr.cadastroAssistente;
    this.unidadeCieeDescricao = attr.unidadeCieeDescricao;
    this.unidadeCieeId = attr.unidadeCieeId;
    this.descricao = attr.descricao;
    this.id = attr.id;
  }

}

@Injectable()
export class InstituicaoEnsinoCampusService extends ServicoBase<any> {

  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService
  ) {
    super(
      '/unit/education-institution/:educationInstitutionId/campus',
      http,
      sessionService,
      toastrService
    )
  }


  listarCampusDetalhes(
    params: CampusFiltro = {},
    pathParams: PlainObject<number | string> = {},
    page = new Page(),
    basePath = this.basePath + '-detalhe'
  ): Observable<PagedData<Campus>> {
    const queryStringParams = { ...params };
    return this.obterListaPaginada(page, pathParams, queryStringParams, basePath);
  }

  filtro(
    params: CampusFiltro = {},
    pathParams: PlainObject<number | string> = {},
    page = new Page(),
    basePath = this.basePath
  ): Observable<PagedData<Campus>> {
    const queryStringParams = { ...params };
    return this.obterListaPaginada(page, pathParams, queryStringParams, basePath);
  }

  filtroCompletoCampus(
    params: CampusFiltro = {},
    pathParams: PlainObject<number | string> = {},
    basePath = this.basePath
  ): Observable<Campus[]> {
    const queryStringParams = { ...params };
    return this.obter(pathParams, queryStringParams, `${basePath}/lista-total-campus`);
  }

  listarCampus(
    pathParams: PlainObject<number | string> = {},
    queryStringParams: PlainObject<number | string> = {},
    basePath = this.basePath
  ): Observable<EducationInstitutionCampusNew[]> {
    return this.http
      .get(this.buildPath(basePath, pathParams, queryStringParams), this.baseHttpOptions())
      .map((response: Response) => response)
      .catch((err) => this.handleError(err, this.sessionService));
  }

  obterCampus(
    instituicaoEnsinoId: number,
    campusId: number,
    basePath = this.basePath + '/:campusId'
  ): Observable<Campus> {
    return this.obter({ educationInstitutionId: instituicaoEnsinoId, campusId: campusId }, {}, basePath);
  }

}

interface IECampusAtributos {
  ativo: boolean;
  cidade: string;
  endereco: string;
  estado: string;
  id: number;
  logradouro: string;
  modificavel: boolean;
  nome: string;

}

export class IECampus implements IECampusAtributos {
  ativo: boolean;
  cidade: string;
  endereco: string;
  estado: string;
  id: number;
  logradouro: string;
  modificavel: boolean;
  nome: string;

  constructor(attr: IECampusAtributos) {
    this.ativo = attr.ativo;
    this.cidade = attr.cidade;
    this.endereco = attr.endereco;
    this.estado = attr.estado;
    this.id = attr.id;
    this.logradouro = attr.logradouro;
    this.modificavel = attr.modificavel;
    this.nome = attr.nome;
  }

}


@Injectable()
export class InstituicaoEnsinoCampusNewService extends ServicoBase<EducationInstitutionCampusNew> {

  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService
  ) {
    super(
      '/unit/education-institution/:educationInstitutionId/campus',
      http,
      sessionService,
      toastrService
    )
  }

  filtro(
    params: PlainObject<number | string> = {},
    pathParams: PlainObject<number | string> = {},
    page: Page,
    basePath = this.basePath
  ): Observable<PagedData<EducationInstitutionCampusNew>> {
    const queryStringParams = { ...params };
    return this.obterListaPaginada(page, pathParams, queryStringParams, basePath);
  }

}


@Injectable()
export class IECampusService extends ServicoBase<IECampus> {

  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService
  ) {
    super(
      '/unit/education-institution/:educationInstitutionId/campus',
      http,
      sessionService,
      toastrService
    )
  }

  filtro(
    params: IECampusFiltro = {},
    pathParams: PlainObject<number | string> = {},
    page: Page,
    basePath = this.basePath
  ): Observable<PagedData<IECampus>> {
    const queryStringParams = { ...params };
    return this.obterListaPaginada(page, pathParams, queryStringParams, basePath);
  }

  obterCampus(
    pathParams: PlainObject<number | string> = {},
    basePath = '/unit/education-institution/:educationInstitutionId/campus/:campusId/'
  ): Observable<IECampus> {
    return this.obter(pathParams, {}, basePath);
  }
}
