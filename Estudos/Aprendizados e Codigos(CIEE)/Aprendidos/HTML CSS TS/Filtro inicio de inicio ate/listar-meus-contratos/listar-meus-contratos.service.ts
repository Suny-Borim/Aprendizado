import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

import { ToastrService } from 'ngx-toastr';

import { ServicoBase } from 'app/core/servico-base.service';
import { SessionService } from 'app/core/session/session.service';
import { ListarMeusContratos } from 'app/core/ciee-admin/listar-meus-contratos/listar-meus-contratos.model';


@Injectable()
export class ListarMeusContratosService extends ServicoBase<ListarMeusContratos> {
  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService,
  ) {
    super(
      '/vagas/contratos/local-contrato/:localId',
      http,
      sessionService,
      toastrService
    )
  }
}



