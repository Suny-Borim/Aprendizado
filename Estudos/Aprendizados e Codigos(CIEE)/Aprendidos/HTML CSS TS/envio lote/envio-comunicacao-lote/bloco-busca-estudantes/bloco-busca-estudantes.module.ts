import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material';
import { MatRadioModule } from '@angular/material/radio';
import { CidadeService } from 'app/core/ciee-admin/cidade/cidade-service.service';
import { CityService } from 'app/core/ciee-core/city/city.service';
import { StateService } from 'app/core/ciee-core/state/state.service';
import { AppFormGroupComponent } from 'app/ui/formulario/form-group/form-group.component';
import { FormularioModule } from 'app/ui/formulario/formulario.module';
import { InputMaterialModule } from 'app/ui/input-material/input-material.module';
import { MultiSelectMaterialModule } from 'app/ui/multi-select-material/multi-select-material.module';
import { PageModule } from 'app/ui/page/page.module';
import { RadioButtonMaterialComponent } from 'app/ui/radio-button-material/radio-button-material.component';
import { RadioButtonMaterialModule } from 'app/ui/radio-button-material/radio-button-material.module';
import { SelectMaterialModule } from 'app/ui/select-material/select-material.module';
import { BlocoBuscaEstudantesComponent } from './bloco-busca-estudantes.component';

@NgModule({
  imports: [
    CommonModule,
    RadioButtonMaterialModule,
    MatRadioModule,
    FormsModule,
    SelectMaterialModule,
    MultiSelectMaterialModule,
    AppFormGroupComponent,
    FormularioModule,
    PageModule,
    MatFormFieldModule,
    InputMaterialModule,
    RadioButtonMaterialModule,
  ],
  declarations: [
    BlocoBuscaEstudantesComponent,
    RadioButtonMaterialComponent
  ],
  exports: [
    BlocoBuscaEstudantesComponent
  ],
  providers: [
    StateService,
    CityService
  ]
})
export class BlocoBuscaEstudantesModule { }
