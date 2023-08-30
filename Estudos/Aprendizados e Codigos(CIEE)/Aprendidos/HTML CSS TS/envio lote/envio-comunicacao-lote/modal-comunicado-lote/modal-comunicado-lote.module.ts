import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ModalComunicadoLoteComponent } from './modal-comunicado-lote.component';
import { FormularioModule } from 'app/ui/formulario/formulario.module';

@NgModule({
  imports: [
    CommonModule,
    FormularioModule,
  ],
  declarations: [ModalComunicadoLoteComponent],
  exports :[
    ModalComunicadoLoteComponent,
  ],
  entryComponents: [
    ModalComunicadoLoteComponent,
  ]
})
export class ModalComunicadoLoteModule { }
