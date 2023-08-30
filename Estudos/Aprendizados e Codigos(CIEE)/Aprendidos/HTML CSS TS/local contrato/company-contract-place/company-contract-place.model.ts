import { Moment } from 'moment';

import { ActivityCiee } from 'app/core/ciee-company/activity-ciee/activity-ciee.model';
import { ClassCouncil } from 'app/core/ciee-company/class-council/class-council.model';
import { CompanyContractPlaceAddress } from 'app/core/ciee-company/company-contract-place-address/company-contract-place-address.model';
import { CompanyContractPlaceContact } from 'app/core/ciee-company/company-contract-place-contact/company-contract-place-contact.model';
import { CompanyRepresentative } from 'app/core/ciee-company/company-representative/company-representative.model';
import { CompanyTypeIdentifier } from 'app/core/ciee-company/company-type/company-type.model';
import { Phone } from 'app/core/ciee-core/phone/phone.model';
import { CompanyPersonType } from '../company/company.model';
import { CompanyPorteIdentifier } from '../company-porte/company-porte.model';

export type CompanyContractPlaceStatus = 'ACTIVE' | 'PENDENTE';

export const COMPANY_CONTRACT_PLACE_STATUS = {
  ACTIVE: 'Ativo',
  PENDENTE: 'Pendente',
}

interface CompanyContractPlaceAttributes {
  activity?: ActivityCiee;
  address?: string;
  addresses?: CompanyContractPlaceAddress[];
  amountCi?: number;
  birthDate?: Moment;
  blocked?: boolean;
  cei?: string;
  cieeUnitDescription?: string;
  cieeUnitLocalDescription?: string;
  classCouncil?: ClassCouncil;
  cnpj?: string;
  companyName?: string;
  companyType?: CompanyTypeIdentifier;
  contacts?: CompanyContractPlaceContact[];
  contractId?: number;
  councilNumber?: string;
  cpf?: string;
  electronicInvoiceEmail?: string;
  hasElectronicInvoice?: boolean;
  id?: number;
  isContractAdmin?: boolean;
  isDifferentiatedCi?: boolean;
  managementDescription?: string;
  municipalInscription?: string;
  name?: string;
  phones?: Phone[];
  registerValidity?: Moment;
  representatives?: CompanyRepresentative[];
  site?: string;
  state?: string;
  stateInscription?: string;
  freeStateInscription?: boolean;
  status?: CompanyContractPlaceStatus;
  tradingName?: string;
  companyPersonType?: CompanyPersonType;
  isClassCouncilActive?: boolean;
  idConfiguracaoCobranca?: number;
  jovemTalento?: boolean;
  caepf?: string;
  cno?: string;
  companyPorte?: CompanyPorteIdentifier;
  descricaoLocal?: string;
  carteiraConsultor?: number;
}

export class CompanyContractPlace implements CompanyContractPlaceAttributes {
  activity: ActivityCiee;
  address: string;
  addresses: CompanyContractPlaceAddress[];
  amountCi: number;
  birthDate: Moment;
  blocked?: boolean;
  cei: string;
  cieeUnitDescription: string;
  cieeUnitLocalDescription?: string;
  classCouncil: ClassCouncil;
  cnpj: string;
  companyName: string;
  companyType: CompanyTypeIdentifier;
  contacts: CompanyContractPlaceContact[];
  contractId: number;
  councilNumber: string;
  cpf: string;
  electronicInvoiceEmail: string;
  hasElectronicInvoice: boolean;
  id: number;
  isContractAdmin: boolean;
  isDifferentiatedCi: boolean;
  managementDescription: string;
  municipalInscription: string;
  name: string;
  phones: Phone[];
  registerValidity: Moment;
  representatives: CompanyRepresentative[];
  site: string;
  state: string;
  stateInscription: string;
  freeStateInscription: boolean;
  status: CompanyContractPlaceStatus;
  tradingName: string;
  companyPersonType: CompanyPersonType;
  isClassCouncilActive: boolean;
  idConfiguracaoCobranca: number;
  jovemTalento: boolean;
  caepf: string;
  cno: string;
  companyPorte: CompanyPorteIdentifier;
  descricaoLocal: string;
  carteiraConsultor: number;

  constructor({
    addresses = [],
    phones = [],
    representatives = [],
    ...attr
  }: CompanyContractPlaceAttributes = {}) {
    this.activity = attr.activity;
    this.address = attr.address;
    this.addresses = addresses;
    this.amountCi = attr.amountCi;
    this.birthDate = attr.birthDate;
    this.blocked = attr.blocked;
    this.cei = attr.cei;
    this.cieeUnitDescription = attr.cieeUnitDescription;
    this.cieeUnitLocalDescription = attr.cieeUnitLocalDescription ? attr.cieeUnitLocalDescription : null;
    this.classCouncil = attr.classCouncil;
    this.cnpj = attr.cnpj;
    this.companyName = attr.companyName;
    this.companyType = attr.companyType;
    this.contacts = attr.contacts;
    this.contractId = attr.contractId;
    this.councilNumber = attr.councilNumber;
    this.cpf = attr.cpf;
    this.electronicInvoiceEmail = attr.electronicInvoiceEmail;
    this.hasElectronicInvoice = attr.hasElectronicInvoice;
    this.id = attr.id;
    this.isContractAdmin = attr.isContractAdmin;
    this.isDifferentiatedCi = attr.isDifferentiatedCi;
    this.managementDescription = attr.managementDescription;
    this.municipalInscription = attr.municipalInscription;
    this.name = attr.name;
    this.phones = phones;
    this.registerValidity = attr.registerValidity;
    this.representatives = representatives;
    this.site = attr.site;
    this.state = attr.state;
    this.stateInscription = attr.stateInscription;
    this.freeStateInscription = attr.freeStateInscription;
    this.status = attr.status;
    this.tradingName = attr.tradingName;
    this.companyPersonType = attr.companyPersonType;
    this.isClassCouncilActive = attr.isClassCouncilActive;
    this.idConfiguracaoCobranca = attr.idConfiguracaoCobranca;
    this.jovemTalento = attr.jovemTalento;
    this.caepf = !!attr.caepf ? attr.caepf : null;
    this.cno = !!attr.cno ? attr.cno : null;
    this.companyPorte = attr.companyPorte;
    this.descricaoLocal = attr.descricaoLocal;
    this.carteiraConsultor = attr.carteiraConsultor;
  }

  get cnpjBase(): string {
    return this.cnpj ? this.cnpj.substr(0, 8) : '';
  }

  get cnpjComplement(): string {
    return this.cnpj ? this.cnpj.substr(8, 14) : '';
  }

  get isLegalEntity(): boolean {
    return this.companyPersonType === 'LEGAL_ENTITY';
  }
}
