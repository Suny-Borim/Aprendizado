
import { ActivityCieeSerializer } from 'app/core/ciee-company/activity-ciee/activity-ciee.serializer';
import { CompanyComplementaryData } from 'app/core/ciee-company/company-complementary-data/company-complementary-data.model';
import { JSON, PagedJSON } from 'app/core/json.interface';
import { PublicBodyClassificationSerializer } from 'app/core/ciee-company/public-body-classification/public-body-classification.serializer';
import { SerializerInterface } from 'app/core/ciee.service';


export class CompanyComplementaryDataSerializer implements SerializerInterface<CompanyComplementaryData> {
  activitySerializer = new ActivityCieeSerializer();
  publicBodyClassificationSerializer = new PublicBodyClassificationSerializer();

  fromJSON(json: JSON): CompanyComplementaryData {
    if (json == null) { json = {}; }
    return new CompanyComplementaryData ({
      activity: (
        json.activity &&
        this.activitySerializer.fromJSON(json.activity)
      ),
      cityRegistration: json.cityRegistration,
      contractId: json.contractId,
      id: json.id,
      multiCompany: json.multiCompany,
      publicBodyClassification: (
        json.publicBodyClassification &&
        this.publicBodyClassificationSerializer.fromJSON(json.publicBodyClassification)
      ),
      stateRegistration: json.stateRegistration,
      allowIndependentProfessional: json.allowIndependentProfessional,
      freeStateRegistration: json.freeStateRegistration,
      walletConsultant: json.walletConsultant,
      contractDescription: json.contractDescription
    });
  }

  listFromJSON(json: JSON[] | PagedJSON): CompanyComplementaryData[] {
    if (json == null) { json = []; }
    if (!Array.isArray(json)) { json = json.content; }
    return json.map(entityJSON => this.fromJSON(entityJSON));
  }

  toJSON(model: CompanyComplementaryData): JSON {
    const json: JSON = {};

    json.activity = model.activity
      ? this.activitySerializer.toJSON(model.activity)
      : null;
    json.cityRegistration = model.cityRegistration;
    json.contractId = model.contractId;
    if (model.id) { json.id = model.id; }
    json.multiCompany = model.multiCompany;
    json.publicBodyClassification = model.publicBodyClassification
      ? this.publicBodyClassificationSerializer.toJSON(model.publicBodyClassification)
      : null;
    json.stateRegistration = model.stateRegistration;
    json.allowIndependentProfessional = model.allowIndependentProfessional;
    json.walletConsultant = model.walletConsultant;
    json.contractDescription = model.contractDescription;

    return json;
  }
}
