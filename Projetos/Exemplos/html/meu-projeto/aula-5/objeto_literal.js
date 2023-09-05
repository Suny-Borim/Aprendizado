let carros = {
    nome:"Fox",
    Ano: 2015,
    cor: "Branco",
    Preco: "20000"
};

console.log(carros.nome + " " +"é o carro mais barato dentre o valor de: " + carros.Preco);

//metodos

let motos = {
    nome: "Honda",
    Ano: 2017,
    cor: "Roxa",
    Ligar: function (){
        console.log("A motoca"+ " "+ this.nome +" " + "está ligada")
    }
};

motos.Ligar();


//
function Carro(nomeCarro, anoCarro){
    this.nome = nomeCarro;
    this.ano = anoCarro;
};

let corolla = new Carro ("Corolla", 2021);
let cruze = new Carro("Cruze", 2016);

console.log(cruze);

console.log(corolla);



