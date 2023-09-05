
recuperarValores();
const formulario = document.querySelector('#formulario');
const nomeCarro = document.getElementById('namecar');
const anoFabricacao = document.getElementById('fabricacao');
const marca = document.querySelector('#marca');
const cor = document.getElementById('cor');
const statusCar = document.getElementById('status')

//Validação de campos
function validaCampo(valor) {
    return valor != null && valor != "";
}

//Create - Cadastrar
function cadastrar() {
    console.log(nomeCarro.value)
    if (validaCampo(nomeCarro.value) && validaCampo(anoFabricacao.value) && validaCampo(cor.value) && validaCampo(statusCar.value) && validaCampo(marca.value)) {
        const urlParams = new URLSearchParams(window.location.search);
        const valorId = urlParams.get('id');
        console.log(valorId);

        if (valorId != null) {
            update(valorId);
        } else {
            fetch("http://localhost:8080/carro",
                {
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    method: 'POST',
                    body: JSON.stringify({
                        nome: nomeCarro.value,
                        ano_fabricacao: anoFabricacao.value,
                        cor: cor.value,
                        status_carro: statusCar.value,
                        marca: marca.value
                    })

                })
                .then(function () {
                    alert('Veículo cadastrado com sucesso')
                    window.location.href = 'listar.html'
                })
                .catch(function (res) { console.log(res) })
        }
    } else {
        alert('Erro ao cadastrar veículo')
    }
}

//Redirecionando páginas
function redirecionar() {
    window.location.href = "listar.html"
}

//Redirecionando páginas
function redirecionarPrincipal() {
    window.location.href = "paginainicial.html"
}

//Exibir ID na URL
function recuperarValores() {

    const urlParams = new URLSearchParams(window.location.search);
    const valorId = urlParams.get('id');
    console.log(valorId);

    if (valorId != null) {
        fetch("http://localhost:8080/carro/" + valorId)
            .then(function (response) {
                let retorno = response.json()
                return retorno
            }).then(function (data) {
                document.getElementById('namecar').value = data.nome
                document.getElementById('fabricacao').value = data.ano_fabricacao
                document.getElementById('cor').value = data.cor
                document.getElementById('status').value = data.status_carro
                document.getElementById('marca').value = data.marca

            });
    }


}
//Update- Modificar/alterar
function update(id) {

    fetch("http://localhost:8080/carro/" + id,
        {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'PUT',
            body: JSON.stringify({
                nome: nomeCarro.value,
                ano_fabricacao: anoFabricacao.value,
                cor: cor.value,
                status_carro: statusCar.value,
                marca: marca.value
            })

        })
        .then(function () {
            alert('Veículo alterado com sucesso')
            window.location.href = 'listar.html'
        })
        .catch(function (res) { console.log(res) })

}

