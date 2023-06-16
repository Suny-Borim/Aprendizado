import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { MODAL_DEFAULT_CONFIG } from 'app/core/utils/utils.service';
import { BsModalRef, BsModalService } from 'ngx-bootstrap';
import { ModalComunicadoLoteComponent } from './modal-comunicado-lote/modal-comunicado-lote.component';

@Component({
  selector: 'app-envio-comunicacao-lote',
  templateUrl: './envio-comunicacao-lote.component.html',
  styleUrls: ['./envio-comunicacao-lote.component.scss']
})
export class EnvioComunicacaoLoteComponent implements OnInit {

  private envioComunicado: BsModalRef;
  constructor(
    private bsModalService: BsModalService,

  ) {}


  ngOnInit() {
  }

  mostrarModalEnvio() {
    this.showMensagemConfirmar();
  }


  showMensagemConfirmar() {
    this.envioComunicado = this.bsModalService.show(ModalComunicadoLoteComponent, {
      ...MODAL_DEFAULT_CONFIG,
      class: "modal-centralizado modal-lg",
      initialState: {
        fecharModal: () => {
          this.envioComunicado.hide();
        }
      },
    });
  }



}
