//for in
let pessoa = {
    nome: "Victor",
    idade: 21,
    altura: 1.75,
};

// para saber os dados que possui na chave, como nome e idade
for(let caracteristica in pessoa){
    console.log(caracteristica);
}


// para saber as chave ({}) e as informações(respostas)
for(let caracteristica in pessoa){
    console.log(pessoa[caracteristica])
};



