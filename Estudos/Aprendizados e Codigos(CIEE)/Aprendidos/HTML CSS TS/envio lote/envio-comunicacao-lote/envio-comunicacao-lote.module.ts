import { FormsModule } from '@angular/forms';
import { MultiploSeletorModule } from './../../ui/selects/multiplo-seletor/multiplo-seletor.module';
import { PageModule } from './../../ui/page/page.module';
import { NgxMatSelectSearchModule } from 'ngx-mat-select-search';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatInputModule } from '@angular/material/input';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EnvioComunicacaoLoteComponent } from './envio-comunicacao-lote.component';
import { BlocoEscolaridadeComponent } from './bloco-escolaridade/bloco-escolaridade.component';
import { BlocoBuscaEstudantesComponent } from './bloco-busca-estudantes/bloco-busca-estudantes.component';
import { BlocoTipoComunicacaoComponent } from './bloco-tipo-comunicacao/bloco-tipo-comunicacao.component';
import { InputMaterialModule } from 'app/ui/input-material/input-material.module';
import { SelectMaterialModule } from 'app/ui/select-material/select-material.module';
import { FormularioModule } from 'app/ui/formulario/formulario.module';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { StepLateralModule } from 'app/step-lateral/step-lateral.module';
import { MultiSelectMaterialModule } from 'app/ui/multi-select-material/multi-select-material.module';
import { RadioButtonMaterialModule } from 'app/ui/radio-button-material/radio-button-material.module';
import { MatRadioModule } from '@angular/material';
import { ModalComunicadoLoteModule } from './modal-comunicado-lote/modal-comunicado-lote.module';



@NgModule({
  imports: [
    CommonModule,
    MatInputModule,
    FormularioModule,
    MatSelectModule,
    MatFormFieldModule,
    NgxMatSelectSearchModule,
    PageModule,
    MultiploSeletorModule,
    SelectMaterialModule,
    MultiSelectMaterialModule,
    FormsModule,
    MatCheckboxModule,
    StepLateralModule,
    RadioButtonMaterialModule,
    MatRadioModule,
    InputMaterialModule,
    ModalComunicadoLoteModule,
  ],
  declarations: [
    EnvioComunicacaoLoteComponent,
    BlocoEscolaridadeComponent,
    BlocoBuscaEstudantesComponent,
    BlocoTipoComunicacaoComponent,
  ],
  exports: [
    EnvioComunicacaoLoteComponent,
  ]
})
export class EnvioComunicacaoLoteModule { }
