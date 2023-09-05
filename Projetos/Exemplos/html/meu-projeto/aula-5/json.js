
//Objeto Literal
let victor = {
    nome: "Victor",
    idade: 21,
    altura: 1.75
};

let json =  JSON.stringify(victor);

console.log(json);


let objetoDeNovo = JSON.parse(json);

console.log(objetoDeNovo);

//Array
let frutas = ["Melancia", "Mamão", "Abacate", "Morango"];

let jsonAtualizado = JSON.stringify(frutas);

console.log(jsonAtualizado);

console.log(jsonAtualizado[0]);


let arrayDeNovo = JSON.parse(jsonAtualizado);

console.log(arrayDeNovo);


//Importar arquivo .json para arquivo .js

const estados =  require("./NOMEDOARQUIVO.json");

console.log(estados);

//transformar .json em string js
const stringEstados =  JSON.stringify;
console.log(stringEstados);

//transformar string js em .json
const jsonEstados = JSON.parse;
console.log(jsonEstados);





