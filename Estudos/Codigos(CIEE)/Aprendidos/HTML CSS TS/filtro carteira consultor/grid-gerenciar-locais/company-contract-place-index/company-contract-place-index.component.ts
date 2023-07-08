import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { BsModalRef, BsModalService } from 'ngx-bootstrap';

import { COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH } from 'app/admin/company-contract/company-contract-place/company-contract-place-crud-box/company-contract-place.form-builder';
import { AppValidators } from 'app/core/app-validators.model';
import { ConfiguracaoTicketService } from 'app/core/ciee-admin/configuracao-ticket/configuracao-ticket.service';
import { CieeAuthUserService } from 'app/core/ciee-auth/ciee-auth-user/ciee-auth-user.service';
import { CompanyContractInfo } from 'app/core/ciee-company/company-contract-info/company-contract-info.model';
import { COMPANY_CONTRACT_PLACE_STATUS, CompanyContractPlace, CompanyContractPlaceStatus } from 'app/core/ciee-company/company-contract-place/company-contract-place.model';
import { CompanyContractPlaceService } from 'app/core/ciee-company/company-contract-place/company-contract-place.service';
import { CompanyContract } from 'app/core/ciee-company/company-contract/company-contract.model';
import { CompanyContractService } from 'app/core/ciee-company/company-contract/company-contract.service';
import { NavigateService } from 'app/core/navigate.service';
import { Page } from 'app/core/page.model';
import { SessionService } from 'app/core/session/session.service';
import { CompanyContractMenuService } from 'app/core/utils/contract-menu.service';
import { MODAL_DEFAULT_CONFIG, UtilsService } from 'app/core/utils/utils.service';
import { ConfirmationModalComponent } from 'app/shared/components/confirmation-modal/confirmation-modal.component';
import { DataTablePageInfo } from 'app/shared/interfaces/data-table-page-info';
import { CnpjPipe } from 'app/shared/pipes/cnpj/cnpj.pipe';
import { CpfPipe } from 'app/shared/pipes/cpf.pipe';
import { ModalMensagemComponent } from 'app/ui/modal-mensagem/modal-mensagem/modal-mensagem.component';
import { ComponentPaginaPadrao } from 'app/ui/page/component-pagina-padrao';
import { SingleSelectOption } from 'app/ui/selects/single-select/single-select.component';
import { GridDataResult } from '@progress/kendo-angular-grid';

interface Row {
  id?: number;
  document: string;
  name: string;
  status: string;
  address: string;
  blocked: string;
  cieeUnitDescription: string;
  cieeUnitLocalDescription?: string;
  managementDescription: string;
  descricaoLocal: string;
  idCarteira: number;
  carteiraConsultor: number;
  descricaoCarteira: string;
  nomeAssistente: string;
}

interface CompanyContractPlaceStatusOption extends SingleSelectOption {
  value: CompanyContractPlaceStatus;
}

@Component({
  styleUrls: ['./company-contract-place.index.component.scss'],
  templateUrl: './company-contract-place-index.component.html'
})
export class CompanyContractPlaceIndexComponent extends ComponentPaginaPadrao implements OnInit {

  contract: CompanyContract;
  contractInfo: CompanyContractInfo;
  errorMessage = '';
  filters: FormGroup;
  isLoadingPlaces = false;
  isLoadingUser = false;
  isLoadingContract = false;
  page = new Page();
  gridData: GridDataResult;
  estaContratoAssinado = false;
  totalRegistros = 0;
  idContrato: number;

  private idUsuario: number;

  readonly addressMaxlength = 250;
  readonly documentMaxlength = 14;
  readonly nameMaxlength = COMPANY_CONTRACT_PLACE_NAME_MAXLENGTH;

  readonly messages = {
    emptyMessage: 'Não foram encontrados resultados para a pesquisa realizada.',
    totalMessage: 'registro(s)'
  };

  readonly statusOptions: CompanyContractPlaceStatusOption[] = [
    { label: COMPANY_CONTRACT_PLACE_STATUS['ACTIVE'], value: 'ACTIVE' },
    { label: COMPANY_CONTRACT_PLACE_STATUS['PENDENTE'], value: 'PENDENTE' }
  ];

  private places: CompanyContractPlace[] = [];

  private readonly cnpjPipe = new CnpjPipe();
  private readonly cpfPipe = new CpfPipe();
  private verificaConfiguracoesTicket = false;

  private modalRef: BsModalRef;
  private modalMensagem: BsModalRef;

  get podeDeletarLocaisDeContrato(): boolean {
    return this.totalRegistros > 1 && !this.estaContratoAssinado;
  }

  constructor(
    private companyContractPlaceService: CompanyContractPlaceService,
    private companyContractMenuService: CompanyContractMenuService,
    private companyContractService: CompanyContractService,
    private cieeAuthUserService: CieeAuthUserService,
    private modalService: BsModalService,
    private route: ActivatedRoute,
    private utils: UtilsService,
    private fb: FormBuilder,
    public navigateService: NavigateService,
    private sessionService: SessionService,
    private readonly configuracaoTicketService: ConfiguracaoTicketService,
  ) {
    super(modalService);

    this.sub.sink = this.companyContractService.verificaConfiguracoesTicket
      .subscribe(value => {
        this.verificaConfiguracoesTicket = Boolean(value);
      });
  }

  ngOnInit(): void {
    this.sub.sink = this.route.paramMap.subscribe((params: ParamMap) => {
      this.idContrato = +params.get('contractId');
      this.fetchContract(this.idContrato);
      this.mensagemAvisoConfiguracaoTicket();
      this.pegarDadosUsuario();

      if (this.verificaConfiguracoesTicket) {
        this.mensagemConfiguracaoTicket();
      }
    });
    this.sessionService.limparLocalAtual();
  }

  private pegarDadosUsuario() {
    this.isLoadingUser = true;

    this.sub.sink = this.cieeAuthUserService.findMe().subscribe(usuario => {
      this.idUsuario = usuario.id;
      this.isLoadingUser = false;
    });
  }

  cleanFilters(): void {
    this.buildFilters();
  }

  clearMessages(): void {
    this.errorMessage = '';
  }

  onRemove(row: Row): void {
    const modalRef = this.openConfirmationModal(
      'Exclusão local de contrato',
      'Tem certeza que deseja excluir o local de contrato?'
    );
    this.sub.sink = modalRef.content.confirm.subscribe(() => {
      this.removeContractPlaces(row);
    });

    this.sub.sink = modalRef.content.cancel.subscribe(() => {
    });
  }

  removeContractPlaces(row: Row): void {
    const place = this.places.find(p => p.id === row.id);

    this.companyContractPlaceService
      .remover(place.id)
      .toPromise()
      .then(() => {
        this.fetchPlaces();
      }, this.handleError.bind(this));
  }

  onSubmitFilters(event: Event): void {
    event.preventDefault();
    this.reset();
    this.fetchPlaces();
  }

  setPage(pageInfo: DataTablePageInfo): void {
    this.page.pageNumber = pageInfo.offset;
    this.fetchPlaces();
  }

  private buildFilters(): void {
    this.filters = this.fb.group({
      address: '',
      blocked: null,
      cieeUnitId: null,
      document: ['', AppValidators.number],
      managementId: null,
      name: '',
      status: null
    });
  }

  private fetchContract(id: number): void {
    this.isLoadingContract = true;

    this.companyContractService
      .buscarComFlagAssinatura(id)
      .subscribe(contratoComFlagAssinatura => {
        const contract = contratoComFlagAssinatura.contrato;
        this.companyContractMenuService.setCurrentContract(contract);
        this.contract = contract;
        this.contractInfo =
          contract &&
          contract.companiesContractInfo &&
          contract.companiesContractInfo;

        this.estaContratoAssinado =
          contratoComFlagAssinatura.estaContratoAssinado;

        this.buildFilters();
        this.fetchPlaces();
        this.isLoadingContract = false;
      }, this.handleError.bind(this));

    this.isLoadingContract = false;
  }

  fetchPlaces(filtros?): void {
    if (this.isLoadingPlaces) {
      return;
    }

    const searchParams = filtros ? {...this.searchParams, ...filtros} : this.searchParams;

    this.clearMessages();
    this.isLoadingPlaces = true;

    this.companyContractPlaceService
      .search(searchParams, this.page)
      .then(pagedData => {
        const { page, data } = pagedData;
        this.page = page
        this.places = this.companyContractPlaceService.mapEntityArray(data || []);

        this.gridData = {
          data: this.modelsToRows(this.places),
          total: this.page.totalElements
        }
      }, this.handleError.bind(this))
      .then(() => {
        this.setTotalRegistros();
        this.isLoadingPlaces = false;
      });
  }

  private async setTotalRegistros() {
    this.totalRegistros = await this.companyContractPlaceService.count(
      this.countParams
    );
  }

  private handleError(err: any): void {
    this.errorMessage = this.utils.parseErrorMessage(err);
  }

  private modelsToRows(models: CompanyContractPlace[]): Row[] {
    return models.map(m => this.modelToRow(m));
  }

  private modelToRow(model: CompanyContractPlace): Row {
    return {
      document: model.isLegalEntity
        ? this.cnpjPipe.transform(model.cnpj)
        : this.cpfPipe.transform(model.cpf),
      name: model.isLegalEntity ? model.companyName : model.name,
      status: COMPANY_CONTRACT_PLACE_STATUS[model.status],
      address: model.address,
      blocked: model.blocked ? 'Sim' : 'Não',
      cieeUnitDescription: model.cieeUnitDescription,
      cieeUnitLocalDescription: model.cieeUnitLocalDescription ? model.cieeUnitLocalDescription : null,
      managementDescription: model.managementDescription,
      id: model.id,
      descricaoLocal: model.descricaoLocal,
      carteiraConsultor: model.carteiraConsultor,
      idCarteira: model.idCarteira,
      descricaoCarteira: model.descricaoCarteira,
      nomeAssistente: model.nomeAssistente
    };
  }

  private reset(): void {
    this.page.pageNumber = 0;
  }

  private get searchParams(): PlainObject<any> {
    const { value } = this.filters;

    return this.utils.compact({
      address: value.address,
      blocked: value.blocked,
      cieeUnitId: value.cieeUnitId,
      contractId: this.contract.id,
      document: value.document,
      managementId: value.managementId,
      name: value.name,
      status: value.status,
      descricaoLocal:value.descricaoLocal,
      carteiraConsultor: value.carteiraConsultor
    });
  }

  private get countParams(): PlainObject<any> {
    return this.utils.compact({
      contractId: this.contract.id
    });
  }

  private openConfirmationModal(title: string, message: string): BsModalRef {
    const modalRef = this.modalService.show(ConfirmationModalComponent, MODAL_DEFAULT_CONFIG);
    modalRef.content.title = title;
    modalRef.content.message = message;

    return modalRef;
  }

  private mensagemAvisoConfiguracaoTicket() {
    this.sub.sink = this.configuracaoTicketService.obter({ idContrato: this.idContrato })
      .subscribe(config => {
        if (config.temLimiteTicket && config.temTicketLocalBloqueado) {
          this.showMensagem('Existem locais bloqueados com tickets parametrizados e disponíveis, por favor verifique');
        }
      });
  }

  showMensagem(mensagem: string) {
    this.modalMensagem = this.modalService.show(ModalMensagemComponent, {
      ...MODAL_DEFAULT_CONFIG,
      class: 'modal-centralizado',
      initialState: {
        texto: mensagem,
        fecharModal: () => {
          this.modalMensagem.hide();
        },
      },
    });
  }

  private mensagemConfiguracaoTicket() {
    this.sub.sink = this.configuracaoTicketService.obter({ idContrato: this.idContrato })
      .finally(() => this.companyContractService.verificaConfiguracoesTicket.next(false))
      .subscribe(config => {
        if (config.temLimiteTicket) {
          this.modalRef = this.modalService.show(ModalMensagemComponent, {
            class: 'modal-centralizado',
            ...MODAL_DEFAULT_CONFIG,
            initialState: {
              texto: 'O contrato tem limite de tickets (posições). Após cadastrar os locais de contrato necessários, informe os parâmetros no item "Tickets", para o correto funcionamento da parceria',
              icone: 'ciee-alert-circle',
              fecharModal: () => {
                this.modalRef.hide();
              },
            },
          });
        }
      });
  }
}
