import { FormsModule } from '@angular/forms';
import { ModalModule } from './../../../ui/modal/modal/modal.module';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { InputMaterialModule } from './../../../ui/input-material/input-material.module';
import { CourseService } from './../../../core/ciee-core/course/course.service';
import { AppFormGroupComponent } from './../../../ui/formulario/form-group/form-group.component';
import { FormularioModule } from './../../../ui/formulario/formulario.module';
import { PageModule } from 'app/ui/page/page.module';
import { SelectMaterialModule } from './../../../ui/select-material/select-material.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MultiploSeletorModule } from 'app/ui/selects/multiplo-seletor/multiplo-seletor.module';
import { NgxMatSelectSearchModule } from 'ngx-mat-select-search';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatInputModule } from '@angular/material/input';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BlocoEscolaridadeComponent } from './bloco-escolaridade.component';

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
    BrowserAnimationsModule,
    SelectMaterialModule,
    AppFormGroupComponent,
    InputMaterialModule,
    MatCheckboxModule,
    ModalModule,
    FormsModule,
    NgModule
  ],
  declarations: [
    BlocoEscolaridadeComponent
  ],
  exports: [
    BlocoEscolaridadeComponent
  ],
  providers: [
    CourseService,
  ]
})
export class BlocoEscolaridadeModule { }
