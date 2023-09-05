let pessoa = ["Victor", "Lima", "Sena", "Hugo", "Victor"];
console.log(pessoa);

//push
pessoa.push(22);
console.log(pessoa);

//pop
pessoa.pop();
console.log(pessoa);

let excluido = pessoa.pop();
console.log(excluido);

//unshift
pessoa.unshift(21);
console.log(pessoa);

//shift
pessoa.shift();
console.log(pessoa);

//indexOf
console.log(pessoa.indexOf("21"));

//lastindexOf
console.log(pessoa.lastIndexOf("Victor"));

//join

console.log(pessoa.join("-"));
