import { BaseComponent } from 'app/shared/components/base-component/baseFormulario.component';
import { Component, OnInit, Input, Output, EventEmitter, ViewChild, SimpleChanges, OnChanges, OnDestroy } from '@angular/core';
import { CompanyContractPlace } from 'app/core/ciee-company/company-contract-place/company-contract-place.model';
import { CompanyContractPlaceService } from 'app/core/ciee-company/company-contract-place/company-contract-place.service';
import {
  COMPANY_CONTRACT_PLACE_CEI_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_COMPANY_NAME_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_MUNICIPAL_INSCRIPTION_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_SITE_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_STATE_INSCRIPTION_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_TRADING_NAME_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_COUNCIL_NUMBER_MAXLENGTH,
  CompanyContractPlaceFormBuilder,
  COMPANY_CONTRACT_PLACE_CAEPF_NUMBER_MAXLENGTH,
  COMPANY_CONTRACT_PLACE_CNO_NUMBER_MAXLENGTH,
} from 'app/admin/company-contract/company-contract-place/company-contract-place-crud-box/company-contract-place.form-builder';
import { CompanyContract } from 'app/core/ciee-company/company-contract/company-contract.model';
import { RadioButtonsOption } from 'app/ui/formulario/radio-buttons/radio-buttons.component';
import { CompanyPersonCnoCaepf, CompanyPersonType } from 'app/core/ciee-company/company/company.model';
import { CompanyContractSettingsService } from 'app/core/ciee-company/company-contract-settings/company-contract-settings.service';
import { CompanyContractSettings } from 'app/core/ciee-company/company-contract-settings/company-contract-settings.model';
import { Page } from 'app/core/page.model';
import { ContributionApprenticeshipService } from 'app/core/ciee-company/contribution-apprenticeship/contribution-apprenticeship.service';
import { ContributionInternshipService } from 'app/core/ciee-company/contribution-internship/contribution-internship.service';
import { PermissionService } from 'app/core/ciee-permission/permission.service';
import { Subscription } from 'rxjs/Subscription';
import { ProcuradorDadosParticipantes } from 'app/core/ciee-company/dados-participante/procurador-dados-participante.service';
import { DadosParticipante } from 'app/core/ciee-company/dados-participante/participanteContrato.model';
import { ActivityCiee } from 'app/core/ciee-company/activity-ciee/activity-ciee.model';
import { ActivityCieeSelectorComponent } from 'app/shared/components/activity-ciee-selector/activity-ciee-selector.component';
import { BooleanRadioButtonsComponent } from 'app/ui/formulario/boolean-radio-buttons/boolean-radio-buttons.component';
import { ClassCouncilSelectorComponent } from 'app/shared/components/class-council-selector/class-council-selector.component';
import { DatepickerComponent } from 'app/shared/components/datepicker/datepicker.component';
import { moment } from 'ngx-bootstrap/chronos/test/chain';
import { CompanyTypeSelectorComponent } from 'app/shared/components/company-type-selector/company-type-selector.component';
import { CompanyContractPlaceSerializer } from 'app/core/ciee-company/company-contract-place/company-contract-place.serializer';
import { AbstractControl, FormControl, FormGroup, Validators } from '@angular/forms';
import { ServicoAlertaService } from 'app/core/ciee-notification/servico-alerta.service';
import { FormUtilsService } from 'app/core/utils/form-utils.service';
import { NavigateService } from 'app/core/navigate.service';
import { ConfiguracaoCobrancaService } from 'app/core/ciee-admin/configuracao-cobranca/configuracao-cobranca.service';
import { CartaoConfiguracaoCobranca } from 'app/core/ciee-admin/configuracao-cobranca/cartao-configuracao-cobranca.model';
import { GridDataResult, SelectableSettings } from '@progress/kendo-angular-grid';
import { BreakpointMedia } from 'app/core/utils/grid/breakpoint-media';
import { BsModalService } from 'ngx-bootstrap/modal/bs-modal.service';
import { MODAL_DEFAULT_CONFIG, UtilsService } from 'app/core/utils/utils.service';
import { ModalMensagemComponent } from 'app/ui/modal-mensagem/modal-mensagem/modal-mensagem.component';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';
import { ConfiguracaoTicketService } from 'app/core/ciee-admin/configuracao-ticket/configuracao-ticket.service';
import { UnidadesAdministradorasService } from 'app/core/ciee-admin/unidades-administradoras/unidades-administradoras.service';
import { EnumPurposeTypeCode } from 'app/core/ciee-company/cabecalho-contrato-empresa/cabecalho-contrato-empresa.model';
import { ContratosUnificadoresCobrancasService } from 'app/core/ciee-admin/configuracao-cobranca/contratos-unificadores-cobrancas-service';
import { AppValidators } from 'app/core/app-validators.model';
import { SingleSelectOption } from 'app/ui/selects/single-select/single-select.component';
import { DadosLocalDTO } from 'app/core/ciee-company/company-contract-place/dados-local-dto.model';
import { CompanyPorteSelectorComponent } from 'app/shared/components/company-porte-selector/company-porte-selector.component';
import { catchError } from 'rxjs/operators/catchError';
import { of } from 'rxjs/observable/of';
import { CarteiraService } from 'app/core/ciee-admin/acompanhamento-vagas/carteira/carteira.service';
import { Carteira } from 'app/core/ciee-unit/instituicao-ensino-campus/instituicao-ensino-campus.services';
import { T } from '@angular/core/src/render3';

const ID_UNIDADE_CIEE_SP = '101';
const ID_UNIDADE_CIEE_BRASILIA = '201';

interface PersonTypeOption extends RadioButtonsOption {
  value: CompanyPersonType;
}

interface PersonCnoCaepfOption extends RadioButtonsOption {
  value: CompanyPersonCnoCaepf;
}
// tslint:disable-next-line:interface-over-type-literal
type Controls = { [key: string]: AbstractControl }

@Component({
  selector: 'app-dados-local-contrato',
  templateUrl: './dados-local-contrato.component.html',
  styleUrls: ['./dados-local-contrato.component.scss']
})
export class DadosLocalContratoComponent extends BaseComponent implements OnInit, OnChanges, OnDestroy {

  readonly registerValidityEndDate = moment().add(100, 'years').toDate();

  @Input() contract: CompanyContract;
  @Input() model: CompanyContractPlace;

  @Output() save = new EventEmitter<CompanyContractPlace>();
  @Output() recarregarDados = new EventEmitter();

  @ViewChild('selectorActivityCiee') selectorActivityCiee: ActivityCieeSelectorComponent;
  @ViewChild('conselhoClasseAtivo') conselhoClasseAtivo: BooleanRadioButtonsComponent;
  @ViewChild('selectorConselhoClasse') selectorConselhoClasse: ClassCouncilSelectorComponent;
  @ViewChild('selectorSegmentoEmpresa') selectorSegmentoEmpresa: CompanyTypeSelectorComponent;
  @ViewChild('datePickerDataValidade') datePickerDataValidade: DatepickerComponent;
  @ViewChild('datePickerDataNascimento') datePickerDataNascimento: DatepickerComponent;
  @ViewChild('selectorPorteEmpresa') selectorPorteEmpresa: CompanyPorteSelectorComponent;

  editMode = true;
  public modoFormulario: 'cadastro' | 'edicao-bloco';
  public editando = false;
  public erroEmCarregamento = false;
  form: FormGroup;
  salvando = false;
  contributionValue: number;

  public contratoUnificado: (boolean) = false;

  readonly ceiMaxlength = COMPANY_CONTRACT_PLACE_CEI_MAXLENGTH;
  readonly companyNameMaxlength = COMPANY_CONTRACT_PLACE_COMPANY_NAME_MAXLENGTH;
  readonly municipalInscriptionMaxlength = COMPANY_CONTRACT_PLACE_MUNICIPAL_INSCRIPTION_MAXLENGTH;
  readonly nameMaxlength = COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH;
  readonly siteMaxlength = COMPANY_CONTRACT_PLACE_SITE_MAXLENGTH;
  readonly stateInscriptionMaxlength = COMPANY_CONTRACT_PLACE_STATE_INSCRIPTION_MAXLENGTH;
  readonly tradingNameMaxlength = COMPANY_CONTRACT_PLACE_TRADING_NAME_MAXLENGTH;
  readonly councilNumberMaxlength = COMPANY_CONTRACT_PLACE_COUNCIL_NUMBER_MAXLENGTH;
  readonly porteNumberMaxlength = COMPANY_CONTRACT_PLACE_COUNCIL_NUMBER_MAXLENGTH;

  readonly caepfNumberMaxlength = COMPANY_CONTRACT_PLACE_CAEPF_NUMBER_MAXLENGTH;
  readonly cnoNumberMaxlength = COMPANY_CONTRACT_PLACE_CNO_NUMBER_MAXLENGTH;
  readonly descricaoMaxlength = COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH;


  readonly companyTypeOptions: PersonTypeOption[] = [
    { label: 'CNPJ', value: 'LEGAL_ENTITY' },
    { label: 'CPF', value: 'INDEPENDENT_PROFESSIONAL' },
  ];

  private readonly patchParams: string[] = [
    'activity', 'amountCi', 'companyType', 'companyPorte', 'contract', 'contractId',
    'id', 'isContractAdmin', 'isDifferentiatedCi', 'municipalInscription',
    'site', 'state', 'stateInscription', 'freeStateInscription', 'birthDate', 'cei', 'cpf', 'name',
    'cnpj', 'companyName', 'tradingName', 'descricaoLocal', 'companyPersonType', 'status',
    'isClassCouncilActive', 'classCouncil', 'councilNumber',
    'registerValidity', 'idConfiguracaoCobranca', 'jovemTalento', 'cno', 'caepf', 'carteiraConsultor'
  ];

  readonly documentoCnoCaepfOptions: PersonCnoCaepfOption[] = [
    { label: 'CAEPF', value: 'CAEPF' },
    { label: 'CNO', value: 'CNO' },
  ];

  private settings: CompanyContractSettings;
  private readonly page = new Page();
  private companyPersonTypeSubscription: Subscription;
  private isDifferentiatedCiSubscription: Subscription;
  private allowDifferentiatedCi: boolean;
  private alteracaoJovemTalento: boolean;
  private companyContractPlaceSerializer: CompanyContractPlaceSerializer;

  showCaepfInput = true;
  showCnoInput = false;
  escolhaCaepfCno: any;
  carteiraOpcoes: any = [];

  private configuracaoCobranca: CartaoConfiguracaoCobranca;
  private configuracaoPadrao: CartaoConfiguracaoCobranca;
  dadosGrid: GridDataResult = { data: [], total: 0 };
  pagina: Page = new Page({ size: 10, skip: 0 });
  carregandoConfiguracoes = false;
  carregandoCheckbox = false;
  selecionavel: SelectableSettings = {
    enabled: true,
    checkboxOnly: true,
    mode: 'single'
  };
  localSelecionado = [];
  localResponsavel = false;
  public BreakpointMedia = BreakpointMedia;
  private modalMensagem: BsModalRef;
  constructor(
    private companyContractPlaceService: CompanyContractPlaceService,
    private formBuilder: CompanyContractPlaceFormBuilder,
    private formUtilsService: FormUtilsService,
    private companyContractSettingsService: CompanyContractSettingsService,
    private contributionApprenticeshipService: ContributionApprenticeshipService,
    private contributionInternshipService: ContributionInternshipService,
    private permissionService: PermissionService,
    private procuradorDadosParticipantes: ProcuradorDadosParticipantes,
    private servicoAlertaService: ServicoAlertaService,
    private navigateService: NavigateService,
    private configuracaoCobrancaService: ConfiguracaoCobrancaService,
    private configuracaoTicketService: ConfiguracaoTicketService,
    private modalService: BsModalService,
    private unidadeService: UnidadesAdministradorasService,
    private contratosUnificadoresCobrancasService: ContratosUnificadoresCobrancasService,
    private utilsService: UtilsService,
    private carteiraService: CarteiraService,
  ) {
    super()
    this.companyContractPlaceSerializer = new CompanyContractPlaceSerializer();
  }

  ngOnInit(): void {

    this.alteracaoJovemTalento = this.permissionService.temPermissao('alt_contr_jov_tal');
    this.allowDifferentiatedCi = this.permissionService.temPermissao('aut_cidif_locco');
    this.buildForm();
    this.verificarContratoUnificado();
  }

  verificarContratoUnificado() {
    this.sub.sink = this.contratosUnificadoresCobrancasService.verificarConfiguracaoCobrancaUnificada(this.model.contractId).subscribe(retorno => {
      this.contratoUnificado = retorno;
    }, erro => {
      this.servicoAlertaService.mostrarMensagemErro(this.utilsService.parseErrorMessage(erro));
    });
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.contract || changes.model) { this.fetchData(); }
    if (changes.model) {
      this.buildForm();
      this.model = new CompanyContractPlace({...changes.model.currentValue})
      if (this.model && this.model.id) {
        this.modoFormulario = 'edicao-bloco';
        this.editando = false;
      } else {
        this.modoFormulario = 'cadastro';
      }
    }
  }

  carregarConfiguracoes() {
    if (this.contract) {
      this.sub.sink = this.configuracaoCobrancaService
        .obterConfiguracaoPadrao(
          this.contract.id,
          (error) => {
            this.form.get('configuracaoPadrao').setValue(false);
            if (error.status !== 404) {
              this.servicoAlertaService.mostrarMensagemErro(error);
            }
          }
        )
        .finally(() => {
          this.pagina.size = 10;
          this.pagina = this.pagina.definirPagina(0, this.pagina.size, this.pagina);
          this.carregarGrid();
        })
        .subscribe(configuracaoPadrao => {
          this.configuracaoPadrao = configuracaoPadrao;
          this.form.get('configuracaoPadrao').setValue(true);
        });
    }
  }

  mudarPaginaGrid(pagina: Page) {
    this.pagina = pagina;
    this.carregarGrid();
  }

  private carregarGrid() {
    if (this.contract && this.contract.id) {
      this.carregandoConfiguracoes = true;
      this.sub.sink = this.configuracaoCobrancaService
        .listarConfiguracoesCobranca(this.contract.id, this.pagina, {})
        .finally(() => {
          this.carregandoConfiguracoes = false;
          if (!this.dadosGrid['data'] && !this.configuracaoPadrao) {
            this.servicoAlertaService.mostrarMensagemAlerta(
              'Não existe configuração de cobrança para o contrato, favor entrar em contato com o setor financeiro.'
            );
          }
        })
        .subscribe(
          pagedData => {
            if (pagedData && pagedData.data && pagedData.page) {
              this.dadosGrid = {
                data: pagedData.data,
                total: pagedData.page.totalElements
              };
            } else {
              this.dadosGrid = { data: [], total: 0 };
            }
          },
          err => {
            this.dadosGrid = { data: [], total: 0 };
            this.servicoAlertaService.mostrarMensagemErro(err);
          }
        );
    }
  }

  selecionarConfiguracaoCobranca(event: any) {
    if (event && event.selectedRows && event.selectedRows.length) {
      const configuracaoCobranca = event.selectedRows[0].dataItem;
      this.form.get('idConfiguracaoCobranca').setValue(configuracaoCobranca.id);
      this.localSelecionado = [configuracaoCobranca.id];
    }
  }

  get isNew(): boolean {
    return !this.model || this.model.id === undefined;
  }

  fetchData(): void {
    if (!this.contract || !this.model) { return; }

    this.carregarConfiguracoes();
    this.fetchSettings();
  }

  get defineCEIObrigatorio(): String {
    let tokenRequired = '';
    if (this.contract.serviceType === EnumPurposeTypeCode.APPRENTICESHIP) {
      tokenRequired = '*';
    }
    return `CEI ${tokenRequired}`;
  }

  labelObrigatorio(text: string): String {
    let tokenRequired = '';
    if (this.contract.serviceType === EnumPurposeTypeCode.INTERNSHIP) {
      tokenRequired = '*';
    }
    return `${text} ${tokenRequired}`;
  }

  ngOnDestroy(): void {
    if (this.companyPersonTypeSubscription) {
      this.companyPersonTypeSubscription.unsubscribe();
    }
    if (this.isDifferentiatedCiSubscription) {
      this.isDifferentiatedCiSubscription.unsubscribe();
    }
    super.ngOnDestroy()
  }

  onCancel(): void {
    this.buildForm();
  }

  onConfirm(): void {
    if (this.salvando) { return; }

    if (this.form.value.configuracaoPadrao && !this.form.value.idConfiguracaoCobranca &&
      this.configuracaoPadrao && this.configuracaoPadrao.id) {
      this.form.get('idConfiguracaoCobranca').setValue(this.configuracaoPadrao.id);
    } else if (this.form.value.configuracaoPadrao && (!this.configuracaoPadrao || !this.configuracaoPadrao.id) && !this.contratoUnificado) {
      this.servicoAlertaService.mostrarMensagemAlerta('Esse contrato não possui configuração padrão.');
      this.form.get('configuracaoPadrao').setValue(false);
      return;
    }

    if (this.form.invalid) {
      this.servicoAlertaService.mostrarMensagemFormInvalido();
      this.formUtilsService.touchAllControls(this.form);
      return;
    }

    this.salvando = true;

    const model = this.formBuilder.toModel(this.form);

    const isDifferentiatedCi = model.isDifferentiatedCi;
    if (!isDifferentiatedCi) {
      model.amountCi = null;
    }
    const contractId = this.contract && this.contract.id;
    { model['contract'] = { id: contractId }; }
    model.activity = model.activity && model.activity.description ? model.activity : null;
    model.companyType = model.companyType ? model.companyType : null;

    model.contractId = contractId;
    const promise = model.id
      ? this.companyContractPlaceService.atualizarParcial(model.id, model, this.patchParams)
      : this.companyContractPlaceService.criarComRetorno(model);

    promise.toPromise()
      .then(
        updatedModel => {
          const modalSalvar = this.companyContractPlaceSerializer.fromJSON(updatedModel);
          this.servicoAlertaService.mostrarMensagemSucesso('Dados salvos com sucesso.');
          this.mostrarMensagemAlteracaoJovemTalento(model, this.model);
          if (modalSalvar && modalSalvar.id && this.modoFormulario === 'cadastro') {
            this.mensagemAvisoConfiguracaoTicket();
            this.mensagemAvisoInscricoesNecessarias(model);
            this.navigateService.navigateTo([this.navigateService.rotaAtual.replace('novo', modalSalvar.id + '/visualizar')]);
          } else {
            this.save.emit(modalSalvar);
            this.editando = false;
          }
        },
        err => this.servicoAlertaService.mostrarMensagemErro(err)
      )
      .then(() => { this.salvando = false; });
  }

  private mensagemAvisoConfiguracaoTicket() {
    this.sub.sink = this.configuracaoTicketService.obter({ idContrato: this.contract.id })
      .subscribe(config => {
        if (config.temLimiteTicket) {
          this.modalMensagem = this.modalService.show(ModalMensagemComponent, {
            class: 'modal-centralizado',
            ...MODAL_DEFAULT_CONFIG,
            initialState: {
              texto: 'O novo local de contrato necessita ter tickets (posições) parametrizados, por favor acesse o item "Gerenciar Limite Tickets".',
              icone: 'ciee-alert-circle',
              fecharModal: () => {
                this.modalMensagem.hide();
              },
            },
          });
        }
      });
  }

  procuraDadosParticipante(documento: string): void {
    if (this.isNew && documento) {
      this.sub.sink = this.procuradorDadosParticipantes.procuraDados(documento, this.contract.id)
        .subscribe(dados => this.preencheCampos(dados));

        let cnpjComplementoSemMascara = this.form.get('cnpjComplement').value;
        if (!cnpjComplementoSemMascara) {
          return;
        }
        cnpjComplementoSemMascara = cnpjComplementoSemMascara.replace('-','').replace(' ','');
        if (cnpjComplementoSemMascara.length === 6) {
          this.validarCnpjLocal(documento, cnpjComplementoSemMascara)
        }
    }
  }

  private buildForm(): void {
    this.form = this.model && this.contract
      ? this.formBuilder.build(this.model, {
        contract: this.contract,
        disableCi: !this.allowDifferentiatedCi
      })
      : this.formBuilder.build(new CompanyContractPlace(), {
        contract: new CompanyContract(),
        disableCi: !this.allowDifferentiatedCi
      });

      this.form.addControl('cnoCaepf',new FormControl());

      if (this.model.cno || this.model.caepf) {
        if (!!this.model.cno) {
          this.showCnoInput = true;
          this.showCaepfInput = false;
          this.form.get("cnoCaepf").setValue('CNO');
        }
        if (!!this.model.caepf) {
          this.showCnoInput = false;
          this.showCaepfInput = true;
          this.form.get("cnoCaepf").setValue('CAEPF');
        }
      }

    if (!this.form) { return; }

    if(this.isNew && this.contract && this.contract.companiesContractInfo){
      if(!!this.contract.companiesContractInfo.caepf){
        this.showCnoInput = false;
        this.showCaepfInput = true;
        this.form.get("cnoCaepf").setValue('CAEPF');
        this.form.get("caepf").setValue(this.contract.companiesContractInfo.caepf);
      }
      if(!!this.contract.companiesContractInfo.cno){
        this.showCnoInput = true;
        this.showCaepfInput = false;
        this.form.get("cnoCaepf").setValue('CNO');
        this.form.get("cno").setValue(this.contract.companiesContractInfo.cno);
      }
    }

    this.onChangeIsDifferentiatedCi();
    this.onChangeCompanyPersonType();
    if(this.model.carteiraConsultor){
      this.buscarCarteiras(this.model.carteiraConsultor);
    } else{
      this.buscarCarteiras();
    }
    if (this.model && this.model.id && this.contract) {
      this.sub.sink = this.configuracaoCobrancaService.buscarConfiguracaoCobrancaPorLocalContrato(
        this.contract.id,
        this.model.id
      ).subscribe(
        configuracaoCobranca => {
          this.configuracaoCobranca = <CartaoConfiguracaoCobranca>configuracaoCobranca;
          if (configuracaoCobranca) {
            if (
              this.configuracaoCobranca.localContratoResponsavel &&
              this.model.id === this.configuracaoCobranca.localContratoResponsavel.id
            ) {
              this.localResponsavel = true;
            }

            this.localSelecionado = [configuracaoCobranca.id];
            this.form.get('idConfiguracaoCobranca').setValue(configuracaoCobranca.id);
            this.form.get('configuracaoPadrao').setValue(configuracaoCobranca.padrao, { emitEvent: false });
          } else if (this.model.idConfiguracaoCobranca) {
            this.sub.sink = this.configuracaoCobrancaService.buscarConfiguracaoCobrancaPorId(
              this.contract.id, this.model.idConfiguracaoCobranca
            ).subscribe(
              configuracaoCobrancaRedis => {
                this.configuracaoCobranca = <CartaoConfiguracaoCobranca>configuracaoCobrancaRedis;
                if (configuracaoCobrancaRedis) {
                  this.localSelecionado = [configuracaoCobrancaRedis.id];
                  this.form.get('idConfiguracaoCobranca').setValue(configuracaoCobrancaRedis.id);
                  this.form.get('configuracaoPadrao').setValue(configuracaoCobrancaRedis.padrao, { emitEvent: false });
                } else if (!this.configuracaoPadrao) {
                  this.form.get('configuracaoPadrao').setValue(false);
                }
              },
              err => this.servicoAlertaService.mostrarMensagemErro(err)
            );
          } else if (!this.configuracaoPadrao) {
            this.form.get('configuracaoPadrao').setValue(false);
          }
        },
        err => this.servicoAlertaService.mostrarMensagemErro(err)
      )
    }

    this.sub.sink = this.form.get('configuracaoPadrao').valueChanges.subscribe(v => {
      if (v && this.configuracaoPadrao) {
        this.form.get('idConfiguracaoCobranca').setValue(this.configuracaoPadrao.id);
      } else if (v && !this.configuracaoPadrao) {
        this.servicoAlertaService.mostrarMensagemAlerta(
          'Esse contrato não possui uma configuração padrão. Se necessário, entrar em contato com o financeiro.'
        );
        this.form.get('configuracaoPadrao').setValue(false);
      } else {
        this.form.get('idConfiguracaoCobranca').reset();
      }
    });

    if (this.settings && this.alteracaoJovemTalento && (this.settings.documentType === 'PROG_JOV_TALENTO' || this.settings.jovemTalento)) {
      this.form.get('jovemTalento').enable({ emitEvent: false });
      if (!this.model || !this.model.id) {
        this.form.get('jovemTalento').setValue(true, { emitEvent: false });
      }
    }
  }

  onChangeIsDifferentiatedCi(): void {
    const {
      isDifferentiatedCi,
      amountCi,
    } = this.form.controls;

    if (this.isDifferentiatedCiSubscription) {
      this.isDifferentiatedCiSubscription.unsubscribe();
    }

    this.isDifferentiatedCiSubscription = isDifferentiatedCi.valueChanges
      .subscribe((v: boolean) => {
        const newAmountCi = v ? this.contributionValue : null;
        amountCi.setValue(newAmountCi);
      });
  }

  validarPermissaoJovemTalento(mostrarAlerta: boolean): void {
    if (this.settings && (this.settings.documentType === 'PROG_JOV_TALENTO' || this.settings.jovemTalento) && !this.alteracaoJovemTalento && mostrarAlerta) {
      this.servicoAlertaService.mostrarMensagemAlerta('Esta alteração necessita de permissao especifica para realização');
    }
  }

  private onChangeCompanyPersonType(): void {
    const {
      companyPersonType,
    } = this.form.controls;

    if (this.companyPersonTypeSubscription) {
      this.companyPersonTypeSubscription.unsubscribe();
    }

    this.companyPersonTypeSubscription = companyPersonType.valueChanges
      .subscribe((v: CompanyPersonType) => {
        if (v === 'LEGAL_ENTITY') {
          this.setFieldsForLegalEntity(this.form.controls);
        } else {
          this.setFieldsForIndependentProfessional(this.form.controls);
        }

        this.form.markAsPristine();
        this.form.markAsUntouched();
        this.form.updateValueAndValidity();
      });
  }

  private setFieldsForIndependentProfessional({
    cnpjBase,
    cnpjComplement,
    companyName,
    tradingName,
    descricaoLocal,
    cpf,
    cei,
    birthDate,
    name,
    isClassCouncilActive,
    classCouncil,
    councilNumber,
    registerValidity,
    cno,
    caepf,
    carteiraConsultor,
  }: Controls) {
    if (cnpjBase.enabled) {
      cnpjBase.setValue('');
      cnpjBase.disable();
    }
    if (cnpjComplement.enabled) {
      cnpjComplement.setValue('');
      cnpjComplement.disable();
    }
    if (companyName.enabled) {
      companyName.setValue('');
      companyName.disable();
    }
    if (tradingName.enabled) {
      tradingName.setValue('');
      tradingName.disable();
    }
    if (descricaoLocal.enabled) {
      descricaoLocal.setValue('');
      descricaoLocal.disable();
    }
    if (cpf.disabled) {
      cpf.enable();
    }
    if (cei.disabled) {
      cei.enable();
    }
    if (birthDate.disabled) {
      birthDate.enable();
    }
    if (name.disabled) {
      name.enable();
    }
    if (isClassCouncilActive.disabled) {
      isClassCouncilActive.enable();
    }
    if (classCouncil.disabled) {
      classCouncil.enable();
    }
    if (councilNumber.disabled) {
      councilNumber.enable();
    }
    if (registerValidity.disabled) {
      registerValidity.enable();
    }
    if (cno.disabled) {
      cno.enable();
    }
    if (caepf.disabled) {
      caepf.enable();
    }
    if (carteiraConsultor.disable){
      carteiraConsultor.enable();
      carteiraConsultor.setValue(null);
    }

  }

  private setFieldsForLegalEntity({
    cpf,
    cei,
    birthDate,
    name,
    cnpjBase,
    cnpjComplement,
    companyName,
    tradingName,
    descricaoLocal,
    isClassCouncilActive,
    classCouncil,
    councilNumber,
    registerValidity,
    cno,
    caepf,
    carteiraConsultor,
  }: Controls) {
    if (cpf.enabled) {
      cpf.setValue('');
      cpf.disable();
    }
    if (cei.enabled) {
      cei.setValue('');
      cei.disable();
    }
    if (birthDate.enabled) {
      birthDate.setValue(null);
      birthDate.disable();
    }
    if (name.enabled) {
      name.setValue('');
      name.disable();
    }
    if (isClassCouncilActive.enabled) {
      isClassCouncilActive.setValue(null);
      isClassCouncilActive.disable();
    }
    if (classCouncil.enabled) {
      classCouncil.setValue(null);
      classCouncil.disable();
    }
    if (councilNumber.enabled) {
      councilNumber.setValue('');
      councilNumber.disable();
    }
    if (registerValidity.enabled) {
      registerValidity.setValue(null);
      registerValidity.disable();
    }
    if (cnpjBase.disabled) {
      cnpjBase.enable();
    }
    if (cnpjComplement.disabled) {
      cnpjComplement.enable();
    }
    if (companyName.disabled) {
      companyName.enable();
    }
    if (tradingName.disabled) {
      tradingName.enable();
    }
    if (descricaoLocal.disabled) {
      descricaoLocal.enable();
    }
    if (cno.disabled) {
      cno.setValue('');
      cno.enable();
    }
    if (caepf.disabled) {
      caepf.setValue('');
      caepf.enable();
    }
    if (carteiraConsultor.disable){
      carteiraConsultor.enable();
    }
  }

  private fetchContributionValue() {
    this.contributionValue = null;

    const contractInfo = this.contract.companiesContractInfo;
    const contractAddress = contractInfo.addresses[0];

    if (!contractAddress || !this.settings) { return; }

    const { zipCode } = contractAddress.address;
    const { centralizedFinancialManagement, cieeUnitId } = this.settings;

    switch (this.contract.serviceType) {
      case EnumPurposeTypeCode.APPRENTICESHIP: {
        const actuationTypeId = this.contract.contractingMethod.id;
        const { apprenticeshipProgramType } = this.contract;
        const programTypeId = (
          apprenticeshipProgramType &&
          apprenticeshipProgramType.id
        );

        return this.sub.sink =  this.contributionApprenticeshipService.searchOne(this.page, {
          actuationTypeId,
          centralizedFinancialManagement,
          cieeUnitId,
          programTypeId,
          zipCode,
        }).subscribe(
          pagedData => {
            const model = pagedData.data[0];
            if (!model) { return; }
            this.contributionValue = model.maxValue;
          },
          err => this.servicoAlertaService.mostrarMensagemErro(err)
        );
      }

      case EnumPurposeTypeCode.INTERNSHIP: {
        return this.sub.sink =  this.contributionInternshipService.searchOne(this.page, {
          centralizedFinancialManagement,
          cieeUnitId,
          zipCode,
        }).subscribe(
          pagedData => {
            const model = pagedData.data[0];
            if (!model) { return; }
            this.contributionValue = model.minValue;
          },
          err => this.servicoAlertaService.mostrarMensagemErro(err)
        );
      }
    }
  }

  private fetchSettings() {
    this.sub.sink =  this.companyContractSettingsService
      .buscarPorContrato(this.contract.id)
      .subscribe(
        settings => {
          this.settings = settings;
          this.fetchContributionValue();
          this.buildForm();
        },
        err => this.servicoAlertaService.mostrarMensagemErro(err)
      );
  }

  private preencheCampos(dados: DadosParticipante) {
    this.form.controls['name'].setValue(dados.nome);
    if (dados.cnpj) {
      this.preencheDadosPJ(dados);
    } else {
      this.preencheDadosPL(dados);
    }
  }

  private preencheDadosPJ(dados: DadosParticipante) {
    this.selectorActivityCiee.writeValue(new ActivityCiee({ id: dados.codigoAtividade }));
    this.selectorSegmentoEmpresa.writeValue(dados.segmento);
    this.form.controls['cnpj'].setValue(dados.cnpj);
    this.form.controls['tradingName'].setValue(dados.nomeFantasia);
    this.form.controls['companyName'].setValue(dados.razaoSocial);
    this.form.controls['descricaoLocal'].setValue(dados.descricaoLocal);
    this.form.controls['site'].setValue(dados.homePage);
    this.form.controls['carteiraConsultor'].setValue(dados.carteiraConsultor);
  }

  private preencheDadosPL(dados: DadosParticipante) {
    this.form.controls['cpf'].setValue(dados.cpf);
    this.form.controls['cei'].setValue(dados.cei);
    if (dados.dataNascimento) {
      this.datePickerDataNascimento.writeValue(new Date(dados.dataNascimento.toString()));
    }
    if (dados.validade) {
      this.datePickerDataValidade.writeValue(new Date(dados.validade.toString()));
    }
    this.form.controls['companyType'].setValue(dados.segmento);
    if (dados.conselhoClasse) {
      this.conselhoClasseAtivo.writeValue(dados.conselhoClasse.ativo);
      this.selectorConselhoClasse.writeValue(dados.conselhoClasse);
      this.form.controls['councilNumber'].setValue(dados.conselhoClasse.numero);
    }
    this.form.controls['descricaoLocal'].setValue(dados.descricaoLocal);
    this.form.controls['carteiraConsultor'].setValue(dados.carteiraConsultor);
  }

  editandoChange(editando: boolean) {
    this.carregandoCheckbox = true;
    this.editando = editando;

    // Tratamento está sendo utilizado pois o checkbox do kendo, por algum motivo que desconheço
    // não reaparece caso a column comece no ngIf false e a condição fique true sem que a grid "recarregue"
    // Promise.resolve(null) não funcionou
    setTimeout(() => {
      this.carregandoCheckbox = false;
    }, 1);
  }

  private mostrarMensagemAlteracaoJovemTalento(localContratoAlt: CompanyContractPlace, localContratoDB: CompanyContractPlace): void {

    if (localContratoAlt && localContratoDB && localContratoDB.id && localContratoAlt.jovemTalento !== localContratoDB.jovemTalento) {
      this.modalMensagem = this.modalService.show(ModalMensagemComponent, {
        class: 'modal-centralizado',
        ...MODAL_DEFAULT_CONFIG,
        initialState: {
          texto: 'Necessário verificar vagas pendentes e contratações existentes no local. \n Necessário ajustar a CI conforme o valor adequado para o contrato.',
          icone: 'ciee-alert-circle',
          fecharModal: () => {
            this.modalMensagem.hide();
          },
        },
      });
    }
  }

  private mostrarMensagemAlerta(texto: string): void {

    this.modalMensagem = this.modalService.show(ModalMensagemComponent, {
      class: 'modal-centralizado',
      ...MODAL_DEFAULT_CONFIG,
      initialState: {
        texto: texto,
        icone: 'ciee-alert-circle',
        fecharModal: () => {
          this.modalMensagem.hide();
        },
      },
    });
  }

  private mensagemAvisoInscricoesNecessarias(local: CompanyContractPlace) {
    const mensagemInscricaoEstadual = 'Local não possui inscrição estadual informada.';
    const mensagemInscricaoMunicipal = 'Local não possui inscrição municipal informada.';

    this.unidadeService.obter({ idContrato: local.contractId })
      .subscribe(unidade => {
        if (unidade.id && unidade.id.toString() === ID_UNIDADE_CIEE_BRASILIA && !local.stateInscription) {
          this.mostrarMensagemAlerta(mensagemInscricaoEstadual);
          return;
        }

        if (unidade.id && unidade.id.toString() !== ID_UNIDADE_CIEE_SP && !local.municipalInscription) {
          this.mostrarMensagemAlerta(mensagemInscricaoMunicipal);
          return;
        }

      }, error => this.servicoAlertaService.mostrarMensagemErro(error));
  }

  changeCaepfCno(selecionado: SingleSelectOption){
    this.escolhaCaepfCno = selecionado.value;
    if(this.escolhaCaepfCno ==  "CAEPF"){
      this.form.get('cno').setValue('');
      this.showCaepfInput = true;
      this.showCnoInput = false;
      if(this.isNew && this.contract && this.contract.companiesContractInfo){
        if(!!this.contract.companiesContractInfo.caepf){
          this.form.get("caepf").setValue(this.contract.companiesContractInfo.caepf);
        }
      }
    }
    if(this.escolhaCaepfCno ==  "CNO") {
      this.form.get('caepf').setValue('');
      this.showCnoInput = true;
      this.showCaepfInput = false;
      if(this.isNew && this.contract && this.contract.companiesContractInfo){
        if(!!this.contract.companiesContractInfo.cno){
          this.form.get("cno").setValue(this.contract.companiesContractInfo.cno);
        }
      }
    }
  }

  validarComplementoCnpj(complementoCnpj: string) {
    let cnpjBaseSemMascara = this.form.get('cnpjBase').value;
    if (!cnpjBaseSemMascara) {
      return;
    }
    cnpjBaseSemMascara = cnpjBaseSemMascara.match(/\d+/g).join('');
    if (cnpjBaseSemMascara.length === 8) {
      this.validarCnpjLocal(cnpjBaseSemMascara, complementoCnpj)
    }

  }

  validarCnpjLocal(cnpjBase: string, cnpjComplemento: string) {
    const dadosLocalDTO = new DadosLocalDTO({
      cnpj: `${cnpjBase}${cnpjComplemento}`,
      idContrato: this.contract.id
    })
    this.companyContractPlaceService.validarCnpjLocal(dadosLocalDTO).subscribe(retorno => {
      if (retorno) {
        this.mostrarMensagemAlerta('Já existe um local cadastrado com o CNPJ informado!');
      }
    }, erro => {
      this.servicoAlertaService.mostrarMensagemErro(this.utilsService.parseErrorMessage(erro));
    });
  }

  buscarCarteiras(filtro: any = null): void {
    let descricaoCarteira = null;
    let listaCarteira = null;
    if (typeof filtro === 'number') {
      listaCarteira = [];
      listaCarteira.push(filtro);
    } else if (typeof filtro === 'string') {
      descricaoCarteira = filtro;
    }
    if(this.editMode && (listaCarteira !== null || descricaoCarteira)){
    this.carteiraService.listarCarteiras(0, 20, listaCarteira, descricaoCarteira)
      .pipe(
        catchError(error => {
          console.error("Error fetching wallets:", error);
          return of([]);
        })
      )
      .subscribe((wallets: any) => {
        if(wallets && wallets.data){
        this.carteiraOpcoes = wallets.data.map(carteira => {
          const descricaoCarteiraOpcao = carteira.nomeAssistente
          ? `${carteira.id}/${carteira.descricao} - ${carteira.nomeAssistente}`
          : `${carteira.id}/${carteira.descricao}`

          return {
            value: carteira.id,
            label: descricaoCarteiraOpcao
          }
        })};
      });}
      if(!filtro){
        this.carteiraService.listarCarteiras(0,20,null)
        .pipe(
          catchError(error => {
            console.error("Error fetching wallets:", error);
            return of([]);
          })
        )
        .subscribe((wallets: any) => {
          this.carteiraOpcoes = wallets.data.map(carteira => {
            const descricaoCarteiraOpcao = carteira.nomeAssistente
            ? `${carteira.id}/${carteira.descricao} - ${carteira.nomeAssistente}`
            : `${carteira.id}/${carteira.descricao}`

            return {
              value: carteira.id,
              label: descricaoCarteiraOpcao
            }
          });
        });
      }
  }
}
