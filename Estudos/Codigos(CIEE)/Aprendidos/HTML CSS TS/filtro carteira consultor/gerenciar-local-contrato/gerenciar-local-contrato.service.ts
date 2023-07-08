import { PagedData } from 'app/core/paged-data';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

import { ToastrService } from 'ngx-toastr';

import { ServicoBase } from 'app/core/servico-base.service';
import { SessionService } from 'app/core/session/session.service';
import { GerenciarLocalContrato } from 'app/core/ciee-admin/gerenciar-local-contrato/gerenciar-local-contrato.model';
import { Page } from 'app/core/page.model';
import { Observable } from 'rxjs';


@Injectable()
export class GerenciarLocalContratoService extends ServicoBase<GerenciarLocalContrato> {

  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService,
  ) {
    super(
      '/company/contratos/:contratoId/locais',
      http,
      sessionService,
      toastrService
    );
  }

  obterPorContratoLocalContrato(idLocalContrato: number): Observable<PagedData<any>> {
    const params = {
      contractPlaceId: idLocalContrato
    }
    return this.obterListaPaginada(new Page(), {}, params, '/company/contract-places-address/search');
  }
}
