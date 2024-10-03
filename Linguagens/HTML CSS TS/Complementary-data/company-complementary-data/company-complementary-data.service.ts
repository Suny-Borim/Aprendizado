
import { Injectable } from '@angular/core';
import { CompanyComplementaryData } from 'app/core/ciee-company/company-complementary-data/company-complementary-data.model';
import { SessionService } from 'app/core/session/session.service';
import { ToastrService } from 'ngx-toastr';
import { ServicoBase } from '../../servico-base.service';
import { HttpClient } from '@angular/common/http';


@Injectable()
export class CompanyComplementaryDataService
  extends ServicoBase<CompanyComplementaryData> {

  constructor(
    http: HttpClient,
    sessionService: SessionService,
    toastrService: ToastrService
  ) {
    super(
      '/company/complementary-data',
      http,
      sessionService,
      toastrService
    );
  }
}
