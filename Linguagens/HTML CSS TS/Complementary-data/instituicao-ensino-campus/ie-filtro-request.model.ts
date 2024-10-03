export interface IeFiltroAttributes {
    code?: number;
    name?: string;
    fullAddress?: string;
    neighborhood? :string;
    cityOrState?: string
    active?: string;
  }

export class IECampusFiltro implements IeFiltroAttributes {
    code?: number;
    name?: string;
    fullAddress?: string;
    neighborhood? :string;
    cityOrState?: string
    active?: string;

    constructor(attributes: IeFiltroAttributes = {}) {
        this.code = attributes.code;
        this.name = attributes.name;
        this.fullAddress = attributes.fullAddress;
        this.neighborhood = attributes.neighborhood;
        this.cityOrState = attributes.cityOrState;
        this.active = attributes.active;
    }
}