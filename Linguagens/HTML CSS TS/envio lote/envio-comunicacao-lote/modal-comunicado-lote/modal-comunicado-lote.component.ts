import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { BaseComponent } from 'app/shared/components/base-component/baseFormulario.component';
import { Subject } from 'rxjs';

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
  ) {
    super();
  }

  mostrarQuantidade = false;


  ngOnInit() {
    this.onClose = new Subject();
    this.formComunicado = this.formBuilder.group({
      enviarParaTodos: [''],
      informarLimite: ['']
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

}
