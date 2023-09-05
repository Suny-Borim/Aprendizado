const somar = (numeroA, numeroB)=> numeroA + numeroB;

const calculadora = (numeroA, numeroB, operacao) => operacao(numeroA, numeroB);

console.log(calculadora(10,20,somar));


function somaUm(n){
    return n+1;
};

function mostrarSoma (callback,numero){
    console.log(callback(numero))
};


mostrarSoma (somaUm, 3);


//Calculadora
function adicao(n1, n2){
    return n1 + n2;
}

function subtracao(n1, n2){
    return n1 - n2;
}

function multiplicacao(n1, n2){
    return n1 * n2;
}

function exibir(n1, n2, funcao){
    console.log(funcao(n1,n2));
}


exibir(10, 5, adicao);

exibir(10, 5, subtracao);

exibir(10, 5, multiplicacao);

//Concatenação
function nome(){
    return "Victor"
};

function discurso(callback){
    return "Olá meu amigo" +" " + callback()
};

console.log(discurso(nome));

