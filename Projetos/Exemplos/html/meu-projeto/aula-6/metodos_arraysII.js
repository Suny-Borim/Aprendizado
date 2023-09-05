let numerosPares = [2,4,6,8,10];

//map()

let numeroParesDobro = numerosPares.map(function(valor){
    return (valor*2)
});

console.log(numeroParesDobro)

//filter

let numeroFiltrados = numerosPares.filter(function(valor){
    return valor>=6;
});

console.log(numeroFiltrados);

//reduce

let somaNumeros = numerosPares.reduce(function(acum, valor){
    return acum + valor;
});

console.log(somaNumeros);

//forEach

numerosPares.forEach(function(valor, indice){
    console.log("O indice" + " " + indice + " "+ "tem o valor: " +valor)
});


