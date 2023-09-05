let data = new Date();
//dia
console.log(data.getDate());


//dia da semana - Domingo = 0/Segunda = 1/Terça = 2/Quarta = 3/Quinta = 4/ Sexta= 5/Sábado = 6
console.log(data.getDay());

//mês - Janeiro = 0/ Fevereiro = 1/ Março = 2/.../Novembro = 10/Dezembro = 11
console.log(data.getMonth());

//Ano
console.log(data.getFullYear());

// ano/mes/dia
console.log(data);

//data específica

let data = new Date("2021-11-27");

console.log(data);
