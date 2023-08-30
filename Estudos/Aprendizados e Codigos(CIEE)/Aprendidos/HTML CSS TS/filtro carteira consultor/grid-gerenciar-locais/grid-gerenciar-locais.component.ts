import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';

import { NavigateService } from 'app/core/navigate.service';
import { BreakpointMedia } from 'app/core/utils/grid/breakpoint-media';
import { LabelFiltroAvancado } from 'app/ui/formulario/filtro-avancado/filtro-avancado.component';
import { Management } from 'app/core/ciee-unit/management/management.model';
import { UnidadeCieeSelectorComponent } from 'app/ui/selects/unidade-ciee-selector/unidade-ciee-selector.component';
import { ManagementSelectorComponent } from 'app/ui/selects/management-selector/management-selector.component';
import { ActivatedRoute } from '@angular/router';
import { Page } from 'app/core/page.model';
import { GridDataResult } from '@progress/kendo-angular-grid';

interface Row {
  id?: number;
  document?: string;
  name?: string;
  status?: string;
  address?: string;
  blocked?: string;
  cieeUnitDescription?: string;
  cieeUnitLocalDescription?: string;
  managementDescription?: string;
  managementId?: number;
  cieeUnitId?: number[];
  descricaoLocal?: string;
  idCarteira?: number;
  descricaoCarteira?: string;
  nomeAssistente?: string;
}

@Component({
  selector: 'app-grid-gerenciar-locais',
  templateUrl: './grid-gerenciar-locais.component.html',
  styleUrls: ['./grid-gerenciar-locais.component.scss']
})
export class GridGerenciarLocaisComponent implements OnInit {

  @Input() isLoading: boolean;
  @Input() gridData: GridDataResult;
  @Input() canEdit = true;
  @Input() podeDeletarLocaisDeContrato: boolean;
  @Input() contratoId: number;
  @Input() pagina: Page;

  @Output() deletarLocalEmit = new EventEmitter<Row>();
  @Output() enviarBuscaEmit = new EventEmitter<Row>();

  @ViewChild('ddlUnidadeCIEE') ddlUnidadeCIEE: UnidadeCieeSelectorComponent;
  @ViewChild('gerenciaSelect') gerenciaSelect: ManagementSelectorComponent;

  BreakpointMedia = BreakpointMedia;

  formGrid: FormGroup;
  filtroUnidadesCiee = [];
  filtroAberto = false;
  visualizarMaisColunas = false;

  gerenciaSelecionada: Management = new Management();

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
    { propriedade: 'idCarteira', titulo: 'Carteira consultor'}
  ];

  private _editMode = false;

  get editMode(): boolean {
    return this.canEdit && this._editMode;
  }

  set editMode(value: boolean) {
    this._editMode = this.canEdit && value;
  }

  constructor(
    private navigateService: NavigateService,
    private route: ActivatedRoute
  ) { }

  ngOnInit() {
    this.buildFormPesquisarLocal();
    this.filtrar()
  }

  selecionarLocal(colunaSelecionada) {
    const dataItem = colunaSelecionada.selectedRows[0].dataItem;
    this.navigateService.navigateTo(
      [`/empresa/contrato/${this.contratoId}/locais/${dataItem.id}/visualizar`],
      { relativeTo: this.route }
    );
  }

  deletarLocal(dataItem: Row) {
    this.deletarLocalEmit.emit(dataItem);
  }

  trataOrdenacao(sort: string): string {
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
    } else if (sort === 'descricaoLocal') {
      sort = 'descricao';
    } else if (sort === 'idCarteira') {
      sort = 'idCarteira'
    }
    return sort;
  }

  mostrarDetalhe = (dataItem: any, index: number): boolean => {
    return true;
  }

  filtrar() {
    this.enviarBuscaEmit.emit(this.searchParams());

  }

  managementSelected(management) {
    this.gerenciaSelecionada = management;
  }

  filtrarAberto(aberto) {
    this.filtroAberto = aberto;
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
      idCarteira: new FormControl('')
    });
  }

  private searchParams(): Row {
    const value = this.formGrid.getRawValue();
    this.verificarValoresDosFiltros();
    return {
      managementId: this.gerenciaSelecionada.id,
      cieeUnitId: value.cieeUnitId,
      descricaoLocal: value.descricaoLocal,
      idCarteira: value.idCarteira
    };
  }

  private verificarValoresDosFiltros() {
    if (this.gerenciaSelecionada && this.gerenciaSelecionada.description) {
      this.formGrid.get('managementDescription').setValue(this.gerenciaSelecionada.description);
    }
  }

  mudarVisualizacaoColunas() {
    this.visualizarMaisColunas = !this.visualizarMaisColunas;
  }

}
