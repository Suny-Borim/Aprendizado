import { BlocoEscolaridadeComponent } from './bloco-escolaridade/bloco-escolaridade.component';
import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { MODAL_DEFAULT_CONFIG } from 'app/core/utils/utils.service';
import { BsModalRef, BsModalService } from 'ngx-bootstrap';
import { ModalComunicadoLoteComponent } from './modal-comunicado-lote/modal-comunicado-lote.component';
import { Form, FormControl, FormGroup, FormBuilder, Validators } from '@angular/forms';
import { AppValidators } from 'app/core/app-validators.model';
import { group } from '@angular/animations';
import { BlocoBuscaEstudantesComponent } from './bloco-busca-estudantes/bloco-busca-estudantes.component';
import { BlocoTipoComunicacaoComponent } from './bloco-tipo-comunicacao/bloco-tipo-comunicacao.component';


@Component({
  selector: 'app-envio-comunicacao-lote',
  templateUrl: './envio-comunicacao-lote.component.html',
  styleUrls: ['./envio-comunicacao-lote.component.scss']
})

export class EnvioComunicacaoLoteComponent implements OnInit {

  formulario: FormGroup;
  blocoEscolaridade: any;
  blocoTipoComunicacao: any;
 private envioComunicado: BsModalRef;

 @ViewChild(BlocoBuscaEstudantesComponent) blocoBuscaEstudantesComponent: BlocoBuscaEstudantesComponent;
 @ViewChild(BlocoEscolaridadeComponent) blocoEscolaridadeComponent: BlocoEscolaridadeComponent;
 @ViewChild(BlocoTipoComunicacaoComponent) blocoTipoComunicacaoComponent: BlocoTipoComunicacaoComponent;

  constructor(
    private fb: FormBuilder,
    private bsModalService: BsModalService,

  ) {}

  ngOnInit() {

  }

  mostrarModalEnvio() {
   this.mostrarEnvioComunicado();
  }

  mostrarEnvioComunicado() {
    const blocoBuscaEstudanteForm = this.blocoBuscaEstudantesComponent.formulario.getRawValue();
    const blocoEscolaridadeForm = this.blocoEscolaridadeComponent.formulario.getRawValue();
    const blocoTipoComunicacaoForm = this.blocoTipoComunicacaoComponent.formulario.getRawValue();
    console.log(blocoBuscaEstudanteForm, blocoEscolaridadeForm,blocoTipoComunicacaoForm)
    this.envioComunicado = this.bsModalService.show(ModalComunicadoLoteComponent, {
      ...MODAL_DEFAULT_CONFIG,
      class: 'modal-centralizado modal-lg',
      initialState: {
        fecharModal: () => {
          this.envioComunicado.hide();
        }
      },
    });
  }

}
