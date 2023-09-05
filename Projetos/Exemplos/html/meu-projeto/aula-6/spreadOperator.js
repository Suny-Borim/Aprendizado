//Array
let frutas = ["Morango", "Maça", "Uva"];

let frutas2 = ["Banana", "Laranja", "Abacate"];

let listaCompleta = [...frutas, ...frutas2];

console.log(listaCompleta);

//objeto literal

let pessoa = {
    nome: "Jorge",
    idade: 25,
    altura: 1.79,
    peso: 68
}

let pessoa2 = {
    tel: 29939912,
    rg: 912001931,
    ...pessoa
};

console.log(pessoa2);


function letras(...paramns){
    console.log(paramns);
};

letras("a","b");







