import { ActivityCiee } from 'app/core/ciee-company/activity-ciee/activity-ciee.model';
import { PublicBodyClassification } from 'app/core/ciee-company/public-body-classification/public-body-classification.model';
import { Carteira } from 'app/core/ciee-unit/instituicao-ensino-campus/instituicao-ensino-campus.services';

interface CompanyComplementaryDataAttributes {
  activity?: ActivityCiee;
  cityRegistration?: string;
  contractId?: number;
  id?: number;
  multiCompany?: boolean;
  publicBodyClassification?: PublicBodyClassification
  stateRegistration?: string;
  freeStateRegistration?: boolean;
  allowIndependentProfessional?: boolean;
  contractDescription?: string;
  walletConsultant?: number;
}

export class CompanyComplementaryData implements CompanyComplementaryDataAttributes {
  activity: ActivityCiee;
  cityRegistration: string;
  contractId: number;
  id: number;
  multiCompany: boolean;
  publicBodyClassification: PublicBodyClassification;
  stateRegistration: string;
  freeStateRegistration: boolean;
  allowIndependentProfessional: boolean
  contractDescription: string;
  walletConsultant: number;

  constructor(attr: CompanyComplementaryDataAttributes = {}) {
    this.activity = attr.activity;
    this.cityRegistration = attr.cityRegistration;
    this.contractId = attr.contractId;
    this.id = attr.id;
    this.multiCompany = attr.multiCompany;
    this.publicBodyClassification = attr.publicBodyClassification;
    this.stateRegistration = attr.stateRegistration;
    this.freeStateRegistration = attr.freeStateRegistration;
    this.allowIndependentProfessional = attr.allowIndependentProfessional;
    this.walletConsultant = attr.walletConsultant;
    this.contractDescription = attr.contractDescription;
  }
}
