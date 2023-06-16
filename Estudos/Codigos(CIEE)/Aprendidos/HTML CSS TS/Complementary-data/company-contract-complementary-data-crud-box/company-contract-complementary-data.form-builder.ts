import { BaseComponent } from './../../../shared/components/base-component/baseFormulario.component';

import { Injectable } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators, AbstractControl } from '@angular/forms';

import { ActivityCiee } from 'app/core/ciee-company/activity-ciee/activity-ciee.model';
import { AppFormBuilder } from 'app/core/forms/app-form-builder.interface';
import { CompanyComplementaryData } from 'app/core/ciee-company/company-complementary-data/company-complementary-data.model';
import { PublicBodyClassification, PublicBodyType } from 'app/core/ciee-company/public-body-classification/public-body-classification.model';
import { Carteira } from 'app/core/ciee-unit/instituicao-ensino-campus/instituicao-ensino-campus.services';


export const COMPANY_CONTRACT_COMPLEMENTARY_DATA_CITY_REGISTRATION_MAXLENGTH = 18;
export const COMPANY_CONTRACT_COMPLEMENTARY_DATA_STATE_REGISTRATION_MAXLENGTH = 13;
export const COMPANY_CONTRACT_COMPLEMENTARY_CONTRACT_DESCRIPTION_MAXLENGTH = 150;

interface BuildOptions {
  isCompanyTypePublic?: boolean;
}

@Injectable()
export class CompanyContractComplementaryDataFormBuilder extends BaseComponent
  implements AppFormBuilder<CompanyComplementaryData> {

  constructor(private fb: FormBuilder) {
    super()
  }

  build(
    model: CompanyComplementaryData,
    { isCompanyTypePublic = false }: BuildOptions,
  ): FormGroup {
    const publicBodyType = model.publicBodyClassification
      ? model.publicBodyClassification.publicBodyType
      : null;

    const activityField = this.activityField(model.activity);
    const cityRegistrationField = this.cityRegistrationField(model.cityRegistration);
    const economicActivityDescriptionField = this.economicActivityDescriptionField(null);
    const economicSectorField = this.economicSectorField(null);
    const multiCompanyField = this.multiCompanyField(model.multiCompany);
    const stateRegistrationField = this.stateRegistrationField(model.stateRegistration);
    const freeStateRegistrationField = this.freeStateRegistrationField(model.freeStateRegistration);
    const allowIndependentProfessionalField = this.allowIndependentProfessionalField(model.allowIndependentProfessional);
    const walletConsultantField = this.walletConsultantField(model.walletConsultant);
    const contractDescriptionField = this.contractDescriptionField(model.contractDescription);

    const form = this.fb.group({
      activity: activityField,
      cityRegistration: cityRegistrationField,
      contractId: this.contractIdField(model.contractId),
      economicActivityDescription: economicActivityDescriptionField,
      economicSector: economicSectorField,
      id: this.idField(model.id),
      multiCompany: multiCompanyField,
      publicBodyClassification: this.publicBodyClassificationField(
        model.publicBodyClassification,
        isCompanyTypePublic
      ),
      publicBodyType: this.publicBodyTypeField(
        publicBodyType,
        isCompanyTypePublic,
      ),
      stateRegistration: stateRegistrationField,
      freeStateRegistration: freeStateRegistrationField,
      allowIndependentProfessional: allowIndependentProfessionalField,
      walletConsultant: walletConsultantField,
      contractDescription: contractDescriptionField,
    });

    if (activityField && activityField.value) {
      economicActivityDescriptionField.setValue(activityField.value.description);
      economicSectorField.setValue(activityField.value.economicSector);
      activityField.setValue(String(activityField.value.id));
    } else {
      economicActivityDescriptionField.setValue('');
      economicSectorField.setValue('');
      activityField.setValue('');
    }



    this.sub.sink = multiCompanyField.valueChanges.subscribe(v => {
      if (v) {
        if (cityRegistrationField.enabled) {
          cityRegistrationField.setValue('');
          cityRegistrationField.disable();
        }
        if (stateRegistrationField.enabled) {
          stateRegistrationField.setValue('');
          stateRegistrationField.disable();
        }
        if (allowIndependentProfessionalField.disabled) {
          if (!allowIndependentProfessionalField.value) {
            allowIndependentProfessionalField.setValue(null);
          }
          allowIndependentProfessionalField.enable();
        }
      } else {
        if (cityRegistrationField.disabled) {
          cityRegistrationField.enable();
        }
        if (stateRegistrationField.disabled) {
          stateRegistrationField.enable();
        }
        if (allowIndependentProfessionalField.enabled) {
          allowIndependentProfessionalField.setValue(false);
          allowIndependentProfessionalField.disable();
        }
      }
    });
    multiCompanyField.setValue(multiCompanyField.value);

    this.sub.sink = freeStateRegistrationField.valueChanges.subscribe(v => {
      if (v) {
        if (stateRegistrationField.enabled) {
          stateRegistrationField.setValue('');
          stateRegistrationField.disable();
        }
      } else {
        if (stateRegistrationField.disabled) {
          stateRegistrationField.setValue('');
          stateRegistrationField.enable();
        }
      }
    })

    return form;
  }

  toModel(form: FormGroup): CompanyComplementaryData {
    const value = form.getRawValue();

    const activity = new ActivityCiee({ id: Number(value.activity) });
    const publicBodyClassification = <PublicBodyClassification>value.publicBodyClassification;


    return new CompanyComplementaryData({
      activity,
      cityRegistration: value.cityRegistration,
      contractId: value.contractId,
      id: value.id,
      multiCompany: value.multiCompany,
      publicBodyClassification,
      stateRegistration: value.stateRegistration,
      freeStateRegistration: value.freeStateRegistration,
      allowIndependentProfessional: value.allowIndependentProfessional,
      walletConsultant: value.walletConsultant ? value.walletConsultant : null ,
      contractDescription: value.contractDescription,
    });
  }

  private activityField(value: ActivityCiee): FormControl {
    if (value === undefined || !value.id) {
      value = null;
    }
    return new FormControl(value, [Validators.required, this.activityFieldValidator]);
  }

  private activityFieldValidator(control: AbstractControl) {
    if (control.value == null || control.value === false || control.value === undefined) {
      return { required: true }
    }
    return null;
  }

  private cityRegistrationField(value: string): FormControl {
    return new FormControl(
      value || '',
      Validators.maxLength(COMPANY_CONTRACT_COMPLEMENTARY_DATA_CITY_REGISTRATION_MAXLENGTH),
    );
  }

  private contractIdField(value: number): FormControl {
    return new FormControl(value || null);
  }

  private economicActivityDescriptionField(value: string): FormControl {
    return new FormControl({ value: value || '', disabled: true });
  }

  private economicSectorField(value: string): FormControl {
    return new FormControl({ value: value || '', disabled: true });
  }

  private idField(value: number): FormControl {
    return new FormControl(value || null);
  }

  private multiCompanyField(value: boolean): FormControl {
    return new FormControl(value == null ? null : value, Validators.required);
  }

  allowIndependentProfessionalField(value: boolean): any {
    return new FormControl(value == null ? null : value, Validators.required);
  }

  private walletConsultantField(value: number): FormControl {
    return new FormControl(value || null);
  }

  private publicBodyClassificationField(
    value: PublicBodyClassification,
    isCompanyTypePublic = false,
  ): FormControl {
    return isCompanyTypePublic
      ? new FormControl(value || null, Validators.required)
      : new FormControl({ value: null, disabled: true });
  }

  private publicBodyTypeField(
    value: PublicBodyType,
    isCompanyTypePublic = false,
  ): FormControl {
    return isCompanyTypePublic
      ? new FormControl(value || '', Validators.required)
      : new FormControl({ value: null, disabled: true });
  }

  private stateRegistrationField(value: string): FormControl {
    return new FormControl(
      value || '',
      Validators.maxLength(COMPANY_CONTRACT_COMPLEMENTARY_DATA_STATE_REGISTRATION_MAXLENGTH),
    );
  }

  private freeStateRegistrationField(value: boolean): FormControl {
    return new FormControl(value || false);
  }

  private contractDescriptionField(value: string): FormControl {
    return new FormControl(
      value || '',
      Validators.maxLength(COMPANY_CONTRACT_COMPLEMENTARY_CONTRACT_DESCRIPTION_MAXLENGTH),
    );
  }
}
