import { CompanyPorte } from './../../../../core/ciee-company/company-porte/company-porte.model';
import { BaseComponent } from '../../../../shared/components/base-component/baseFormulario.component';
import { CompanyServiceType } from '../../../../core/ciee-company/company-contract/company-contract.model';
import { Injectable } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators, ValidatorFn } from '@angular/forms';
import * as moment from 'moment';

import { ActivityCiee } from 'app/core/ciee-company/activity-ciee/activity-ciee.model';
import { AppFormBuilder } from 'app/core/forms/app-form-builder.interface';
import { AppValidators } from 'app/core/app-validators.model';
import { CompanyContract } from 'app/core/ciee-company/company-contract/company-contract.model';
import { CompanyContractPlace } from 'app/core/ciee-company/company-contract-place/company-contract-place.model';
import { CompanyTypeIdentifier } from 'app/core/ciee-company/company-type/company-type.model';
import { CompanyPersonType } from '../../../../core/ciee-company/company/company.model';
import { ClassCouncil } from 'app/core/ciee-company/class-council/class-council.model';

export const COMPANY_CONTRACT_PLACE_CEI_MAXLENGTH = 150;
export const COMPANY_CONTRACT_PLACE_COMPANY_NAME_MAXLENGTH = 150;
export const COMPANY_CONTRACT_PLACE_EMAIL_MAXLENGTH = 150;
export const COMPANY_CONTRACT_PLACE_MUNICIPAL_INSCRIPTION_MAXLENGTH = 18;
export const COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH = 150;
export const COMPANY_CONTRACT_PLACE_SITE_MAXLENGTH = 50;
export const COMPANY_CONTRACT_PLACE_STATE_INSCRIPTION_MAXLENGTH = 20;
export const COMPANY_CONTRACT_PLACE_TRADING_NAME_MAXLENGTH = 150;
export const COMPANY_CONTRACT_PLACE_COUNCIL_NUMBER_MAXLENGTH = 20;
export const COMPANY_CONTRACT_PLACE_CAEPF_NUMBER_MAXLENGTH = 14;
export const COMPANY_CONTRACT_PLACE_CNO_NUMBER_MAXLENGTH = 12;


export interface CompanyContractPlaceFormOptions {
  contract: CompanyContract;
  disableCi: boolean;
}

@Injectable()
export class CompanyContractPlaceFormBuilder extends BaseComponent
  implements AppFormBuilder<CompanyContractPlace> {
  val: any;

  constructor(
    private fb: FormBuilder,
  ) {
    super()
  }

  build(
    model: CompanyContractPlace,
    options: CompanyContractPlaceFormOptions,
  ): FormGroup {
    const { contract, disableCi } = options;
    const { personType, isIndependentProfessional } = contract;
    const isCompanyPersonTypeFieldDisabled = isIndependentProfessional || !contract.complementaryData.allowIndependentProfessional;

    const companyPersonTypeField = this.companyPersonTypeField(model.companyPersonType, personType, isCompanyPersonTypeFieldDisabled);

    const cnpjField = this.cnpjField(model.cnpj, companyPersonTypeField)
    const cnpjBaseField = this.cnpjBaseField(model.cnpjBase, contract);
    const cnpjComplementField = this.cnpjComplementField(model.cnpjComplement);
    const isDifferentiatedCiField = this.isDifferentiatedCiField(model.isDifferentiatedCi, disableCi);
    const amountCiField = this.amountCiField(model.amountCi, disableCi, isDifferentiatedCiField);
    const stateInscriptionField = this.stateInscriptionField(model.stateInscription);
    const freeStateInscriptionField = this.freeStateInscriptionField(model.freeStateInscription);
    const jovemTalento = this.campoJovemTalento(model.jovemTalento);
    const estadoField = this.stateField(model.state, stateInscriptionField);
    const descricaoLocalField = this.descricaoLocalField(model.descricaoLocal);
    const carteiraConsultorField = this.carteiraConsultorField(model.carteiraConsultor);

    this.sub.sink = cnpjBaseField.valueChanges.subscribe(v => {
      this.updateCnpjField(cnpjField, cnpjBaseField, cnpjComplementField);
    });

    this.sub.sink = cnpjComplementField.valueChanges.subscribe(v => {
      this.updateCnpjField(cnpjField, cnpjBaseField, cnpjComplementField);
    });

    this.sub.sink = isDifferentiatedCiField.valueChanges.subscribe(v => {
      amountCiField.updateValueAndValidity();
    });

    this.sub.sink = freeStateInscriptionField.valueChanges.subscribe(v => {
      if (v) {
        if (stateInscriptionField.enabled) {
          stateInscriptionField.setValue('');
          stateInscriptionField.disable();
        }
      } else {
        if (stateInscriptionField.disabled) {
          stateInscriptionField.setValue('');
          stateInscriptionField.enable();
        }
      }
    });

    this.sub.sink = stateInscriptionField.valueChanges.subscribe(v => {
      estadoField.updateValueAndValidity();
    });


    const form = this.fb.group({
      activity: this.activityField(model.activity),
      amountCi: amountCiField,
      birthDate: this.birthDateField(model.birthDate ? moment(model.birthDate) : null, companyPersonTypeField),
      cei: this.ceiField(model.cei, contract, companyPersonTypeField),
      cnpj: cnpjField,
      cnpjBase: cnpjBaseField,
      cnpjComplement: cnpjComplementField,
      companyName: this.companyNameField(model.companyName, companyPersonTypeField),
      companyType: this.companyTypeField(model.companyType),
      companyPorte: model.companyPorte,
      contractId: this.idField(model.contractId),
      cpf: this.cpfField(model.cpf, contract, companyPersonTypeField),
      id: this.idField(model.id),
      isContractAdmin: this.isContractAdminField(model.isContractAdmin),
      isDifferentiatedCi: isDifferentiatedCiField,
      municipalInscription: this.municipalInscriptionField(model.municipalInscription),
      name: this.nameField(model.name, companyPersonTypeField),
      site: this.siteField(model.site),
      state: estadoField,
      status: model.status,
      stateInscription: stateInscriptionField,
      freeStateInscription: freeStateInscriptionField,
      tradingName: this.tradingNameField(model.tradingName, companyPersonTypeField),
      companyPersonType: companyPersonTypeField,
      isClassCouncilActive: this.isClassCouncilActiveField(model.isClassCouncilActive, companyPersonTypeField, contract.serviceType),
      classCouncil: this.classCouncilField(model.classCouncil, companyPersonTypeField, contract.serviceType),
      councilNumber: this.councilNumberField(model.councilNumber, companyPersonTypeField , contract.serviceType),
      registerValidity: this.registerValidityField(model.registerValidity),
      idConfiguracaoCobranca: new FormControl(''),
      configuracaoPadrao: new FormControl(true, Validators.required),
      jovemTalento: jovemTalento,
      caepf: this.caepfField(!!model.caepf ? model.caepf : null),
      cno: this.cnoField(!!model.cno ? model.cno : null),
      descricaoLocal: descricaoLocalField,
      carteiraConsultor: carteiraConsultorField,
    });

    return form;
  }
  // contract.serviceType === 'APPRENTICESHIP' && companyPersonTypeField.value === 'INDEPENDENT_PROFESSIONAL'

  toModel(form: FormGroup): CompanyContractPlace {
    const value = form.getRawValue();
    return new CompanyContractPlace({
      activity: value.activity,
      amountCi: value.amountCi,
      birthDate: value.birthDate ? moment(value.birthDate) : null,
      cei: value.cei,
      cnpj: value.cnpj || null,
      companyName: value.companyName,
      companyType: value.companyType,
      companyPorte: value.companyPorte,
      contractId: value.contractId,
      cpf: value.cpf || null,
      id: value.id,
      isContractAdmin: value.isContractAdmin,
      isDifferentiatedCi: value.isDifferentiatedCi,
      municipalInscription: value.municipalInscription,
      name: value.name,
      site: value.site,
      state: value.state,
      status: value.status,
      stateInscription: value.stateInscription,
      freeStateInscription: value.freeStateInscription,
      tradingName: value.tradingName,
      companyPersonType: value.companyPersonType,
      isClassCouncilActive: value.isClassCouncilActive,
      classCouncil: value.classCouncil,
      councilNumber: value.councilNumber,
      registerValidity: value.registerValidity ? moment(value.registerValidity) : null,
      idConfiguracaoCobranca: value.idConfiguracaoCobranca,
      jovemTalento: value.jovemTalento,
      caepf: value.caepf,
      cno: value.cno,
      descricaoLocal: value.descricaoLocal,
      carteiraConsultor: value.carteiraConsultor ? value.carteiraConsultor : null,
    });
  }

  private isClassCouncilActiveField(value: boolean, companyPersonTypeField: FormControl, serviceTyp?: CompanyServiceType): FormControl {
    return new FormControl(
      value || false,
      this.requiredWhenIndependentProfessionalValidator(companyPersonTypeField,serviceTyp),
    );
  }

  private classCouncilField(value: ClassCouncil, companyPersonTypeField: FormControl, serviceTyp?: CompanyServiceType): FormControl {
    return new FormControl(
      value || null,
      this.requiredWhenIndependentProfessionalValidator(companyPersonTypeField, serviceTyp),
    );
  }

  private councilNumberField(value: string, companyPersonTypeField: FormControl, serviceTyp?: CompanyServiceType): FormControl {
    return new FormControl(value || '', [
      this.requiredWhenIndependentProfessionalValidator(companyPersonTypeField, serviceTyp),
      Validators.maxLength(COMPANY_CONTRACT_PLACE_COUNCIL_NUMBER_MAXLENGTH),
    ].filter(Boolean));
  }

  private registerValidityField(value: moment.Moment): FormControl {
    const date = value ? moment(value).toDate() : null;
    return new FormControl(date || '', AppValidators.date);
  }

  private companyPersonTypeField(value: CompanyPersonType, personType: CompanyPersonType, disabled: boolean): FormControl {
    return new FormControl({ value: value || personType, disabled: disabled }, Validators.required);
  }

  private activityField(value: ActivityCiee): FormControl {
    return new FormControl(value || null);
  }

  private amountCiField(
    value: number,
    disabled: boolean,
    isDifferentiatedCiField: FormControl,
  ): FormControl {
    return new FormControl(
      {
        value: value || null,
        disabled,
      },
      AppValidators.conditional(
        () => Validators.required,
        () => isDifferentiatedCiField.value,
      ),
    );
  }

  private birthDateField(
    value: moment.Moment,
    companyPersonTypeField: FormControl,
  ): FormControl {
    const date = value ? value.toDate() : null;
    return new FormControl(date, [
      this.requiredWhenIndependentProfessionalValidator(companyPersonTypeField),
      AppValidators.date,
    ].filter(Boolean));
  }

  private ceiField(
    value: string,
    contract: CompanyContract,
    companyPersonTypeField: FormControl,
  ): FormControl {
    return new FormControl(value || '');
  }

  private cnoField(
    value: string,
  ): FormControl {
    return new FormControl(value || null);
  }

  private caepfField(
    value: string,
  ): FormControl {
    return new FormControl(value || null);
  }
  private descricaoLocalField(
    value: string,
  ): FormControl {
    return new FormControl(value || null);
  }
  private carteiraConsultorField(
    value: number,
  ): FormControl{
    return new FormControl(value || null);
  }

  private cnpjField(value: string, companyPersonTypeField: FormControl): FormControl {
    return new FormControl(value || '', [
      AppValidators.cnpj,
      this.requiredWhenLegalEntityValidator(companyPersonTypeField)
    ].filter(Boolean));
  }

  private cnpjBaseField(
    value: string,
    contract: CompanyContract
  ): FormControl {
    const isMultiCompany = contract.complementaryData && contract.complementaryData.multiCompany;

    if (isMultiCompany) {
      this.val = value
    } else {
      this.val = contract.companiesContractInfo.cnpjBase;
    }

    return new FormControl({ value: this.val || '', disabled: !isMultiCompany });
  }

  private cnpjComplementField(value: string): FormControl {
    return new FormControl(value || '');
  }

  private companyNameField(
    value: string,
    companyPersonTypeField: FormControl,
  ): FormControl {
    return new FormControl(
      value || '',
      [
        this.requiredWhenLegalEntityValidator(companyPersonTypeField),
        Validators.maxLength(COMPANY_CONTRACT_PLACE_COMPANY_NAME_MAXLENGTH),
      ].filter(Boolean),
    );
  }

  private companyTypeField(value: CompanyTypeIdentifier): FormControl {
    return new FormControl(value || '');
  }

  private cpfField(value: string, contract: CompanyContract, companyPersonTypeField: FormControl): FormControl {
    if (contract.isIndependentProfessional) {
      this.val = contract.companiesContractInfo.cpf;
    } else {
      this.val = value
    }

    return new FormControl({
      value: this.val || '',
      disabled: contract.isIndependentProfessional,
    },
      this.requiredWhenIndependentProfessionalValidator(companyPersonTypeField)
    );
  }

  private idField(value: number): FormControl {
    return new FormControl(value || null);
  }

  private isContractAdminField(value: boolean): FormControl {
    return new FormControl(value == null ? null : value);
  }

  private isDifferentiatedCiField(value: boolean, disabled: boolean): FormControl {
    value = !!value;
    return new FormControl({ value, disabled }, [Validators.required]);
  }

  private municipalInscriptionField(value: string): FormControl {
    return new FormControl(
      value || '',
      Validators.maxLength(COMPANY_CONTRACT_PLACE_MUNICIPAL_INSCRIPTION_MAXLENGTH),
    );
  }

  private nameField(
    value: string,
    companyPersonTypeField: FormControl,
  ): FormControl {
    return new FormControl(
      value || '',
      [
        this.requiredWhenIndependentProfessionalValidator(companyPersonTypeField),
        Validators.maxLength(COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH),
      ].filter(Boolean),
    );
  }

  private siteField(value: string): FormControl {
    return new FormControl(
      value || '',
      Validators.maxLength(COMPANY_CONTRACT_PLACE_SITE_MAXLENGTH),
    );
  }

  private stateField(value: string, stateInscription: FormControl): FormControl {
    return new FormControl(
      value || '',
      [
        this.requiredWhenStateInscriptionValidator(stateInscription),
      ].filter(Boolean),
    );
  }

  private stateInscriptionField(value: string): FormControl {
    return new FormControl(
      value || '',
      Validators.maxLength(COMPANY_CONTRACT_PLACE_STATE_INSCRIPTION_MAXLENGTH),
    );
  }

  private freeStateInscriptionField(value: boolean): FormControl {
    return new FormControl(value || false);
  }

  private campoJovemTalento(valor: boolean): FormControl {
    return new FormControl({ value: Boolean(valor), disabled: true }, [Validators.required]);
  }

  private tradingNameField(
    value: string,
    companyPersonTypeField: FormControl,
  ): FormControl {
    return new FormControl(
      value || '',
      [
        AppValidators.conditional(
          () => Validators.maxLength(COMPANY_CONTRACT_PLACE_TRADING_NAME_MAXLENGTH),
          () => this.requiredWhenLegalEntityValidator(companyPersonTypeField) && Boolean(value)
        )
      ],
    );
  }

  private updateCnpjField(
    cnpjField: FormControl,
    baseField: FormControl,
    complementField: FormControl,
  ): void {
    const value = [
      baseField.value,
      complementField.value,
    ].filter(Boolean).join('');

    cnpjField.setValue(value || '');
    cnpjField.markAsTouched();
  }

  private requiredWhenIndependentProfessionalValidator(companyPersonTypeField: FormControl, serviceType?: CompanyServiceType): ValidatorFn {
    return AppValidators.conditional(
      () => Validators.required,
      () => (!serviceType || serviceType === 'INTERNSHIP') && companyPersonTypeField.value === 'INDEPENDENT_PROFESSIONAL',
    );
  }

  private requiredWhenLegalEntityValidator(companyPersonTypeField: FormControl): ValidatorFn {
    return AppValidators.conditional(
      () => Validators.required,
      () => companyPersonTypeField.value === 'LEGAL_ENTITY',
    );
  }

  private requiredWhenStateInscriptionValidator(inscricaoEstadual: FormControl): ValidatorFn {
    return AppValidators.conditional(
      () => Validators.required,
      () => (inscricaoEstadual && inscricaoEstadual.value !== ''),
    );
  }
}
