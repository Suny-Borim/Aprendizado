import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { BaseComponent } from 'app/shared/components/base-component/baseFormulario.component';
import { Subject } from 'rxjs';
import { ServicoAlertaService } from 'app/core/ciee-notification/servico-alerta.service';
import { FormUtilsService } from 'app/core/utils/form-utils.service';

@Component({
  selector: 'app-modal-comunicado-lote',
  templateUrl: './modal-comunicado-lote.component.html',
  styleUrls: ['./modal-comunicado-lote.component.scss']
})
export class ModalComunicadoLoteComponent extends BaseComponent implements OnInit {

  @Input() fecharModal: Function;
  public formComunicado: FormGroup;

  public onClose: Subject<boolean>;


  constructor(
    private formBuilder: FormBuilder,
    private servicoAlertaService: ServicoAlertaService,
    public formUtils: FormUtilsService,
  ) {
    super();
  }

  mostrarQuantidade = false;


  ngOnInit() {
    this.onClose = new Subject();
    const quantidadeField = new FormControl('', [Validators.required]);
    this.formComunicado = this.formBuilder.group({
      enviarParaTodos: [''],
      informarLimite: [''],
      quantidade: quantidadeField,
    });
  }

  public alternarExibicao() {
    this.mostrarQuantidade = true;
  }

  public fechaQuantidade(){
    this.mostrarQuantidade = false;
  }

  fechar() {
    this.onClose.next(false);
    this.fecharModal();
  }

  mensagemEnviar(){
  this.servicoAlertaService.mostrarMensagemSucesso('Deu certo')
  this.onClose.next(false);
  this.fecharModal();
   return;
  }

}
