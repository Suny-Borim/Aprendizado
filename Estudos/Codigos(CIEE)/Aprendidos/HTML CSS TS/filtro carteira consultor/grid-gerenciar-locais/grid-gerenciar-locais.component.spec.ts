import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GridGerenciarLocaisComponent } from './grid-gerenciar-locais.component';

describe('GridGerenciarLocaisComponent', () => {
  let component: GridGerenciarLocaisComponent;
  let fixture: ComponentFixture<GridGerenciarLocaisComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ GridGerenciarLocaisComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(GridGerenciarLocaisComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
