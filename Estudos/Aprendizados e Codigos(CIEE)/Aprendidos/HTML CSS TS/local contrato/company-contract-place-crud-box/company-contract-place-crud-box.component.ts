import { BaseComponent } from './../../../../shared/components/base-component/baseFormulario.component';

import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges, OnInit, ViewChild } from '@angular/core';
import { FormGroup, AbstractControl } from '@angular/forms';

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
} from 'app/admin/company-contract/company-contract-place/company-contract-place-crud-box/company-contract-place.form-builder';
import { CompanyContract } from 'app/core/ciee-company/company-contract/company-contract.model';
import { UtilsService } from 'app/core/utils/utils.service';
import { RadioButtonsOption } from 'app/ui/formulario/radio-buttons/radio-buttons.component';
import { CompanyPersonType } from 'app/core/ciee-company/company/company.model';
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
import { ServicoAlertaService } from 'app/core/ciee-notification/servico-alerta.service';


interface PersonTypeOption extends RadioButtonsOption {
  value: CompanyPersonType;
}

// tslint:disable-next-line:interface-over-type-literal
type Controls =  { [key: string]: AbstractControl }

@Component({
  selector: 'app-company-contract-place-crud-box',
  templateUrl: './company-contract-place-crud-box.component.html'
})
export class CompanyContractPlaceCrudBoxComponent  extends BaseComponent implements OnInit, OnChanges {
  readonly registerValidityEndDate = moment().add(100, 'years').toDate();

  @Input() contract: CompanyContract;
  @Input() model: CompanyContractPlace;

  @Output() save = new EventEmitter<CompanyContractPlace>();

  @ViewChild('selectorActivityCiee') selectorActivityCiee: ActivityCieeSelectorComponent;
  @ViewChild('conselhoClasseAtivo') conselhoClasseAtivo: BooleanRadioButtonsComponent;
  @ViewChild('selectorConselhoClasse') selectorConselhoClasse: ClassCouncilSelectorComponent;
  @ViewChild('selectorSegmentoEmpresa') selectorSegmentoEmpresa: CompanyTypeSelectorComponent;
  @ViewChild('datePickerDataValidade') datePickerDataValidade: DatepickerComponent;
  @ViewChild('datePickerDataNascimento') datePickerDataNascimento: DatepickerComponent;

  editMode = true;
  errorMessage = '';
  form: FormGroup;
  isSaving = false;
  showErrorMessage = false;
  showSuccessMessage = false;
  contributionValue: number;


  readonly ceiMaxlength = COMPANY_CONTRACT_PLACE_CEI_MAXLENGTH;
  readonly companyNameMaxlength = COMPANY_CONTRACT_PLACE_COMPANY_NAME_MAXLENGTH;
  readonly municipalInscriptionMaxlength = COMPANY_CONTRACT_PLACE_MUNICIPAL_INSCRIPTION_MAXLENGTH;
  readonly nameMaxlength = COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH;
  readonly siteMaxlength = COMPANY_CONTRACT_PLACE_SITE_MAXLENGTH;
  readonly stateInscriptionMaxlength = COMPANY_CONTRACT_PLACE_STATE_INSCRIPTION_MAXLENGTH;
  readonly tradingNameMaxlength = COMPANY_CONTRACT_PLACE_TRADING_NAME_MAXLENGTH;
  readonly councilNumberMaxlength = COMPANY_CONTRACT_PLACE_COUNCIL_NUMBER_MAXLENGTH;

  readonly companyTypeOptions: PersonTypeOption[] = [
    { label: 'CNPJ', value: 'LEGAL_ENTITY' },
    { label: 'CPF', value: 'INDEPENDENT_PROFESSIONAL' },
  ];

  private readonly patchParams: string[] = [
    'activity', 'amountCi', 'companyType', 'contract', 'contractId',
    'id', 'isContractAdmin', 'isDifferentiatedCi', 'municipalInscription',
    'site', 'state', 'stateInscription', 'birthDate', 'cei', 'cpf', 'name',
    'cnpj', 'companyName', 'tradingName', 'companyPersonType',
    'isClassCouncilActive', 'classCouncil', 'councilNumber',
    'registerValidity'
  ];

  private settings: CompanyContractSettings;
  private readonly page = new Page();
  private companyPersonTypeSubscription: Subscription;
  private isDifferentiatedCiSubscription: Subscription;
  private allowDifferentiatedCi: boolean;
  private companyContractPlaceSerializer: CompanyContractPlaceSerializer;

  constructor(
    private companyContractPlaceService: CompanyContractPlaceService,
    private formBuilder: CompanyContractPlaceFormBuilder,
    private utils: UtilsService,
    private companyContractSettingsService: CompanyContractSettingsService,
    private contributionApprenticeshipService: ContributionApprenticeshipService,
    private contributionInternshipService: ContributionInternshipService,
    private permissionService: PermissionService,
    private procuradorDadosParticipantes: ProcuradorDadosParticipantes,
    private servicoAlertaService: ServicoAlertaService,
  ) {
    super()
    this.companyContractPlaceSerializer = new CompanyContractPlaceSerializer();
  }

  ngOnInit(): void {
    this.allowDifferentiatedCi = this.permissionService.temPermissao('aut_cidif_locco');
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.contract || changes.model) { this.fetchData(); }
  }

  get isNew(): boolean {
    return !this.model || this.model.id === undefined;
  }

  fetchData(): void {
    if (!this.contract || !this.model) { return; }

    this.fetchSettings();
  }

  get defineCEIObrigatorio(): String {
    let tokenRequired = '';
    if (this.contract.serviceType === 'APPRENTICESHIP') {
      tokenRequired = '*';
    }
    return `CEI ${tokenRequired}`;
  }

  labelObrigatorio(text: string): String {
    let tokenRequired = '';
    if (this.contract.serviceType === 'INTERNSHIP' && this.contract.personType === 'INDEPENDENT_PROFESSIONAL') {
      tokenRequired = '*';
    }
    return `${text} ${tokenRequired}`;
  }

  clearMessages(): void {
    this.errorMessage = '';
    this.showErrorMessage = false;
    this.showSuccessMessage = false;
  }

  onCancel(): void {
    this.buildForm();
  }

  onConfirm(): void {
    if (this.isSaving) { return; }

    this.clearMessages();
    this.isSaving = true;

    const model = this.formBuilder.toModel(this.form);

    const isDifferentiatedCi = model.isDifferentiatedCi;
    if (!isDifferentiatedCi) {
      model.amountCi = null;
    }
    const contractId = this.contract && this.contract.id;
    { model['contract'] = {id: contractId}; }
    model.activity = model.activity && model.activity.description   ? model.activity : null;
    model.companyType = model.companyType ? model.companyType : null;

    model.contractId = contractId;
    const promise = model.id
      ? this.companyContractPlaceService.atualizarParcial(model.id, model, this.patchParams)
      : this.companyContractPlaceService.criarComRetorno(model);

    promise.toPromise()
      .then(
        updatedModel => {
          this.servicoAlertaService.mostrarMensagemSucesso('Dados salvos com sucesso.');
          const model = this.companyContractPlaceSerializer.fromJSON(updatedModel);
          this.showSuccessMessage = true;
          this.save.emit(model);
        },
        err => {
          this.errorMessage = this.utils.parseErrorMessage(err);
          this.showErrorMessage = true;
        },
      )
      .then(() => { this.isSaving = false; });
  }

  procuraDadosParticipante(documento: string): void {
    if (this.isNew && documento) {
      this.sub.sink = this.procuradorDadosParticipantes.procuraDados(documento, this.contract.id)
        .subscribe(dados => this.preencheCampos(dados));
    }
  }

  private buildForm(): void {
    this.form = this.model && this.contract
      ? this.formBuilder.build(this.model, {
        contract: this.contract,
        disableCi: !this.allowDifferentiatedCi
      })
      : null;

    if (!this.form) { return; }

    this.onChangeIsDifferentiatedCi();
    this.onChangeCompanyPersonType();
  }

  onChangeIsDifferentiatedCi(): void {
    const {
      isDifferentiatedCi,
      amountCi,
    } = this.form.controls;

    this.sub.sink = isDifferentiatedCi.valueChanges
      .subscribe((v: boolean) => {
        const newAmountCi = v ? this.contributionValue : null;
        amountCi.setValue(newAmountCi);
      });
  }

  private onChangeCompanyPersonType(): void {
    const {
      companyPersonType,
    } = this.form.controls;

    this.sub.sink = companyPersonType.valueChanges
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
    cpf,
    cei,
    birthDate,
    name,
    isClassCouncilActive,
    classCouncil,
    councilNumber,
    registerValidity,
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
    isClassCouncilActive,
    classCouncil,
    councilNumber,
    registerValidity,
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
  }

  private fetchContributionValue() {
    this.contributionValue = null;

    const contractInfo = this.contract.companiesContractInfo;
    const contractAddress = contractInfo.addresses[0];

    if (!contractAddress || !this.settings) { return; }

    const { zipCode } = contractAddress.address;
    const { centralizedFinancialManagement, cieeUnitId } = this.settings;

    switch (this.contract.serviceType) {
      case 'APPRENTICESHIP': {
        const actuationTypeId = this.contract.contractingMethod.id;
        const { apprenticeshipProgramType } = this.contract;
        const programTypeId = (
          apprenticeshipProgramType &&
          apprenticeshipProgramType.id
        );

        this.sub.sink = this.contributionApprenticeshipService.searchOne(this.page, {
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
          this.handleError.bind(this),
        );
      }

      case 'INTERNSHIP': {
        this.sub.sink = this.contributionInternshipService.searchOne(this.page, {
          centralizedFinancialManagement,
          cieeUnitId,
          zipCode,
        }).subscribe(
          pagedData => {
            const model = pagedData.data[0];
            if (!model) { return; }
            this.contributionValue = model.minValue;
          },
          this.handleError.bind(this),
        );
      }
    }
  }

  private fetchSettings() {
    this.sub.sink = this.companyContractSettingsService
      .buscarPorContrato(this.contract.id)
      .subscribe(
        settings => {
          this.settings = settings;
          this.fetchContributionValue();
          this.buildForm();
        },
        this.handleError.bind(this),
    );
  }

  private handleError(err: any): void {
    this.errorMessage = this.utils.parseErrorMessage(err);
    this.showErrorMessage = true;
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
    this.selectorActivityCiee.writeValue(new ActivityCiee({id: dados.codigoAtividade}));
    this.selectorSegmentoEmpresa.writeValue(dados.segmento);
    this.form.controls['cnpj'].setValue(dados.cnpj);
    this.form.controls['companyName'].setValue(dados.razaoSocial);
    this.form.controls['tradingName'].setValue(dados.nomeFantasia);
    this.form.controls['site'].setValue(dados.homePage);
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
  }

}
