
import * as moment from 'moment';

import { ActivityCieeSerializer } from 'app/core/ciee-company/activity-ciee/activity-ciee.serializer';
import { ClassCouncilSerializer } from 'app/core/ciee-company/class-council/class-council.serializer';
import { CompanyContractPlace } from 'app/core/ciee-company/company-contract-place/company-contract-place.model';
import { CompanyContractPlaceAddressSerializer } from 'app/core/ciee-company/company-contract-place-address/company-contract-place-address.serializer';
import { CompanyContractPlaceContactSerializer } from 'app/core/ciee-company/company-contract-place-contact/company-contract-place-contact.serializer';
import { CompanyRepresentativeSerializer } from 'app/core/ciee-company/company-representative/company-representative.serializer';
import { JSON, PagedJSON } from 'app/core/json.interface';
import { PhoneSerializer } from 'app/core/ciee-core/phone/phone.serializer';
import { SerializerInterface } from 'app/core/ciee.service';


const BIRTHDAY_FORMAT = 'YYYY-MM-DD';

export class CompanyContractPlaceSerializer
  implements SerializerInterface<CompanyContractPlace> {

  activitySerializer = new ActivityCieeSerializer();
  addressSerializer = new CompanyContractPlaceAddressSerializer();
  classCouncilSerializer = new ClassCouncilSerializer();
  contactSerializer = new CompanyContractPlaceContactSerializer();
  phoneSerializer = new PhoneSerializer();
  representativeSerializer = new CompanyRepresentativeSerializer();

  fromJSON(json: JSON): CompanyContractPlace {
    if (json == null) { json = {}; }

    return new CompanyContractPlace({
      activity: (
        json.activity &&
        this.activitySerializer.fromJSON(json.activity)
      ),
      address: json.address,
      addresses: (
        json.contractPlacesAddresses &&
        this.addressSerializer.listFromJSON(json.contractPlacesAddresses)
      ),
      amountCi: json.amountCi,
      birthDate: json.birthDate && moment(json.birthDate, BIRTHDAY_FORMAT),
      blocked: json.blocked,
      cei: json.cei,
      cieeUnitDescription: json.cieeUnitDescription,
      cieeUnitLocalDescription: json.cieeUnitLocalDescription ? json.cieeUnitLocalDescription : null,
      classCouncil: (
        json.classCouncil &&
        this.classCouncilSerializer.fromJSON(json.classCouncil)
      ),
      cnpj: json.cnpj,
      companyName: json.companyName,
      companyType: json.companyType,
      contacts: (
        json.contacts &&
        this.contactSerializer.listFromJSON(json.contacts)
      ),
      contractId: json.contract,
      councilNumber: json.councilNumber,
      cpf: json.cpf,
      electronicInvoiceEmail: json.electronicInvoiceEmail,
      hasElectronicInvoice: json.hasElectronicInvoice,
      id: json.id,
      isContractAdmin: json.isContractAdmin,
      isDifferentiatedCi: json.isDifferentiatedCi,
      managementDescription: json.managementDescription,
      municipalInscription: json.municipalInscription,
      name: json.name,
      phones: json.phones && this.phoneSerializer.listFromJSON(json.phones),
      registerValidity: json.registerValidity && moment(json.registerValidity, BIRTHDAY_FORMAT),
      representatives: (
        json.representatives &&
        this.representativeSerializer.listFromJSON(json.representatives)
      ),
      site: json.site,
      state: json.state,
      stateInscription: json.stateInscription,
      status: json.status,
      tradingName: json.tradingName,
      companyPersonType: json.companyPersonType,
      isClassCouncilActive: json.isClassCouncilActive,
      idConfiguracaoCobranca: json.idConfiguracaoCobranca,
      jovemTalento: json.jovemTalento,
      cno: json.cno,
      caepf: json.caepf,
      companyPorte: json.companyPorte,
      descricaoLocal: json.descricaoLocal,
      carteiraConsultor: json.carteiraConsultor

    });
  }

  listFromJSON(json: JSON[] | PagedJSON): CompanyContractPlace[] {
    if (json == null) { json = []; }
    if (!Array.isArray(json)) { json = json.content; }
    return json.map(entityJSON => this.fromJSON(entityJSON));
  }

  toJSON(model: CompanyContractPlace): JSON {
    const json: JSON = {};

    json.activity = (
      model.activity &&
      this.activitySerializer.toJSON(model.activity)
    );
    json.address = model.address;
    json.contractPlacesAddresses = (
      model.addresses &&
      model.addresses.map(a => this.addressSerializer.toJSON(a))
    );
    json.amountCi = model.amountCi;
    if (model.birthDate) {
      json.birthDate =  model.birthDate.format(BIRTHDAY_FORMAT);
    };
    json.blocked = model.blocked;
    if (model.cei) { json.cei = model.cei; }
    json.cieeUnitDescription = model.cieeUnitDescription;
    if (model.classCouncil) {
      json.classCouncil = this.classCouncilSerializer.toJSON(model.classCouncil);
    }
    if (model.cnpj) { json.cnpj = model.cnpj; }
    if (model.companyName) { json.companyName = model.companyName; }
    if (model.companyType) { json.companyType = model.companyType; }
    json.contacts = (
      model.contacts &&
      model.contacts.map(c => this.contactSerializer.toJSON(c))
    );
    if (model.contractId) { json.contract = { id: model.contractId }; }
    if (model.councilNumber) { json.councilNumber = model.councilNumber; }
    if (model.cpf) { json.cpf = model.cpf; }
    json.electronicInvoiceEmail = model.electronicInvoiceEmail;
    json.hasElectronicInvoice = model.hasElectronicInvoice;
    if (model.id) { json.id = model.id; }
    json.isContractAdmin = model.isContractAdmin;
    json.isDifferentiatedCi = model.isDifferentiatedCi;
    json.managementDescription = model.managementDescription;
    json.municipalInscription = model.municipalInscription;
    if (model.name) { json.name = model.name; }
    if (model.descricaoLocal) { json.descricaoLocal = model.descricaoLocal; }
    if (model.carteiraConsultor) {json.carteiraConsultor = model.carteiraConsultor;}
    json.phones = (
      model.phones &&
      model.phones.map(p => this.phoneSerializer.toJSON(p))
    );
    if (model.registerValidity) {
      json.registerValidity = model.registerValidity.format(BIRTHDAY_FORMAT);
    }
    json.representatives = (
      model.representatives &&
      model.representatives.map(r => this.representativeSerializer.toJSON(r))
    );
    json.site = model.site;
    json.state = model.state;
    json.stateInscription = model.stateInscription;
    json.status = model.status;
    if (model.tradingName) { json.tradingName = model.tradingName; }
    json.companyPersonType = model.companyPersonType;
    json.isClassCouncilActive = model.isClassCouncilActive;
    json.idConfiguracaoCobranca = model.idConfiguracaoCobranca;
    json.descricaoLocal = model.descricaoLocal;
    json.carteiraConsultor = model.carteiraConsultor;
    return json;
  }
}
