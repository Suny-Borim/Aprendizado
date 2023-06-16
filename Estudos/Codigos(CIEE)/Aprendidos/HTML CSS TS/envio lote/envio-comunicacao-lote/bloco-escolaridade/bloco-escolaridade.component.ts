import { BsModalService } from 'ngx-bootstrap';
import { Component, Input, OnInit, ViewEncapsulation } from '@angular/core';
import {
  FormControl,
  FormGroup,
  FormBuilder,
  Validators,
} from '@angular/forms';
import { CourseService } from 'app/core/ciee-core/course/course.service';
import { UtilsService } from './../../../core/utils/utils.service';

import { ActivatedRoute, ParamMap } from '@angular/router';
import { Course } from 'app/core/ciee-core/course/course.model';
import { ServicoAlertaService } from 'app/core/ciee-notification/servico-alerta.service';
import { OpcoesAtributos } from 'app/ui/select-material/select-material.component';
import { ComponentPaginaPadrao } from 'app/ui/page/component-pagina-padrao';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';

export interface ObjetoCampoCadastro {
  nome: string;
  deveValidar: boolean;
}
export interface CamposCadastro {
  nomeCampo: string[] | ObjetoCampoCadastro[];
  ordem: number;
  grupo: string;
}

@Component({
  selector: 'app-bloco-escolaridade',
  templateUrl: './bloco-escolaridade.component.html',
  styleUrls: ['./bloco-escolaridade.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class BlocoEscolaridadeComponent
  extends ComponentPaginaPadrao
  implements OnInit
{
  @Input() formFieldClass = 'envio-lote';
  selectedCourseDurationType: string;

  basesOptions: OpcoesAtributos[] = [
    { valor: 'EA', texto: 'Estudantes ativos disponíveis' },
    { valor: 'EF', texto: 'Estudantes formados' },
    { valor: 'AC', texto: 'Aprendiz contratado' },
    { valor: 'EC', texto: 'Estagiário contratado' },
  ];

  nivelList: OpcoesAtributos[] = [
    { valor: 'SU', texto: 'SU - Superior' },
    { valor: 'TE', texto: 'TE - Técnico' },
    { valor: 'EE', texto: 'EE - Educação Especial' },
    { valor: 'EM', texto: 'EM - Ensino Médio' },
    { valor: 'HB', texto: 'HB - Habilitação básica' },
    { valor: 'EF', texto: 'EF - Ensino Fundamental' },
  ];

  courseDurationTypeOptions: OpcoesAtributos[] = [
    { texto: 'Anual', valor: 'A' },
    { texto: 'Semestral', valor: 'S' },
  ];

  coursePeriodTypeOptions: OpcoesAtributos[] = [];
  courseOptions: OpcoesAtributos[] = [];

  anosList: OpcoesAtributos[] = [
    { valor: '1', texto: '1 ano' },
    { valor: '2', texto: '2 ano' },
    { valor: '3', texto: '3 ano' },
    { valor: '4', texto: '4 ano' },
    { valor: '5', texto: '5 ano' },
    { valor: '6', texto: '6 ano' },
    { valor: '7', texto: '7 ano' },
    { valor: '8', texto: '8 ano' },
    { valor: '9', texto: '9 ano' },
  ];

  semestreList: OpcoesAtributos[] = [
    { valor: '1', texto: '1 semestre' },
    { valor: '2', texto: '2 semestre' },
    { valor: '3', texto: '3 semestre' },
    { valor: '4', texto: '4 semestre' },
    { valor: '5', texto: '5 semestre' },
    { valor: '6', texto: '6 semestre' },
    { valor: '7', texto: '7 semestre' },
    { valor: '8', texto: '8 semestre' },
    { valor: '9', texto: '9 semestre' },
    { valor: '10', texto: '10 semestre' },
    { valor: '11', texto: '11 semestre' },
    { valor: '12', texto: '12 semestre' },
    { valor: '13', texto: '13 semestre' },
    { valor: '14', texto: '14 semestre' },
    { valor: '15', texto: '15 semestre' },
    { valor: '16', texto: '16 semestre' },
    { valor: '17', texto: '17 semestre' },
    { valor: '18', texto: '18 semestre' },
  ];

  horarioAulaOptions: OpcoesAtributos[] = [
    { valor: 'N', texto: 'Noite' },
    { valor: 'V', texto: 'Variável' },
    { valor: 'E', texto: 'Vespertino' },
    { valor: 'M', texto: 'Manhã' },
    { valor: 'I', texto: 'Integral' },
    { valor: 'T', texto: 'Tarde' },
  ];
  filteredOptions: any;

  constructor(
    private servicoAlertaService: ServicoAlertaService,
    private courseService: CourseService,
    private utilsService: UtilsService,
    private route: ActivatedRoute,
    private modalService: BsModalService,
    private formBuilder: FormBuilder
  ) {
    super(modalService);
  }
  // tslint:disable-next-line: member-ordering
  formulario: FormGroup;
  // tslint:disable-next-line: member-ordering
  validacaoCamposCadastro: CamposCadastro[] = [];
  // tslint:disable-next-line: member-ordering
  filtroCursosControl = new FormControl(null, [Validators.minLength(3)]);

  ngOnInit(): void {
    this.buildForm();
  }

  inicializaSteps() {
    this.validacaoCamposCadastro = [
      { nomeCampo: ['base'], ordem: 1, grupo: null },
      { nomeCampo: ['nivel'], ordem: 1, grupo: null },
      { nomeCampo: ['cursos'], ordem: 1, grupo: null },
      { nomeCampo: ['courseDurationType'], ordem: 1, grupo: null },
      { nomeCampo: ['semestre'], ordem: 1, grupo: null },
      { nomeCampo: ['anos'], ordem: 1, grupo: null },
      { nomeCampo: ['horario'], ordem: 1, grupo: null },
    ];
  }

  buildForm() {
    const baseField = new FormControl('', Validators.required);
    const periodoField = new FormControl('', Validators.required);
    const nivelField = new FormControl('', Validators.required);
    const cursosField = new FormControl('', Validators.required);
    const anosField = new FormControl('', Validators.required);
    const semestreField = new FormControl('', Validators.required);
    const horarioField = new FormControl('', Validators.required);
    this.buscarCursos();
    this.formulario = this.formBuilder.group({
      basesOptions: baseField,
      semestreList: semestreField,
      anosList: anosField,
      courseOptions: cursosField,
      nivelList: nivelField,
      horarioAulaOptions: horarioField,
      courseDurationTypeOptions: periodoField,
    });
    this.filtrosSearchChanges();
    this.cursosValueChange();
  }

  filtrosSearchChanges() {
    this.sub.sink = this.filtroCursosControl.valueChanges.pipe(
      debounceTime(500),
      distinctUntilChanged()
      ).subscribe((texto) => {
        if (texto && this.filtroCursosControl.valid) {
          this.buscarCursos(texto);
        }
      });
  }

  cursosValueChange() {

    this.sub.sink = this.formulario.get('courseOptions').valueChanges.subscribe(v => {
      this.buscarCursos(v)
    });
  }

  buscarCursos(texto?: string) {
    this.sub.sink = this.courseService.searchObservable({active: true, description: texto})
    .subscribe((lista: any) => {
        if (lista) {
          this.courseOptions = lista.map(course => {
            return{
              texto: course.courseDescription,
              valor: course.id,
            }
          });
        }
      });
  }
}
