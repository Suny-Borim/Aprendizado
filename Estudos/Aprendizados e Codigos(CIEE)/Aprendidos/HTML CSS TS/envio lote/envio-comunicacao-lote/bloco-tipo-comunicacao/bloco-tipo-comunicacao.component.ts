import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';
import { OpcoesAtributos } from 'app/ui/select-material/select-material.component';
import {FormControl, Validators} from '@angular/forms';


@Component({
  selector: 'app-bloco-tipo-comunicacao',
  templateUrl: './bloco-tipo-comunicacao.component.html',
  styleUrls: ['./bloco-tipo-comunicacao.component.scss']
})


export class BlocoTipoComunicacaoComponent implements OnInit {
  formulario: FormGroup;

  emailOusmsopcoes: OpcoesAtributos[] = [
    { texto: 'E-mail', valor: 'E-MAIL' },
    { texto: 'SMS', valor: 'SMS' },
  ];

  constructor(
    private formBuilder: FormBuilder,
  ) { }

  ngOnInit() {
    this.buildForm();
  }

  buildForm() {
    const emailousmsField = new FormControl('', [Validators.required])
    const descricaoField = new FormControl(null,[Validators.required]);
    const corpoEmail = new FormControl(null,[Validators.required]);
    this.formulario = this.formBuilder.group({ 
      emailouSMS: emailousmsField,
      centroCusto: ['',[Validators.required]],
      descricao: descricaoField,
      assunto: ['', [Validators.required]],
      corpoEmail: corpoEmail,
    });
  }

  get exibeMensagemDeErro_descricao_corpoEmail() {
    if (this.formulario && this.formulario.controls && this.formulario.controls.emailouSMS.value == 'SMS' && this.formulario.controls.descricao && this.formulario.controls.descricao.invalid ) {
      return 'Descrição inválida';
    }
    if (this.formulario && this.formulario.controls && this.formulario.controls.emailouSMS.value == 'E-MAIL' && this.formulario.controls.corpoEmail && this.formulario.controls.corpoEmail.invalid ) {
      return 'Corpo e-mail inválido';
    }
    return null;
  }
  get exibeMensagemDeErro_email_sms(){
    if (this.formulario && this.formulario.controls && this.formulario.controls.assunto && this.formulario.controls.emailouSMS.value == 'E-MAIL' && this.formulario.controls.assunto.invalid){
      return 'Assunto inválido'
    }
    if (this.formulario && this.formulario.controls && this.formulario.controls.centroCusto && this.formulario.controls.emailouSMS.value == 'SMS' && this.formulario.controls.centroCusto.invalid){
      return 'Centro de custo inválido'
    }
  }
}
