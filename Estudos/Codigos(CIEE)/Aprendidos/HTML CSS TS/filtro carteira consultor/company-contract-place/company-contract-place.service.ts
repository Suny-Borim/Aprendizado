
import { Injectable } from '@angular/core';
import { Response } from '@angular/http';

import { CompanyContractPlace, CompanyContractPlaceStatus } from 'app/core/ciee-company/company-contract-place/company-contract-place.model';
import { Page } from 'app/core/page.model';
import { PagedData } from 'app/core/paged-data';
import { SessionService } from 'app/core/session/session.service';
import { ToastrService } from 'ngx-toastr';
import { ServicoBase } from '../../servico-base.service';
import { HttpClient } from '@angular/common/http';
import {Phone, PhoneType} from '../../ciee-core/phone/phone.model';
import { CompanyContractPlaceSerializer } from './company-contract-place.serializer';
import { Observable } from 'rxjs/Observable';
import {CompanyContractPlaceContact} from "../company-contract-place-contact/company-contract-place-contact.model";
import { DadosLocalDTO } from './dados-local-dto.model';


interface SearchParams {
  address?: string;
  blocked?: boolean;
  cieeUnitId?: number;
  contractId?: number;
  document?: string;
  managementId?: number;
  name?: string;
  status?: CompanyContractPlaceStatus;
}

interface CountParams {
  contractId?: number;
}

@Injectable()
export class CompanyContractPlaceService
  extends ServicoBase<CompanyContractPlace> {
  serializer = new CompanyContractPlaceSerializer();

  constructor(http: HttpClient, sessionService: SessionService, toastrService: ToastrService) {
    super(
      '/company/contract-places',
      http,
      sessionService,
      toastrService
    );
  }

  search(
    params: SearchParams,
    page = new Page(),
    basePath = this.basePath + '/search',
  ): Promise<PagedData<CompanyContractPlace>> {
    const queryParams = {...params};
    return this.obterListaPaginada(page, {}, queryParams, basePath)
      .map((pagedData: PagedData<CompanyContractPlace>) => {
        pagedData.data = (pagedData.data || [])
          .map((companyContractPlace: CompanyContractPlace) => {
            return this.serializer.fromJSON(companyContractPlace);
          })
        return pagedData;
      }).toPromise();
  }

  dropdown(
    params: {},
    idContrato,
    basePath = this.basePath + '/:idContrato/dropdown',
  ): Observable<any[]> {
    return this.listar(
      { idContrato },
      params,
      basePath
    )
  }

  count(
    params: CountParams,
    basePath = this.basePath + '/count'
  ): Promise<number> {
    const queryParams = { ...params };
    return this.http
      .get(this.buildPath(basePath, {}, queryParams), {headers: this.headerBase})
      .toPromise()
      .then((response: Response) => response)
      .catch(err => this.handleError(err, this.sessionService));
  }

  mapEntity(contractPlace: CompanyContractPlace) {
    return this.serializer.fromJSON(contractPlace);
  }

  mapEntityArray(companyContractPlaces: CompanyContractPlace[]) {
    return companyContractPlaces.map(entity => this.mapEntity(entity))
  }

  processPhoneType(phones: any[]): void {
    if (phones) {
      phones.forEach(p => {
        if (isNaN(p.phoneType)) {
          return;
        }
        p.phoneType = PhoneType[p.phoneType]
      });
    }
  }

  atualizarParcial(
    entityId: number | string = null,
    entity: Object,
    parametrosParcial: string[],
    basePath = this.basePath,
    pathParams: PlainObject<number | string> = {},
    queryStringParams: PlainObject<number | string> = {},
    errorCallback?: Function
  ): Observable<CompanyContractPlace> {
    if (entity['contacts']) {
      entity['contacts'].forEach(c => {
        this.processPhoneType(c.phones);
      });
    }
    this.processPhoneType(entity['phones']);

    return super.atualizarParcial(entityId, entity, parametrosParcial, basePath, pathParams, queryStringParams, errorCallback);
  }

  atualizarParcialListaTelefones(
    entityId: number | string,
    list: Phone[],
    endPoint: string,
    pathParams: PlainObject<number | string> = {},
    queryStringParams: PlainObject<number | string | boolean> = {},
    basePath = this.basePath,
    errorCallback?: Function
  ): Observable<any[]> {
    this.processPhoneType(list);

    return super.atualizarParcialLista(entityId, list, endPoint, pathParams, queryStringParams, basePath, errorCallback);
  }

  atualizarParcialListaContatos(
    entityId: number | string,
    list: CompanyContractPlaceContact[],
    endPoint: string,
    pathParams: PlainObject<number | string> = {},
    queryStringParams: PlainObject<number | string | boolean> = {},
    basePath = this.basePath,
    errorCallback?: Function
  ): Observable<any[]> {
    list.forEach(c => {
      this.processPhoneType(c.phones);
    });

    return super.atualizarParcialLista(entityId, list, endPoint, pathParams, queryStringParams, basePath, errorCallback);
  }

  validarCnpjLocal(
    dadosLocalDTO: DadosLocalDTO,
    basePath = this.basePath + '/valida-cnpj-local',
    errorCallback?: Function
  ): Observable<any> {
    return super.criar(dadosLocalDTO, {}, {}, basePath, errorCallback);
  }
}
