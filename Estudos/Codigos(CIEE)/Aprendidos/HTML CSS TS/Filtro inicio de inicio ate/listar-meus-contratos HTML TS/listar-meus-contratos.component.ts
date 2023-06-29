import { ModalContratacaoDiretaV2Component } from 'app/vagas/ui/modal-contratacao-direta-v2/modal-contratacao-direta-v2.component';
import { BaseComponent } from 'app/shared/components/base-component/baseFormulario.component';
import { DatePipe } from '@angular/common';
import { Component, OnChanges, OnInit, ViewChild } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Params } from '@angular/router';
import { PageChangeEvent } from '@progress/kendo-angular-grid';
import { SortDescriptor } from '@progress/kendo-data-query';
import * as Moment from 'moment';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { Observable } from 'rxjs/Observable';

import { ModalVisualizarTceTaComponent } from 'app/admin/gerenciar-contrato-empresa/componentes/modal-listar-tce-ta/modal-listar-tce-ta.component';
import { ListarMeusContratos, ListarMeusContratosPesquisa, NomeEnumStatusContrato, StatusContrato } from 'app/core/ciee-admin/listar-meus-contratos/listar-meus-contratos.model';
import { ListarMeusContratosService } from 'app/core/ciee-admin/listar-meus-contratos/listar-meus-contratos.service';
import { CieeAuthUserService } from 'app/core/ciee-auth/ciee-auth-user/ciee-auth-user.service';
import { CabecalhoContratoEmpresa } from 'app/core/ciee-company/cabecalho-contrato-empresa/cabecalho-contrato-empresa.model';
import { CompanyContractDocumentService } from 'app/core/ciee-company/company-contract-document/company-contract-document.service';
import { CompanyPurposeType, CompanyPurposeTypes } from 'app/core/ciee-company/company-contract-info/company-contract-info.model';
import { TipoAssinatura } from 'app/core/ciee-documents/assinatura-eletronica/tipo-assinatura.enum';
import { DocumentService } from 'app/core/ciee-documents/document/document.service';
import { ServicoAlertaService } from 'app/core/ciee-notification/servico-alerta.service';
import { TipoContrato } from 'app/core/enums/tipoContrato.enum';
import { NavigateService } from 'app/core/navigate.service';
import { Page } from 'app/core/page.model';
import { SessionService } from 'app/core/session/session.service';
import { BreakpointMedia } from 'app/core/utils/grid/breakpoint-media';
import { MODAL_DEFAULT_CONFIG, UtilsService } from 'app/core/utils/utils.service';
import { Row } from 'app/shared/abstract/paginated-list.component';
import { ItemMenuCodigoTipoAprendiz, ItemMenuCodigoTipoEstagio } from 'app/shared/menus/gerenciar-contrato-menu-button/item-menu-codigo.enum';
import { ModalAssinaturaEletronicaEmbarcadaComponent } from 'app/ui/assinatura-eletronica/modal-assinatura-eletronica-embarcada/modal-assinatura-eletronica-embarcada.component';
import { LabelFiltroAvancado } from 'app/ui/formulario/filtro-avancado/filtro-avancado.component';
import { ModalComponent } from 'app/ui/modal/modal/modal.component';
import { AssinaturaEletronicaService } from 'app/vagas/contratacao-estagiario/componentes/modal-assinatura/assinatura-eletronica.service';


@Component({
  selector: 'app-listar-meus-contratos',
  templateUrl: './listar-meus-contratos.component.html',
  styleUrls: ['./listar-meus-contratos.component.scss']
})
export class ListarMeusContratosComponent	extends BaseComponent implements OnInit, OnChanges {

  public gridData: any;
  public page = new Page();
  public loading: (boolean) = false;
  public formGrid: FormGroup;
  public dataItem: any;
  public ordenacao: SortDescriptor[] = [];
  public filtroAbertoFlag = false;
  public fecharForm: Boolean = false;
  public fechaAutomatico: Boolean = false;
  public empresa: (boolean) = false;
  public tipoAssinatura = TipoAssinatura;
  paginaGrid = 0;

  TipoContrato = TipoContrato;
  StatusContrato = StatusContrato;
  NomeEnumStatusContrato = NomeEnumStatusContrato
  contratoId: number;
  localId: number;

  public dataInicioAteErrorMessage: string;
  public dataInicioDeErrorMessage: string;
  public dataInicioDe: string;
  public dataInicioAte: string; 

  public dataTerminoAteErrorMessage: string;
  public dataTerminoDeErrorMessage: string;
  public dataTerminoDe: string;
  public dataTerminoAte: string;

  public cpfEstudanteErrorMessage: string;

  public tipoContrato: string = CompanyPurposeTypes.INTERNSHIP;

  public parametrosUrl: Map<string, string> = new Map();

  public dataMaxima = Moment().add(100, 'years').toDate();

  public BreakpointMedia = BreakpointMedia;

  private readonly datePipe = new DatePipe('pt-BR');
  private modalAssinaturaEletronica: BsModalRef;
  private modalVisualizarTceTa: BsModalRef;
  public modalContrataocaoDireta: BsModalRef;

  @ViewChild('modalContratacaoDireta') modalContratacaoDireta: ModalComponent;

  public cpfMask = [/\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '-', /\d/, /\d/];

  public labelsFiltro: LabelFiltroAvancado[] = [
    { propriedade: 'idContratoEstudanteEmpresa', titulo: 'Id do contrato' },
    { propriedade: 'nomeEmpresa', titulo: 'Nome empresa' },
    { propriedade: 'codigoEstudante', titulo: 'Código do estudante' },
    { propriedade: 'cpfEstudante', titulo: 'CPF do estudante' },
    { propriedade: 'nomeEstudante', titulo: 'Nome do estudante' },
    { propriedade: 'dataInicioDe', titulo: 'Data inicio de' },
    { propriedade: 'dataInicioAte', titulo: 'Data inicio até' },
    { propriedade: 'dataTerminoDe', titulo: 'Data término de' },
    { propriedade: 'dataTerminoAte', titulo: 'Data término até' },
    { propriedade: 'filtroInicioDeAte', titulo: 'Data inicio' },
    { propriedade: 'filtroDeAte', titulo: 'Data término' },
    { propriedade: 'numeroAutorizacao', titulo: 'Autorização de atendimento' },
  ];

  constructor(
    public navigateService: NavigateService,
    private route: ActivatedRoute,
    private sessionService: SessionService,
    private cieeAuthUserService: CieeAuthUserService,
    private servicoAlertaService: ServicoAlertaService,
    private listarMeusContratosService: ListarMeusContratosService,
    private modalService: BsModalService,
    private companyContractDocumentService: CompanyContractDocumentService,
    private documentService: DocumentService,
    private utilsService: UtilsService,
    public assinaturaEletronicaService: AssinaturaEletronicaService,
  ) {
    super()
    this.empresa = this.sessionService.user.isEmpresa;
  }


  ngOnInit(): void {
    this.page.viewPageNumber = 1;
    this.buildFormPesquisarMeusContrato();
    this.pegarParametrosUrl();
    this.filtrar();
  }

  ngOnChanges(): void {
    this.buildFormPesquisarMeusContrato();
  }

  private pegarParametrosUrl() {
    this.sub.sink = this.route.params.subscribe((params: Params) => {
      if (params.contratoId && params.localId) {
        this.contratoId = params.contratoId;
        this.localId = params.localId;
        this.parametrosUrl.set(':localId', params.localId);
        this.parametrosUrl.set(':idContrato', params.contratoId);
        this.parametrosUrl.set(':contratoId', params.contratoId);
        this.setDadosLocalSelecionado();
      }
    });
  }

  private setDadosLocalSelecionado() {
    this.sub.sink = this.cieeAuthUserService.findMe().subscribe(usuario => {
      this.sessionService.setDadosLocalSelecionado(this.contratoId, usuario.id, this.localId);
    });
  }

  private buildFormPesquisarMeusContrato(): void {
    this.formGrid = new FormGroup({
      idContratoEstudanteEmpresa: new FormControl(''),
      nomeEmpresa: new FormControl(''),
      codigoEstudante: new FormControl(''),
      cpfEstudante: new FormControl(''),
      nomeEstudante: new FormControl(''),
      dataInicioDe: new FormControl(''),
      dataInicioAte: new FormControl(''),
      dataTerminoDe: new FormControl(''),
      dataTerminoAte: new FormControl(''),
      filtroInicioDeAte: new FormControl(''),
      filtroDeAte: new FormControl(),
      numeroAutorizacao: new FormControl(),
    });
    this.sub.sink = this.formGrid.get('dataInicioDe').valueChanges.subscribe(val => {
      this.dataInicioDeErrorMessage = null;
    });

    this.sub.sink = this.formGrid.get('dataInicioAte').valueChanges.subscribe(val => {
      this.dataInicioAteErrorMessage = null;
    });

    this.sub.sink = this.formGrid.get('dataTerminoDe').valueChanges.subscribe(val => {
      this.dataTerminoDeErrorMessage = null;
    });

    this.sub.sink = this.formGrid.get('dataTerminoAte').valueChanges.subscribe(val => {
      this.dataTerminoAteErrorMessage = null;
    });
  }

  public filtrar() {
    this.dataTerminoAteErrorMessage = '';
    this.dataTerminoDeErrorMessage = '';
    this.dataInicioAteErrorMessage = '';
    this.dataInicioDeErrorMessage = '';
    this.fecharForm = false;
    this.fechaAutomatico = false;
    this.page.pageNumber = 0;
    this.limparDatas();
    this.limparDatasInicio();
    this.filtrarContratos();
  }

  public filtrarAberto(aberto) {
    if (aberto) {
      this.filtroAbertoFlag = true;
      this.limparDatas();
    }
  }
  private limparDatasInicio() {
    if (!this.formGrid.get('filtroInicioDeAte').value && this.dataInicioDe && this.dataInicioAte) {
      this.formGrid.get('dataInicioDe').setValue('');
      this.formGrid.get('dataInicioAte').setValue('');
      this.dataInicioAte = null;
      this.dataInicioDe = null;
    }
  }

  private limparDatas() {
    if (!this.formGrid.get('filtroDeAte').value && this.dataTerminoAte && this.dataTerminoDe) {
      this.formGrid.get('dataTerminoDe').setValue('');
      this.formGrid.get('dataTerminoAte').setValue('');
      this.dataTerminoAte = null;
      this.dataTerminoDe = null;
    }
  }

  private filtrarContratos(): void {
    if (this.validaFormPesquisa() && this.localId) {
      this.loading = true;
      this.fecharForm = true;
      this.sub.sink = this.listarMeusContratosService.obterListaPaginada(
        this.page,
        { localId: this.localId },
        this.searchParams())
        .finally(() => {
          this.loading = false;
          this.fechaAutomatico = true;
          this.filtroAbertoFlag = false;
        })
        .subscribe(
          pagedData => {
            this.atualizarContratos(pagedData.page, pagedData.data);
          }, error => {
            this.servicoAlertaService.mostrarMensagemErro(error);
          }
        );
    }
  }

  private validaFormPesquisa(): boolean {
    const dataInicioDe = this.formGrid.get('dataInicioDe').value;
    const dataInicioAte = this.formGrid.get('dataInicioAte').value;

    const dataTerminoDe = this.formGrid.get('dataTerminoDe').value;
    const dataTerminoAte = this.formGrid.get('dataTerminoAte').value;

    if (dataTerminoDe && dataTerminoAte) {
      this.dataTerminoDe = dataTerminoDe;
      this.dataTerminoAte = dataTerminoAte;
      const dataDe = this.datePipe.transform(dataTerminoDe, 'dd/MM/yyyy');
      const dataAte = this.datePipe.transform(dataTerminoAte, 'dd/MM/yyyy');
      this.formGrid.get('filtroDeAte').setValue(' de ' + dataDe + ' até ' + dataAte);
      this.formGrid.get('dataTerminoDe').setValue('');
      this.formGrid.get('dataTerminoAte').setValue('');
    }

    if (dataInicioDe && dataInicioAte) {
      this.dataInicioDe = dataInicioDe;
      this.dataInicioAte = dataInicioAte;
      const dataIniDe = this.datePipe.transform(dataInicioDe, 'dd/MM/yyyy');
      const dataIniAte = this.datePipe.transform(dataInicioAte, 'dd/MM/yyyy');
      this.formGrid.get('filtroInicioDeAte').setValue(' de ' + dataIniDe + ' até ' + dataIniAte);
      this.formGrid.get('dataInicioDe').setValue('');
      this.formGrid.get('dataInicioAte').setValue('');
    }


    if (dataInicioDe && !dataInicioAte) {
      this.formGrid.get('filtroInicioDeAte').setValue('');
      this.dataInicioAteErrorMessage = 'Data início até é requerido';
      this.servicoAlertaService.mostrarMensagemAlerta(this.dataInicioAteErrorMessage);
      return false;
    }

    if (!dataInicioDe && dataTerminoAte) {
      this.formGrid.get('filtroInicioDeAte').setValue('');
      this.dataInicioDeErrorMessage = 'Data início de é requerido';
      this.servicoAlertaService.mostrarMensagemAlerta(this.dataInicioDeErrorMessage);
      return false;
    }

    if (dataTerminoDe && !dataTerminoAte) {
      this.formGrid.get('filtroDeAte').setValue('');
      this.dataTerminoAteErrorMessage = 'Data término até é requerido';
      this.servicoAlertaService.mostrarMensagemAlerta(this.dataTerminoAteErrorMessage);
      return false;
    }

    if (!dataTerminoDe && dataTerminoAte) {
      this.formGrid.get('filtroDeAte').setValue('');
      this.dataTerminoDeErrorMessage = 'Data término de é requerido';
      this.servicoAlertaService.mostrarMensagemAlerta(this.dataTerminoDeErrorMessage);
      return false;
    }

    const dataTerminoDeMax = Moment(dataTerminoDe).add(90, 'days').toDate();
    if (dataTerminoDe && !Moment(dataTerminoAte).isBetween(dataTerminoDe, dataTerminoDeMax)) {
      this.formGrid.get('filtroDeAte').setValue('');
      this.dataTerminoAteErrorMessage = 'Data término até com o intervalo maior que 90 dias';
      this.servicoAlertaService.mostrarMensagemAlerta(this.dataTerminoAteErrorMessage);
      return false;
    }


    let cpfEstudante = null;
    if (this.formGrid && this.formGrid.get('cpfEstudante').value) {
      cpfEstudante = this.retirarMascaraCampos(this.formGrid.get('cpfEstudante').value);
    }

    if (cpfEstudante && cpfEstudante.length <= 10) {
      this.formGrid.get('cpfEstudante').setValue('');
      this.cpfEstudanteErrorMessage = 'CPF do estudante incompleto';
      this.servicoAlertaService.mostrarMensagemAlerta(this.cpfEstudanteErrorMessage);
      return false;
    }

    return true;
  }

  private searchParams(): ListarMeusContratosPesquisa {
    const value = this.formGrid.getRawValue();
    return {
      idContratoEstudanteEmpresa: value.idContratoEstudanteEmpresa,
      nomeEmpresa: value.nomeEmpresa,
      codigoEstudante: value.codigoEstudante,
      cpfEstudante: this.retirarMascaraCampos(value.cpfEstudante),
      nomeEstudante: value.nomeEstudante,
      dataInicioDe: this.formatarData(this.dataInicioDe),
      dataInicioAte: this.formatarData(this.dataInicioAte),
      dataTerminoDe: this.formatarData(this.dataTerminoDe),
      dataTerminoAte: this.formatarData(this.dataTerminoAte),
      numeroAutorizacao: value.numeroAutorizacao
    };
  }

  private formatarData(data) {
    if (data) {
      return Moment(data).format('YYYY-MM-DD')
    }
  }


  private retirarMascaraCampos(campo) {
    return this.retirarMascara(/[^\d]+/g, campo);
  }

  private retirarMascara(expressao: RegExp, campo: string): string {
    return campo && campo.replace(expressao, '');
  }

  private atualizarContratos(page = new Page(), array: any = []): void {
    this.loading = false;
    this.gridData = {
      data: this.modelsToRows(array),
      total: page.totalElements,
    };
  }

  private modelsToRows(contratos: ListarMeusContratos[]): Row[] {
    return contratos.map(model => new ListarMeusContratos(model));
  }

  private montarPagina(): void {
    this.loading = true;
    this.filtrarContratos();
  }

  public pageChange({ skip, take }: PageChangeEvent) {
    this.page.size = take ? take : this.page.size;

    if (skip === 0) {
      this.page.definirPagina(skip, take, this.page);
    }

    if (skip && take) {
      this.page = this.page.definirPagina(skip, take, this.page);
    }
    this.montarPagina();
  }

  public onBlur(event) {
    if (event && event.target && event.target.value) {
      const pagina = event.target.value;
      if (this.page.viewPageNumber > 0 && pagina > 0) {
        this.page.viewPageNumber = pagina;
        this.page.pageNumber = pagina;
        this.page.skip = this.page.size * this.page.pageNumber;
        this.pageChange({ skip: null, take: null });
      }
    }
  }

  public ordenar(ordenacoes: SortDescriptor[]): void {
    if (ordenacoes && ordenacoes[0] && ordenacoes[0].dir) {
      const field = ordenacoes[0].field;
      this.page.sort = field + ',' + ordenacoes[0].dir;
      this.ordenacao = ordenacoes;
    } else {
      this.page.sort = '';
      this.ordenacao = [];
    }
    this.filtrarContratos();
  }

  public selecionarContrato(colunaSelecionada) {
    this.dataItem = colunaSelecionada.selectedRows[0].dataItem;
    if(this.dataItem){
      this.sessionService.codigoContratoEstudante = this.dataItem.numeroContrato.toString();
    }
    if (this.dataItem && this.dataItem.idEstudante && this.dataItem.codigoVaga) {
      let url = `/empresa/gerenciar/contrato/${this.contratoId}/local/${this.localId}/contratados/estudante/`
        + this.dataItem.idEstudante + '/vaga/' + this.dataItem.codigoVaga;

      if (this.dataItem.tipoContrato === TipoContrato.ESTAGIO) {
        url += '/detalhe-estagio';
      } else {
        url += '/detalhe-aprendiz';
      }

      this.navigateService.navigateTo([url]);
    }
  }

  public getAcoes(): Function {
    const self = this;

    return (codigoMenu: string) => {
      switch (codigoMenu) {

        case ItemMenuCodigoTipoEstagio.CONTRATACAO_DIRETA_ESTAGIO_LOCAL_CONTRATO:
          return () => {
            self.abrirContratacaoDireta(CompanyPurposeTypes.INTERNSHIP);
          }

        case ItemMenuCodigoTipoAprendiz.CONTRATACAO_DIRETA_APRENDIZ_LOCAL_CONTRATO:
          return () => {
            self.abrirContratacaoDireta(CompanyPurposeTypes.APPRENTICESHIP);
          }
      }
    }
  }

  trataChamadaModal(nomeModal: string) {
    const tratamentoModal = {
      'Solicitar contratação direta estágio': [this.abrirContratacaoDireta, CompanyPurposeTypes.INTERNSHIP],
      'Solicitar contratação direta aprendiz': [this.abrirContratacaoDireta, CompanyPurposeTypes.APPRENTICESHIP],
    }
    tratamentoModal[nomeModal][0].bind(this)(tratamentoModal[nomeModal][1]);
  }

  private abrirContratacaoDireta(tipo: CompanyPurposeType) {
    this.tipoContrato = tipo;
    this.modalContrataocaoDireta = this.modalService.show(ModalContratacaoDiretaV2Component, {
      class: 'modal-lg',
      ...MODAL_DEFAULT_CONFIG,
      initialState: {
        idContrato: this.contratoId,
        idLocalContrato: this.localId,
        tipoContrato: this.tipoContrato,
        fecharModal: () => {
          this.modalContrataocaoDireta.hide();
        }
      }
    });
  }

  public selectContrato(observable: Observable<CabecalhoContratoEmpresa>) {
    this.sub.sink = observable.subscribe(contrato => {
      this.tipoContrato = contrato.tipoContrato;
    })
  }

  public mostrarModalAssinaturaEletronica(chaveAssinaturaEletronica: string, event: Event) {
    event.stopPropagation();
    this.modalAssinaturaEletronica = this.modalService.show(ModalAssinaturaEletronicaEmbarcadaComponent, {
      class: 'modal-lg',
      ...MODAL_DEFAULT_CONFIG,
      initialState: {
        idEnvelope: chaveAssinaturaEletronica,
        fecharModal: () => this.modalAssinaturaEletronica.hide()
      }
    });
  }

  public downloadContrato(idDocumento: number, event: Event) {
    event.stopPropagation();
    this.sub.sink = this.companyContractDocumentService.obterDocumentoEmpresa(idDocumento, Number(localStorage.getItem('idEmpresa'))).subscribe(retorno => {
      this.documentService.solicitarDownloadArquivoSemLinkS3(retorno.documento, retorno.nomeDocumento);
    }, erroDocumento => {
      this.servicoAlertaService.mostrarMensagemErro(this.utilsService.parseErrorMessage(erroDocumento));
    });
  }

  public abrirModalDeListagemTceTa(tipoAssinatura: string, idContratoEstudanteEmpresa: number): void {
    event.stopPropagation();

    this.modalVisualizarTceTa = this.modalService.show(ModalVisualizarTceTaComponent, {
      class: 'modal-lg',
      ...MODAL_DEFAULT_CONFIG,
      initialState: {
        idContratoEstudanteEmpresa: idContratoEstudanteEmpresa,
        fecharModal: () => this.modalVisualizarTceTa.hide()
      }
    });
  }

  public exibeBotaoDeDownload(tipoAssinatura: TipoAssinatura, idDocumento: number, statusContrato: string): boolean {
    return tipoAssinatura === TipoAssinatura.ASSINATURA_MANUAL && idDocumento && this.contratoNaoFinalizado(statusContrato);
  }

  public exibeBotaoDeEtapasDeAssinatura(tipoAssinatura: TipoAssinatura, chaveAssinaturaEletronica: string, statusContrato: string) {
    // tslint:disable-next-line: max-line-length
    return tipoAssinatura === TipoAssinatura.ASSINATURA_ELETRONICA && chaveAssinaturaEletronica && this.contratoNaoFinalizado(statusContrato);
  }

  public exibeBotaoVisualizar(tipoContrato: TipoContrato, statusContrato: string): boolean {
    // tslint:disable-next-line: max-line-length
    return tipoContrato === TipoContrato.ESTAGIO && (statusContrato === NomeEnumStatusContrato(StatusContrato.EFETIVADO) || statusContrato === NomeEnumStatusContrato(StatusContrato.ENCERRADO));
  }

  public exibirBotaoCalendario(statusContrato: string, idCalendario: number): boolean {
    return ((statusContrato === StatusContrato.EFETIVADO) || (statusContrato === StatusContrato.MANUAL)) && !!idCalendario;
  }

  private contratoNaoFinalizado(statusContrato): boolean {
    // tslint:disable-next-line: max-line-length
    return (statusContrato !== NomeEnumStatusContrato(StatusContrato.EFETIVADO) && (statusContrato !== NomeEnumStatusContrato(StatusContrato.ENCERRADO)));
  }

  public downloadCalendario(id: number) {
    if (id) {
      this.sub.sink = this.documentService.obterDocumentoSemLinkS3(id).subscribe(documento => {
        this.documentService.solicitarDownloadArquivoSemLinkS3(documento.documento, documento.nomeDocumento);
      }, erroDocumento => this.erroMessage());
    } else {
      this.erroMessage();
    }
  }

  private erroMessage() {
    return this.servicoAlertaService.mostrarMensagemAlerta('O documento só será liberado para impressão após assinatura de todas as partes e baixa da via no CIEE');
  }

  voltar() {
    this.navigateService.navigateTo(['/empresa/gerenciar/contrato/' + this.contratoId + '/local/' + this.localId]);
  }

  public exibeBotaoDeclaracaoMatricula(statusContrato: string): boolean{
    return ((statusContrato === StatusContrato.MANUAL) || (statusContrato === StatusContrato.PREENCHIDO) || (statusContrato === StatusContrato.EMITIDO) || (statusContrato === StatusContrato.ENCERRADO));
  }

  public emitirImpressaoDeclaracaoMatricula(idContratoEstudanteEmpresa: number): void {
    this.sub.sink = this.assinaturaEletronicaService.reImprimirDeclaracaoMatricula(idContratoEstudanteEmpresa)
      .subscribe((response) => {
        this.documentService.solicitarDownloadArquivoSemLinkS3(response.documento, "declaracao_matricula_"+idContratoEstudanteEmpresa+".pdf");
      }, er => this.servicoAlertaService.mostrarMensagemErro(er));
  }

  public isEstagio (tipoContrato: TipoContrato): boolean {
    return tipoContrato === TipoContrato.ESTAGIO;
  }

  next(){
    this.paginaGrid ++
  }

  prev(){
    this.paginaGrid --
  }
}
