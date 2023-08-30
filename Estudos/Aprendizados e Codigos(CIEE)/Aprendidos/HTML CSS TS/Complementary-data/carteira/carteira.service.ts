import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { SessionService } from 'app/core/session/session.service';
import { ToastrService } from 'ngx-toastr';
import { ServicoBase } from 'app/core/servico-base.service';
import { Observable } from 'rxjs/Observable';
import { PagedData } from 'app/core/paged-data';
import { Carteira } from 'app/core/ciee-admin/acompanhamento-vagas/carteira/carteira.model';
import { Page } from 'app/core/page.model';

@Injectable()
export class CarteiraService extends ServicoBase<Carteira> {

  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService
  ) {
    super(
      '/unit/carteiras/dropdown',
      http,
      sessionService,
      toastrService
    );
  }

  // tslint:disable-next-line:max-line-length
  listarCarteiras(page: number, size: number, idsCarteira?: number[], descricao?: string, unidadesCiee?: number[]): Observable<PagedData<Carteira>> {
    const objetoFiltro = {
      ids: idsCarteira,
      descricao: descricao,
      unidadesCiee: unidadesCiee
    }
    const queryStringParams = {
      page: page,
      size: size
    }
    const pagina = new Page({
      pageNumber: page,
      size: size
    })
    return super.criar(objetoFiltro, {}, queryStringParams).map(response => {
      return this.handlePaginatedResponse(response, pagina)
    })
  }
}
