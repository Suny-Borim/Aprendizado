import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatFormFieldModule, MatInputModule, MatSelectModule } from '@angular/material';
import { FormularioModule } from 'app/ui/formulario/formulario.module';
import { NgxMatSelectSearchModule } from 'ngx-mat-select-search';
import { PageModule } from 'app/ui/page/page.module';
import { MultiploSeletorModule } from 'app/ui/selects/multiplo-seletor/multiplo-seletor.module';
import { SelectMaterialModule } from 'app/ui/select-material/select-material.module';
import { MultiSelectMaterialModule } from 'app/ui/multi-select-material/multi-select-material.module';
import { InputMaterialModule } from 'app/ui/input-material/input-material.module';
import { FormsModule } from '@angular/forms';
import { BlocoTipoComunicacaoComponent } from './bloco-tipo-comunicacao.component';

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
    InputMaterialModule,
  ],  
  declarations: [
    BlocoTipoComunicacaoComponent
  ],
  exports: [
    BlocoTipoComunicacaoComponent
  ],
})
export class BlocoTipoComunicacaoModule { }
