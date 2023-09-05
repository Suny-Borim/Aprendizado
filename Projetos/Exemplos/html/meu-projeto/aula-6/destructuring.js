// destruturação com objeto literal
let pessoa = {
    nome: "Victor",
    altura: 1.75,
    peso: 74.5,
    namora: true
};

let {nome, altura} = pessoa;

console.log(nome);
console.log(altura);

//destruturação com array

let timesBrasileirao = ["Corinthians", "São Paulo", "Galo", "Palmeiras", "Flamengo"];

const [item0, item1, item2] = timesBrasileirao;

console.log(item0);
console.log(item1);
console.log(item2);

