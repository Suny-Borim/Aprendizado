import {Component, HostListener, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {BsModalService} from 'ngx-bootstrap';
import {Subject} from 'rxjs/Subject';

import {EnumPurposeTypeCode} from 'app/core/ciee-company/cabecalho-contrato-empresa/cabecalho-contrato-empresa.model';
import {ServicoAlertaService} from 'app/core/ciee-notification/servico-alerta.service';
import {PermissionService} from 'app/core/ciee-permission/permission.service';
import {CabecalhoVagaEmpresa} from 'app/core/ciee-vagas/cabecalhos/vaga-empresa/cabecalho-vaga-empresa.model';
import {EtapaConfiguracaoService} from 'app/core/ciee-vagas/etapa/configuracao/etapa-configuracao.service';
import {GravadorFiltrosService} from 'app/core/ciee-vagas/gravador-filtros/gravador-filtros.service';
import {VinculosValidosService} from 'app/core/ciee-vagas/vinculos-validos/vinculos-validos.service';
import {TipoContrato} from 'app/core/enums/tipoContrato.enum';
import {Page} from 'app/core/page.model';
import {SessionService} from 'app/core/session/session.service';
import {ComponentPaginaPadrao} from 'app/ui/page/component-pagina-padrao';
import {
  CabecalhoConvocadosComponent,
  SituacaoVagaEnum
} from 'app/vagas/convocados-v2/componentes/cabecalho-convocados/cabecalho-convocados.component';
import {
  CarrosselEtapasConvocadosComponent
} from 'app/vagas/convocados-v2/componentes/carrossel-etapas-convocados/carrossel/carrossel-etapas-convocados.component';
import {
  GridEstudantesEncaminhadosComponent
} from 'app/vagas/convocados-v2/componentes/grid-estudantes-encaminhados/grid-estudantes-encaminhados.component';
import {ListaContratarComponent} from 'app/vagas/convocados-v2/componentes/lista-contratar/lista-contratar.component';
import {
  ListaSelecionadosComponent
} from 'app/vagas/convocados-v2/componentes/lista-selecionados/lista-selecionados.component';
import {ConvocadosService} from 'app/vagas/convocados-v2/convocados.service';
import { VagaCriadaComponent } from 'app/vagas/etapa-vaga-v2/componentes/vaga-criada/vaga-criada.component';
import { MODAL_DEFAULT_CONFIG } from 'app/core/utils/utils.service';

@Component({
  selector: 'app-convocados',
  templateUrl: './convocados.component.html',
  styleUrls: ['./convocados.component.scss']
})
export class ConvocadosComponent extends ComponentPaginaPadrao implements OnInit, OnDestroy {

  fluxoBuscaCandidatos: boolean;
  fluxoVagaInicial: boolean;
  fluxoCopiaVaga: boolean;

  perfilEmpresa: boolean;
  perfilBackOffice: boolean;
  perfilBackOfficePCD: boolean;

  @ViewChild('cabecalhoConvocados') cabecalhoConvocados: CabecalhoConvocadosComponent;
  @ViewChild('gridSelecionados') gridSelecionados: ListaSelecionadosComponent;
  @ViewChild('gridEncaminhados') gridEncaminhados: GridEstudantesEncaminhadosComponent;
  @ViewChild('gridContratar') gridContratar: ListaContratarComponent;
  @ViewChild('carroselEtapas') carroselEtapas: CarrosselEtapasConvocadosComponent;
  @ViewChild(ListaSelecionadosComponent) listagemSelecionados: ListaSelecionadosComponent;

  idEtapa: number;
  apenasEstudantesReprovados: (boolean) = false;
  usuarioBackoffice: (boolean) = false;
  larguraInterna: number;
  visaoEstudantesSelecionados: (boolean) = true;
  visaoEstudantesEncaminhados: (boolean) = false;
  visaoEstudantesContratar: (boolean) = false;
  classificacaoAberta: (boolean) = false;
  codigoVaga: number;
  tipoContrato: string;
  SituacaoVagaEnum = SituacaoVagaEnum;
  idContrato: number;
  idLocalContrato: number;

  vinculoValido: boolean;
  carregandoVinculoValido: boolean;
  processamentoFinalizado$ = new Subject<boolean>();
  exibeCabecalhoConvocados: (boolean) = true;
  isAprendizPaulista = false;
  etapasConcluidas = true;

  get situacaoVinculo(): string {
    return 'Encaminhado';
  }

  get existeEstudanteParaContratar(): boolean {
    return this.convocadosService.paginacaoCanditosContratar ? this.convocadosService.paginacaoCanditosContratar.totalElements !== 0 : false;
  }

  get vagaEncerrada(): boolean {
    return this.convocadosService.situacaoDaVaga === SituacaoVagaEnum.PREENCHIDA || this.convocadosService.situacaoDaVaga === SituacaoVagaEnum.PARCIALMENTE_PREENCHIDA;
  }

  get porcentagemPassoDeConvocacao(): number {
    return this.vagaEncerrada || this.existeEstudanteParaContratar ? 100 : 33.33;
  }

  get esconderConvocados(): boolean {
    return !this.abas || !this.abas.length || !this.abas[0].ativo;
  }

  get esconderEncaminhados(): boolean {
    return !this.abas || !this.abas.length || !this.abas[1].ativo;
  }

  get esconderContratar(): boolean {
    return !this.abas || !this.abas.length || !this.abas[2].ativo;
  }

  constructor(
    private servicoAlertaService: ServicoAlertaService,
    public convocadosService: ConvocadosService,
    public bsModalService: BsModalService,
    private activatedRoute: ActivatedRoute,
    private sessionService: SessionService,
    private permissionService: PermissionService,
    private gravadorFiltrosService: GravadorFiltrosService,
    private vinculosValidosService: VinculosValidosService,
    private etapaConfiguracaoService: EtapaConfiguracaoService
  ) {
    super(bsModalService);
  }


  @HostListener('window:resize', ['$event'])
  onresize() {
    this.larguraInterna = window.innerWidth;
  }

  ngOnInit() {
    this.convocadosService.limparValores();
    this.codigoVaga = this.activatedRoute.snapshot.params['codigoVaga'];

    this.larguraInterna = window.innerWidth;

    this.usuarioBackoffice = this.sessionService.currentUser.isBackOffice;
    this.obterPermissoes();
    this.definirFluxo();
    this.convocadosService.carregarDadosUsuario();

    this.verificarVinculosValidos();
    this.isAprendizPaulista = this.sessionService.isApredizPaulistaStorage && this.sessionService.currentUser.isEmpresa;
    if (this.codigoVaga) {
      this.convocadosService.codigoVaga = this.codigoVaga;
      this.verificarEtapas();
    } else {
      this.mostrarErroInfoVaga();
    }
  }

  ngOnDestroy() {
    this.processamentoFinalizado$.complete();
  }

  public atualizarDadosEmpresa(event: CabecalhoVagaEmpresa) {
    this.convocadosService.receberDadosEmpresa(event);
    this.tipoContrato = this.convocadosService.tipoVaga === EnumPurposeTypeCode.APPRENTICESHIP ? TipoContrato.APRENDIZ : TipoContrato.ESTAGIO;
    this.idContrato = this.convocadosService.idContrato;
    this.idLocalContrato = this.convocadosService.idLocalContrato;
    this.verificarEtapas();
  }

  private mostrarErroInfoVaga() {
    this.servicoAlertaService.mostrarMensagemErro('Não foi possível carregar informações da vaga.');
  }

  public obterAcoesCustomizadas(): Function {
    return (aba: string) => {
      this.visaoEstudantesSelecionados = aba.toLocaleLowerCase().indexOf('selecionados') >= 0;
      this.visaoEstudantesEncaminhados = aba.toLocaleLowerCase().indexOf('encaminhados') >= 0;
      this.visaoEstudantesContratar = aba.toLocaleLowerCase().indexOf('contratar') >= 0;

      if (this.visaoEstudantesSelecionados && this.gridSelecionados && this.gridSelecionados.mostrarDetalhes) {
        this.gridSelecionados.mostrarDetalhes = false;
      }
      if (this.visaoEstudantesEncaminhados && this.gridEncaminhados && this.gridEncaminhados.mostrarDetalhes) {
        this.gridEncaminhados.mostrarDetalhes = false;
      }
      if (this.visaoEstudantesContratar &&
        this.gridContratar &&
        this.gridContratar.listagemMultiVisao &&
        this.gridContratar.listagemMultiVisao.visaoAtiva.value === 'DETALHE') {
        this.gridContratar.listagemMultiVisao.visaoAtiva.next('LISTA');
      }
    };
  }

  private obterPermissoes(): void {
    this.perfilEmpresa = this.permissionService.temPermissao('vag_emp');
    this.perfilBackOffice = this.permissionService.temPermissao('vag_bo');
    this.perfilBackOfficePCD = this.permissionService.temPermissao('vag_bo_pcd');
  }

  atualizarEstadosContratacao(idEtapa: string | number): void {
    if (this.gridEncaminhados && this.carroselEtapas && idEtapa) {
      if (this.idEtapa) {
        this.gridEncaminhados.buscarEstudantesPorEtapa(this.idEtapa);
      } else if (this.apenasEstudantesReprovados) {
        this.gridEncaminhados.buscarEstudantesReprovados();
      } else {
        this.gridEncaminhados.buscarTodosEstudantesDaVaga();
      }
      this.carroselEtapas.carregarEtapas(false);
    }
    if (idEtapa && isNaN(Number(idEtapa))) {
      this.gridContratar.obterListaCandidatosContratar(this.convocadosService.paginacaoCanditosContratar);
    }
  }

  carregarGridPorEtapa(idEtapa: number): void {
    this.idEtapa = idEtapa;
    this.apenasEstudantesReprovados = false;
    this.resetarPaginacaoGridEncaminhados();
    this.gridEncaminhados.buscarEstudantesPorEtapa(this.idEtapa);
  }

  carregarGridReprovados(selecionarReprovados: boolean): void {
    this.idEtapa = null;
    this.apenasEstudantesReprovados = selecionarReprovados;
    this.resetarPaginacaoGridEncaminhados();
    this.gridEncaminhados.buscarEstudantesReprovados();
  }

  carregarGridTodos(selecionarTodos: boolean): void {
    this.idEtapa = null;
    this.apenasEstudantesReprovados = !selecionarTodos;
    this.resetarPaginacaoGridEncaminhados();
    this.gridEncaminhados.pagina = new Page({ size: 10, skip: 0 });
    this.gridEncaminhados.buscarTodosEstudantesDaVaga();
  }

  get abas(): { nome: string, router: string, ativo: boolean }[] {

    let candidatosSelecionados = '-';
    if (this.gridSelecionados && !this.gridSelecionados.carregandoGrid) {
      candidatosSelecionados = this.convocadosService.paginacaoCanditosSelecionados
        ? String(this.convocadosService.paginacaoCanditosSelecionados.totalElements)
        : '-';
    }

    let candidatosEncaminhados = '-';
    if (this.gridEncaminhados && !this.gridEncaminhados.carregando) {
      candidatosEncaminhados = this.carroselEtapas
        ? String(this.carroselEtapas.todosConvocados)
        : '-';
    }

    let candidatosAContratar = '-';
    if (this.gridContratar && !this.gridContratar.carregandoCandidatosContratar) {
      candidatosAContratar = this.convocadosService.paginacaoCanditosContratar
        ? String(this.convocadosService.paginacaoCanditosContratar.totalElements)
        : '-';
    }

    const abas = [];

    const textoSelecionados = this.larguraInterna >= 992 ? ' Estudantes dentro do perfil' : ' Selecionados';
    const textoEncaminhados = this.larguraInterna >= 992 ? ' Estudantes encaminhados nas etapas' : ' Encaminhados';
    const textoContratar = this.larguraInterna >= 992 ? ' Estudantes a contratar' : ' Contratar';

    abas.push({
      nome: `(${candidatosSelecionados})` + textoSelecionados,
      router: '#',
      ativo: this.visaoEstudantesSelecionados
    });

    abas.push({
      nome: `(${candidatosEncaminhados})` + textoEncaminhados,
      router: '#',
      ativo: this.visaoEstudantesEncaminhados
    });

    abas.push({
      nome: `(${candidatosAContratar})` + textoContratar,
      router: '#',
      ativo: this.visaoEstudantesContratar
    });

    return abas;
  }

  buscarMaisEstudantes(): void {
    this.listagemSelecionados.buscarMaisEstudanteSeNaoHouverBloqueios();
  }

  atualizarCabecalhoTriagem(): void {
    this.cabecalhoConvocados.atualizarTriagem();
  }

  private definirFluxo(): void {
    const possuiRastramento = this.gravadorFiltrosService.idRastreamentoExistente();
    const rotaCopiaVaga = this.activatedRoute.snapshot.routeConfig.path.includes('existente');

    this.fluxoBuscaCandidatos = possuiRastramento && !rotaCopiaVaga;
    this.fluxoCopiaVaga = !possuiRastramento && rotaCopiaVaga;
    this.fluxoVagaInicial = !possuiRastramento && !rotaCopiaVaga;
  }

  // Reseta a página para que os grid das listagens das etapas/todos/reprovados não se misturem quando o usuário trocar de listagem.
  private resetarPaginacaoGridEncaminhados(): void {
    this.convocadosService.paginacaoCanditosEncaminhados = new Page({ size: 10, skip: 0 });
    this.gridEncaminhados.pagina = new Page({ size: 10, skip: 0 });
    this.gridEncaminhados.mostrarDetalhes = false;
  }

  // Verifica se foi feita uma edição na vaga e os vínculos dos estudantes ainda estão sendo validados
  private verificarVinculosValidos(): void {
    this.carregandoVinculoValido = true;
    this.sub.sink = this.vinculosValidosService.verificarVinculoValido(this.codigoVaga)
      .finally(() => this.carregandoVinculoValido = false)
      .repeatWhen(finalizado => finalizado.delay(3000))
      .takeUntil(this.processamentoFinalizado$)
      .subscribe(
        resposta => {
          this.vinculoValido = resposta.validando;
          if (resposta && !resposta.validando) {
            this.processamentoFinalizado$.next(true);
          }
        },
        erro => this.servicoAlertaService.mostrarMensagemErro(erro)
      );
  }

  public atualizarCabecalho() {
    this.verificarEtapas();
    this.cabecalhoConvocados.obterDetalhesVaga();
    this.gridSelecionados.verificarEtapas();
  }

  private verificarEtapas() {
    if (this.codigoVaga && this.convocadosService.tipoVaga) {
      this.sub.sink = this.etapaConfiguracaoService.listar({ codigoVaga: this.codigoVaga })
        .subscribe(
          resultado => {
            if (!resultado || resultado.length < 1) {
              this.etapasConcluidas = false;
            } else {
              this.etapasConcluidas = true;
            }
          },
          err => this.servicoAlertaService.mostrarMensagemErro(err)
        );
    }
  }

  alteraCabecalhoParaContratoLocal(): void {
    this.exibeCabecalhoConvocados = false;
  }

  alteraCabecalhoParaConvocados(): void {
    this.exibeCabecalhoConvocados = true;
  }



}
