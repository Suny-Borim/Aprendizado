import {BaseComponent} from '../../../shared/components/base-component/baseFormulario.component';

import {Component, EventEmitter, Input, OnChanges, Output, SimpleChanges} from '@angular/core';
import {FormGroup} from '@angular/forms';

import {
  COMPANY_CONTRACT_COMPLEMENTARY_DATA_CITY_REGISTRATION_MAXLENGTH,
  COMPANY_CONTRACT_COMPLEMENTARY_DATA_STATE_REGISTRATION_MAXLENGTH,
  CompanyContractComplementaryDataFormBuilder,
  COMPANY_CONTRACT_COMPLEMENTARY_CONTRACT_DESCRIPTION_MAXLENGTH,
} from 'app/admin/company-contract/company-contract-complementary-data-crud-box/company-contract-complementary-data.form-builder';

import {UtilsService} from 'app/core/utils/utils.service';
import {FormUtilsService} from 'app/core/utils/form-utils.service';
import {ServicoAlertaService} from 'app/core/ciee-notification/servico-alerta.service';
import {
  CompanyComplementaryData
} from 'app/core/ciee-company/company-complementary-data/company-complementary-data.model';
import {
  CompanyComplementaryDataService
} from 'app/core/ciee-company/company-complementary-data/company-complementary-data.service';
import {ActivityCiee} from '../../../core/ciee-company/activity-ciee/activity-ciee.model';
import {ActivityCieeService} from '../../../core/ciee-company/activity-ciee/activity-ciee.service';
import { catchError } from 'rxjs/operators/catchError';
import { of } from 'rxjs/observable/of';
import { CarteiraService } from 'app/core/ciee-admin/acompanhamento-vagas/carteira/carteira.service';
import { Carteira } from 'app/core/ciee-unit/instituicao-ensino-campus/instituicao-ensino-campus.services';

@Component({
  selector: 'app-company-contract-complementary-data-crud-box',
  templateUrl: './company-contract-complementary-data-crud-box.component.html',
  styleUrls: ['./company-contract-complementary-data-crud-box.component.scss'],
})
export class CompanyContractComplementaryDataCrudBoxComponent extends BaseComponent
  implements OnChanges {

  @Input() canEdit = true;
  @Input() isCompanyTypePublic = false;
  @Input() model: CompanyComplementaryData;

  @Output() save = new EventEmitter<CompanyComplementaryData>();
  @Output() editModeChange = new EventEmitter<boolean>();

  form: FormGroup;
  isSaving = false;
  showErrorMessage = false;
  showSuccessMessage = false;
  hasActivityData: boolean;
  carregandoAtividades = false;
  atividadesOpcoes: any = [];
  carteiraOpcoes: any = [];
  atividades: ActivityCiee[] = [];
  carteiras: Carteira[] = [];
  size = 20;

  readonly cityRegistrationMaxlength = COMPANY_CONTRACT_COMPLEMENTARY_DATA_CITY_REGISTRATION_MAXLENGTH;
  readonly stateRegistrationMaxlength = COMPANY_CONTRACT_COMPLEMENTARY_DATA_STATE_REGISTRATION_MAXLENGTH;
  readonly contractDescriptionMaxlength = COMPANY_CONTRACT_COMPLEMENTARY_CONTRACT_DESCRIPTION_MAXLENGTH;

  readonly patchParams: string[] = [
    'activity',
    'cityRegistration',
    'contractId',
    'multiCompany',
    'publicBodyClassification',
    'stateRegistration',
    'freeStateRegistration',
    'allowIndependentProfessional',
    'walletConsultant',
    'contractDescription',
  ];

  private _editMode = true;

  campoInscricaoEstadualDesabilitado: boolean;

  constructor(private formUtils: FormUtilsService,
              private servicoAlertaService: ServicoAlertaService,
              private formBuilder: CompanyContractComplementaryDataFormBuilder,
              private companyComplementaryDataService: CompanyComplementaryDataService,
              private activityCieeService: ActivityCieeService,
              private utilsService: UtilsService,
              private carteiraService: CarteiraService) {
    super()
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.model.firstChange) {
      this.hasActivityData = !!this.model.activity;
      if (this.model && this.model.activity && this.model.activity.description) {
        this.obterAtividades(this.model.activity.description);
      }
      if (this.model && this.model.walletConsultant && this.model.walletConsultant){
        this.buscarCarteiras(this.model.walletConsultant);
      }
    }

    if (changes.model || changes.isCompanyTypePublic) {
      this.buildForm();
    }

    if (changes.canEdit) {
      this.editMode = changes.canEdit.currentValue;
      if (this.model.activity && this.model.activity.description) {
        this.obterAtividades(this.model.activity.description);
      } else {
        this.obterAtividades();
      }
      if(this.model.walletConsultant && this.model.walletConsultant){
        this.buscarCarteiras(this.model.walletConsultant);
        } else {
          this.buscarCarteiras();
        }
    }

  }

  get editMode(): boolean {
    return this.canEdit && this._editMode;
  }

  set editMode(value: boolean) {
    this._editMode = this.canEdit && value;
  }

  onCancel(): void {
    this.buildForm();
    this.editMode = false;
  }

  onEditando(): void {
    this.editMode = true;
  }

  onConfirm(): void {
    if (this.isSaving) { return; }

    if (this.form.valid) {

      this.isSaving = true;
      const model = this.formBuilder.toModel(this.form);
      model.activity = this.buscarActivity(model.activity.id);

      const promise = model.id
        ? this.companyComplementaryDataService.atualizarParcial(model.id, model, this.patchParams)
        : this.companyComplementaryDataService.criar(model);

      promise.toPromise()
        .then(
          updatedModel => {
            this.servicoAlertaService.mostrarMensagemSucesso('Dados alterados com sucesso.');
            this.editModeChange.emit(true);
            this.save.emit(updatedModel);
            this.editMode = false;
          },
          err => {
            this.editMode = true;
            this.servicoAlertaService.mostrarMensagemErro(this.utilsService.parseErrorMessage(err));
          }
        ).then(() => {
          this.isSaving = false;
        });

    } else {
      this.servicoAlertaService.mostrarMensagemFormInvalido();
      this.formUtils.updateValueAndValidityAllControls(this.form);
    }
  }

  private buildForm(): void {
    const { isCompanyTypePublic } = this;
    this.form = this.model
      ? this.formBuilder.build(this.model, { isCompanyTypePublic })
      : null;
  }

  obterAtividades(texto: string = null): void {
    if (texto && texto.length >= 3 && this.editMode) {
      this.carregandoAtividades = true;
      this.sub.sink = this.activityCieeService.searchObservable({ description: texto })
        .delay(250)
        .subscribe((ativs: any) => {
          if (ativs && ativs.content) {
            this.atividades = ativs.content;
            this.atividadesOpcoes = ativs.content.map(ativ => {
              return {
                value: String(ativ.id),
                label: `${ativ.code} - ${ativ.description}`,
              }
            });
          }
          this.carregandoAtividades = false;
        }, err => {
          this.servicoAlertaService.mostrarMensagemErro(this.utilsService.parseErrorMessage(err));
          this.carregandoAtividades = false;
        });
    }
    if (!texto) {
      this.carregandoAtividades = true;
      this.sub.sink = this.activityCieeService.searchObservable({})
        .delay(250)
        .subscribe((ativs: any) => {
          if (ativs && ativs.content) {
            this.atividades = ativs.content;
            this.atividadesOpcoes = ativs.content.map(c => {
              return {
                value: String(c.id),
                label: `${c.code} - ${c.description}`
              }
            });
          }
          this.carregandoAtividades = false;
        }, err => {
          this.servicoAlertaService.mostrarMensagemErro(this.utilsService.parseErrorMessage(err));
          this.carregandoAtividades = false;
        });
    }
  }

  private buscarActivity(id: number): ActivityCiee {
    let atividade = null;
    this.atividades.filter(at => {
      if (at && at.id === id) {
        atividade = at;
      }
    })
    return atividade;
  }

  alteraSetorDescricao() {
    if (this.form && this.form.value.activity && this.atividades) {
      this.atividades.filter(at => {
        if (at && (at.id === Number(this.form.value.activity)
          || at.id === Number(this.form.value.activity.id))) {
          this.form.get('economicActivityDescription').setValue(at.description);
          this.form.get('economicSector').setValue(at.economicSector);
        }
      })
    }
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
    if(this.editMode && (listaCarteira !== [] || descricaoCarteira)){
    this.carteiraService.listarCarteiras(0, this.size, listaCarteira, descricaoCarteira)
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
        this.carteiraService.listarCarteiras(0,this.size,null)
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
  get contarCaracteres(): number {
    return (this.form.get('contractDescription').value || '').length;
  }

}

