import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatRadioChange } from '@angular/material';
import { ActivatedRoute } from '@angular/router';
import { IncluirAreaAtuacaoAprendizComponent } from 'app/admin/area-atuacao-aprendiz/paginas/incluir/incluir.component';
import { FilterProps } from 'app/components/filters/filter-props.model';
import { AppValidators } from 'app/core/app-validators.model';
import { CidadeService } from 'app/core/ciee-admin/cidade/cidade-service.service';
import { Cidade } from 'app/core/ciee-admin/cidade/cidade.model';
import { CityService } from 'app/core/ciee-core/city/city.service';
import { State } from 'app/core/ciee-core/state/state.model';
import { StateService } from 'app/core/ciee-core/state/state.service';
import { ServicoAlertaService } from 'app/core/ciee-notification/servico-alerta.service';
import { Page } from 'app/core/page.model';
import { ServicoBase } from 'app/core/servico-base.service';
import { UtilsService } from 'app/core/utils/utils.service';
import { ComponentPaginaPadrao } from 'app/ui/page/component-pagina-padrao';
import { OpcoesAtributos } from 'app/ui/select-material/select-material.component';
import { BsModalService } from 'ngx-bootstrap';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { catchError } from 'rxjs/operators/catchError';

@Component({
  selector: 'app-bloco-busca-estudantes',
  templateUrl: './bloco-busca-estudantes.component.html',
  styleUrls: ['./bloco-busca-estudantes.component.scss']
})

export class BlocoBuscaEstudantesComponent extends ComponentPaginaPadrao implements OnInit {

  @Input() formFieldClass: any;
  @Input() basePath: string;
  alternaEstadoCep: false;
  municipiosLista = new FormControl('');

  unidadeCiee = new FormControl('');

  opcoesUnidadeCiee: OpcoesAtributos[] = [
    {valor: 'TO', texto: 'Todos'},
    {valor: 'RB', texto: 'Codigo - Posto Arapiraca'},
    {valor: 'AL', texto: 'Codigo - Estadual de Maceió'},
    {valor: 'AN', texto: 'Codigo - Unidade Anadia'},
    {valor: 'MC', texto: 'Codigo - Unidade Mogi das Cruzes'},
    {valor: 'NT', texto: 'Codigo - Unidade Niteroi'},
  ];

  EstadoCep = new FormControl('' , [Validators.required]);

  opcaoEstadoCep: OpcoesAtributos[] = [
    {valor: 'UF', texto: 'Estado'},
    {valor: 'CEP', texto: 'Faixa de CEP'},
    {valor: 'UNIDADE_CIEE', texto: 'Unidades CIEE'},
  ]

  listaEstados: OpcoesAtributos[] = [{ texto: '', valor: null }];
  page = new Page();
  size = 30;

  public carregandoCidades = false;
  public readonly = true;
  public cidades = [];

  private cidadesEncontradas: Cidade[] = [];


  constructor(
    private formBuilder: FormBuilder,
    modalService: BsModalService,
    private stateService: StateService,
    private cityService: CityService,
    private utilsService: UtilsService,
    private servicoAlertaService: ServicoAlertaService,
    private route: ActivatedRoute,
  ) {
    super(modalService);
   }

   CEP_MAKS = [ /\d/, /\d/, /\d/, /\d/, /\d/, '-', /\d/, /\d/, /\d/];

  formulario: FormGroup;
  municipios: OpcoesAtributos[] = [];
  todosOsEstados: FilterProps[] = [];
  carregando = false;
  filtroCidadesControl = new FormControl(null, [Validators.minLength(3)]);
  listaCidades: OpcoesAtributos[] = [{ texto: '', valor: null }];
  disableDropdowns: boolean = true;

  ngOnInit() {
    this.buildForm();
    this.buscarEstados();
    this.formulario.get('mostrarEstado').valueChanges.subscribe(selectedState => {
      if (selectedState) {
        this.disableDropdowns = false;
      } else {
        this.disableDropdowns = true;
      }
    });
  }

  onChange(event: MatRadioChange) {
    this.formulario.get('opcaoEstadoCep').setValue(event);
  }

  cleanFilters(grupo:string[]): void {

    if(grupo && grupo.length > 0)
    {
      grupo.forEach(element => {
        this.formulario.get(element).setValue(null);
      });
    }
  }

  buildForm() {


    const mostrarEstadoField = new FormControl('', [Validators.required]);
    const mostrarCidadeField = new FormControl('', [
      Validators.maxLength(150),
      AppValidators.conditional(
        () => Validators.required,
        () => mostrarEstadoField.value,
      ),
    ]);
    const mostrarUnidadeCieeField = new FormControl('', [
      Validators.maxLength(150),
      AppValidators.conditional(
        () => Validators.required,
        () => mostrarEstadoField.value,
      ),
    ]);

    this.sub.sink = mostrarEstadoField.valueChanges.subscribe(v => {
      if (!v) { mostrarCidadeField.reset(); }
    });

    this.sub.sink = mostrarEstadoField.valueChanges.subscribe(v => {
      if (!v) { mostrarUnidadeCieeField.reset(); }
    });

    const cepDe = new FormControl('', [
      Validators.required,
      Validators.maxLength(9),
    ]);

    const cepAte = new FormControl('', [
      Validators.required,
      Validators.maxLength(9),
    ]);

    const opcaoEstadoCepField = new FormControl(null);

    this.formulario = this.formBuilder.group({
      mostrarEstado: mostrarEstadoField,
      mostrarCidade: mostrarCidadeField,
      mostrarUnidadeCiee: mostrarUnidadeCieeField,
      cepDe: cepDe,
      cepAte: cepAte,
      opcaoEstadoCep: opcaoEstadoCepField,
    });

    this.filtrosSearchChanges();
    this.estadoValueChange();
  }

  alternarExibicao(){
    this.alternaEstadoCep = false;
  }

  buscarEstados() {
    this.page.definirPagina(0, this.size, this.page);
    this.stateService.listar()
      .pipe(
        catchError(error => {
          console.error('Error fetching states:', error);
          return of([]);
        })
      )
      .subscribe((states: State[]) => {
        this.todosOsEstados = states.map(state => ({
          valor: state.initials,
          texto: `${state.initials}/${state.description}`

        }));
      });
  }

  filtrosSearchChanges() {

    this.sub.sink = this.filtroCidadesControl.valueChanges.pipe(
      debounceTime(500),
      distinctUntilChanged()
    ).subscribe((valor) => {
      if(valor && this.filtroCidadesControl.valid) {
        this.buscarCidades(this.formulario.get('mostrarEstado').value, valor);
      }
    });
  }

  estadoValueChange(){

    this.sub.sink = this.formulario.get('mostrarEstado').valueChanges.subscribe(v => {
      this.buscarCidades(v, null)
    });
  }

  buscarCidades(estado, filtroCidade){
    if(estado == null){
      return this.listaCidades = []
    }
    this.cityService.searchCity({filter:filtroCidade, stateInitials: estado}).subscribe((cidades) => {
      this.listaCidades = cidades.map(c => {
        return { texto: c.name,  valor: c.name}
      });
    });
  }

}
