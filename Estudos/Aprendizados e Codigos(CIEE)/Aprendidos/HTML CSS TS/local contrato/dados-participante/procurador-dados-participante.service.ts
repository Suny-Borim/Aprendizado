import { Injectable } from '@angular/core';
import { ServicoBase } from 'app/core/servico-base.service';
import { HttpClient } from '@angular/common/http';
import { SessionService } from 'app/core/session/session.service';
import { ToastrService } from 'ngx-toastr';
import { Observable } from 'rxjs/Observable';

import { DadosParticipante } from './participanteContrato.model';

@Injectable()
export class ProcuradorDadosParticipantes extends ServicoBase<DadosParticipante> {

  mensagemErro = '';

  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService,
  ) {
    super(
      '/company/company/participante/:documento/contrato/:idContrato',
      http,
      sessionService,
      toastrService,
    );
  }

  procuraDados(documento: string, idContrato: number): Observable<DadosParticipante> {
    return this.obter({documento, idContrato}, {}, this.basePath);
  }

}
