
import { FormGroup, FormControl } from '@angular/forms';
import { Component, OnInit, Input, ViewChild, Output, EventEmitter } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { tap } from 'rxjs/operators/tap';
import { map } from 'rxjs/operators/map';
import { from } from 'rxjs/observable/from';
import { delay } from 'rxjs/operators/delay';
import { switchMap } from 'rxjs/operators/switchMap';

import { Page } from 'app/core/page.model';
import { NavigateService } from 'app/core/navigate.service';
import { Row } from 'app/shared/abstract/paginated-list.component';
import { BreakpointMedia } from 'app/core/utils/grid/breakpoint-media';
import { Management } from 'app/core/ciee-unit/management/management.model';
import { CieeUnitService } from 'app/core/ciee-unit/ciee-unit/ciee-unit.service';
import { ServicoAlertaService } from 'app/core/ciee-notification/servico-alerta.service';
import { LabelFiltroAvancado } from 'app/ui/formulario/filtro-avancado/filtro-avancado.component';
import { FiltroPropriedade } from 'app/admin/education-institution/gerenciador-acessos/shared/filtros/filtro-generico';
import { GerenciarLocalContratoService } from 'app/core/ciee-admin/gerenciar-local-contrato/gerenciar-local-contrato.service';
import { GerenciarLocalContrato, GerenciarLocalContratoPesquisar } from 'app/core/ciee-admin/gerenciar-local-contrato/gerenciar-local-contrato.model';

import { ManagementSelectorComponent } from 'app/ui/selects/management-selector/management-selector.component';
import { SessionService } from 'app/core/session/session.service';
import { BaseComponent } from 'app/shared/components/base-component/baseFormulario.component';

export enum EnumStatusLocalDeContrato {
  ACTIVE = 'Ativo',
  PENDENTE = 'Pendente',
  DEACTIVATED = 'Inativo',
}

@Component({
  selector: 'app-pesquisar-local',
  templateUrl: './pesquisar-local.html',
  styleUrls: ['./pesquisar-local.scss']
})
export class PesquisarLocalComponent	extends BaseComponent implements OnInit {

  @Input() contrato: GerenciarLocalContrato;

  public gridData: any;
  public dataItem: any;
  private contratoId: number;
  public formGrid: FormGroup;
  public filtroUnidadesCiee = [];
  public loading: (boolean) = false;
  public opcoesUnidadeCieeSelecionadas;
  public gerenciaSelecionada: Management = new Management();
  private filtroPropriedade: FiltroPropriedade = new FiltroPropriedade();
  public opcoesUnidadeCiee: { label: string, value: number | string, check: boolean }[] = [];
  public BreakpointMedia = BreakpointMedia;

  public mascaraCEP = [
    /\d/, /\d/, /\d/, /\d/, /\d/, '-', /\d/, /\d/, /\d/,
  ];

  visualizarMaisColunas = false;

  @ViewChild('multiSelectCiee') public multiSelectCiee: any;
  @ViewChild('gerenciaSelect') gerenciaSelect: ManagementSelectorComponent;

  public labelsFiltro: LabelFiltroAvancado[] = [
    { propriedade: 'id', titulo: 'ID'},
    { propriedade: 'document', titulo: 'CNPJ/CPF' },
    { propriedade: 'contract', titulo: 'Nome/Razão' },
    { propriedade: 'address', titulo: 'Endereço' },
    { propriedade: 'cep', titulo: 'CEP' },
    {
      propriedade: 'managementId',
      titulo: 'Gerência',
      valorExibir: (valor: number) => {
        return this.gerenciaSelect.options ? this.gerenciaSelect.options.find((item) => Number(item.value) === valor).label : null;
      }
    },
    { propriedade: 'cieeUnitIds', titulo: 'Unidade CIEE' },
    { propriedade: 'descricaoLocal', titulo: 'Descrição do Local' },
    { propriedade: 'carteiraConsultor', titulo: 'Carteira consultor' }
  ];

  @Output() filtroAberto = new EventEmitter<boolean>();

  constructor(
    public navigateService: NavigateService,
    private cieeUnitService: CieeUnitService,
    private servicoAlertaService: ServicoAlertaService,
    private gerenciarLocalContratoService: GerenciarLocalContratoService,
    private sessionService: SessionService,
    private route: ActivatedRoute
  ) {
    super()
  }


  ngOnInit(): void {
    this.contratoId = this.contrato.id;
    this.buildFormPesquisarLocal();
    this.carregaUnidadesCiee();
    this.filtrar();
    this.filtrarUnidadesCiee();
  }

  mostrarDetalhe = (dataItem: any, index: number): boolean => {
    return true;
  }

  private filtrarUnidadesCiee() {
    const contains = value => s => {
      return this.filtroPropriedade.limpaAcentos(s.label).indexOf(this.filtroPropriedade.limpaAcentos(value)) !== -1
    };

    this.sub.sink = this.multiSelectCiee.filterChange.asObservable().pipe(
          switchMap(value => from([this.opcoesUnidadeCiee]).pipe(
              tap(() => this.multiSelectCiee.loading = true),
              delay(1000),
              map((data) => data.filter(contains(value)))
          ))
      ).subscribe(x => {
          this.multiSelectCiee.loading = false;
          this.filtroUnidadesCiee = x;
      });
  }

  private buildFormPesquisarLocal(): void {
    this.formGrid = new FormGroup({
      id: new FormControl(''),
      document: new FormControl(''),
      contract: new FormControl(''),
      address: new FormControl(''),
      cep: new FormControl(''),
      managementId: new FormControl(''),
      managementDescription: new FormControl(''),
      cieeUnitIds: new FormControl(''),
      descricaoLocal: new FormControl(''),
      carteiraConsultor: new FormControl(''),
    });
  }

  private carregaUnidadesCiee(): void {
    this.sub.sink = this.cieeUnitService.listar().subscribe(listaUnidadesCiee => {
      this.tratarUnidadeCiee(listaUnidadesCiee);
    }, error => {
      this.servicoAlertaService.mostrarMensagemErro(error);
    });
  }

  private tratarUnidadeCiee(listaUnidadesCiee) {
    this.opcoesUnidadeCiee.pop();
    listaUnidadesCiee.map(unidadeCiee => {
      this.opcoesUnidadeCiee.push(
        {
          label: unidadeCiee.description,
          value: unidadeCiee.id.toString(),
          check: false,
        })
    });

    if (this.opcoesUnidadeCiee && this.opcoesUnidadeCiee.length > 0) {
      this.opcoesUnidadeCiee.sort((a, b) => (a.label < b.label) ? -1 : 1);
      this.filtroUnidadesCiee = this.opcoesUnidadeCiee;
    }
  }

  public filtrar(page: Page = new Page()) {
    this.loading = true;
    this.filtrarLocais(page);
  }

  public filtrarAberto(aberto) {
    this.filtroAberto.emit(true);
    if (aberto) {
      this.limparFiltrosUnidadesCiee();
    }
  }

  private limparFiltrosUnidadesCiee() {
    this.opcoesUnidadeCieeSelecionadas = [];
    this.opcoesUnidadeCiee.forEach(unidade => {
      unidade.check = false;
    });
    this.formGrid.get('cieeUnitIds').setValue('');
  }

  get documentoMask(): (string | RegExp)[] {
    const control = this.formGrid.get('document');
    const val = ('' + control.value).replace(/\D/g, '');

    if (val.length > 11) {
      return [
        /\d/, /\d/, '.',
        /\d/, /\d/, /\d/, '.',
        /\d/, /\d/, /\d/, '/',
        /\d/, /\d/, /\d/, /\d/, '-',
        /\d/, /\d/
      ];
    } else {
      return [
        /\d/, /\d/, /\d/, '.',
        /\d/, /\d/, /\d/, '.',
        /\d/, /\d/, /\d/, '-',
        /\d/, /\d/, /\d/
      ];
    }
  }

  private filtrarLocais(page: Page = new Page()): void {
    this.sub.sink = this.gerenciarLocalContratoService.obterListaPaginada(
      page,
      {contratoId: this.contratoId},
      this.searchParams())
      .finally(() => {
        this.loading = false;
        this.filtroAberto.emit(false);
      })
      .subscribe(
        pagedData => {
          this.atualizarLocais(pagedData.page, pagedData.data);
        }, error => {
          this.servicoAlertaService.mostrarMensagemErro(error);
        }
      );
  }

  public trataOrdenacao(sort: string): string {
    if (sort === 'address') {
      sort = 'endereco';
    } else if (sort === 'companyName') {
      sort = 'razaoSocial';
    } else if (sort === 'managementDescription') {
      sort = 'descricaoGerencia';
    } else if (sort === 'cieeUnitDescription') {
      sort = 'descricaoUnidadeCiee';
    } else if (sort === 'blocked') {
      sort = 'bloqueado';
    } else if (sort === 'status') {
      sort = 'situacao';
    }
    return sort;
  }

  private searchParams(): GerenciarLocalContratoPesquisar {
    const value = this.formGrid.getRawValue();
    this.verificarValoresDosFiltros();
    return {
      idLocalContrato: value.id,
      name: value.contract,
      document: this.retirarMascaraCampos(value.document),
      address: value.address,
      managementId: this.gerenciaSelecionada.id,
      cieeUnitIds: this.tratarValoresUnidadeCiee(value.cieeUnitIds),
      cep: this.retirarMascaraCampos(value.cep),
      descricaoLocal: value.descricaoLocal,
      carteiraConsultor: value.carteiraConsultor
    };
  }

  private verificarValoresDosFiltros() {
    if (this.gerenciaSelecionada && this.gerenciaSelecionada.description) {
      this.formGrid.get('managementDescription').setValue(this.gerenciaSelecionada.description);
    }
  }

  private tratarValoresUnidadeCiee(cieeUnitIds) {
    if (cieeUnitIds && cieeUnitIds.length > 0) {
      const unidadesIds: number[] = [];
      cieeUnitIds.forEach(unidade => {
        unidadesIds.push(unidade.value);
      });
      return unidadesIds;
    }
  }

  private atualizarLocais(page = new Page(), array: any = []): void {
    this.loading = false;
    this.gridData = {
      data: this.modelsToRows(array),
      total: page.totalElements,
    };
  }

  private modelsToRows(contratos: GerenciarLocalContrato[]): Row[] {
    return contratos.map(m => this.modelToRow(m));
  }

  private modelToRow(model: GerenciarLocalContrato) {
    return {
      id: model.id,
      contract: model.contract,
      cpf: model.cpf,
      cnpj: model.cnpj,
      name: model.name,
      companyName: model.companyName,
      address: model.address,
      cep: this.retirarMascaraCampos(model.cep),
      managementDescription: model.managementDescription,
      cieeUnitDescription: model.cieeUnitDescription,
      descricaoUnidadeCieeLocal: model.descricaoUnidadeCieeLocal ? model.descricaoUnidadeCieeLocal : null,
      blocked: (model.blocked) ? 'Sim' : 'Não',
      status: (model.status) ? EnumStatusLocalDeContrato[model.status] : '',
      siglaGerencia: model.siglaGerencia,
      descricaoLocal: model.descricaoLocal,
      carteiraConsultor: model.carteiraConsultor,
      descricaoCarteira: model.descricaoCarteira,
      nomeAssistente: model.nomeAssistente
    };
  }

  public managementSelected(management) {
    this.gerenciaSelecionada = management;
  }

  public selecionarLocal(colunaSelecionada) {
    this.dataItem = colunaSelecionada.selectedRows ? colunaSelecionada.selectedRows[0].dataItem  : colunaSelecionada;

    if (colunaSelecionada && this.dataItem.id && this.dataItem.status === EnumStatusLocalDeContrato.ACTIVE) {
      this.sessionService.setSiglaGerencia(this.dataItem.siglaGerencia);
      this.navigateService.navigateTo(
        ['/empresa/gerenciar/contrato/' + this.contratoId + '/local/' + this.dataItem.id]
      );
    } else {
      this.servicoAlertaService.mostrarMensagemAlerta(
        `Cadastro do local de contrato incompleto: para que possas prosseguir,`
        + ` favor complementar o cadastro do local de contrato selecionado.`
      );
    }
  }

  redirecionarBloqueios(colunaSelecionada) {
    this.navigateService.navigateTo(
      [`/empresa/contrato/${this.contratoId}/locais/${colunaSelecionada.id}/bloqueios`],
      { relativeTo: this.route }
    );
  }

  private retirarMascaraCampos(cep) {
    return this.retirarMascara(/[^\d]+/g, cep);
  }

  private retirarMascara(expressao: RegExp, campo: string): string {
    return campo && campo.replace(expressao, '');
  }

  public tagMapper(tags: any[]): any[] {
    return [];
  }

  public onOpen(): void {
    if (this.opcoesUnidadeCiee && this.opcoesUnidadeCiee.length === 0) {
      this.multiSelectCiee.toggle(false);
    }
  }

  public adicionarUnidadeCiee(unidades) {
    this.opcoesUnidadeCiee.forEach(unidade => {
      if (unidades.find(es => es.value === unidade.value)) {
        unidade.check = true;
      } else {
        unidade.check = false;
      }
    });

    this.opcoesUnidadeCieeSelecionadas = unidades.filter(a => a.check === true);
  }

  public removerUnidadeCiee(unidade) {
    this.opcoesUnidadeCieeSelecionadas.forEach(item => {
      if (item.value === unidade.value) {
        item.check = false;
      }
    });

    this.opcoesUnidadeCiee.forEach(item => {
      if (item.value === unidade.value) {
        item.check = false;
      }
    });
  }
  mudarVisualizacaoColunas() {
    this.visualizarMaisColunas = !this.visualizarMaisColunas;
  }


}
