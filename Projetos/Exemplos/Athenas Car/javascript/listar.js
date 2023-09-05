ler();

//Read- Ler
function ler() {
    fetch("http://localhost:8080/carro")
        .then(function (response) {
            let retorno = response.json()
            return retorno
        }).then(function (data) {
            data.forEach(element => {
                console.log(element.nome)
                let tabela = document.getElementById("tbody");
                let numeroLinhas = tbody.rows.length;
                let linha = tabela.insertRow(numeroLinhas);
                let celula1 = linha.insertCell(0);
                let celula2 = linha.insertCell(1);
                let celula3 = linha.insertCell(2);
                let celula4 = linha.insertCell(3);
                let celula5 = linha.insertCell(4);
                let celular6 = linha.insertCell(5);
                let celular7 = linha.insertCell(6);
                let celular8 = linha.insertCell(7);
                celula1.innerHTML = element.id;
                celula2.innerHTML = element.nome;
                celula3.innerHTML = element.ano_fabricacao;
                celula4.innerHTML = element.marca;
                celula5.innerHTML = element.cor;
                celular6.innerHTML = element.status_carro;
                celular7.innerHTML = "<a onclick = 'editar(this, " + element.id + ")'>Atualizar</a>"
                celular8.innerHTML = "<a onclick = 'deletar(this, " + element.id + ")'>Deletar</a>"
            });
        });
}

// Redirecionando páginas

function redirecionarPaginaEditar(id) {
    window.location.href = "comprar.html?id=" + id
}

// Delete - Deletar
function deletar(linha, id) {
    if (confirm("Você deseja excluir esse carro?")) {
        confirmacao(linha, id)
    }
}

//Função de confirmação de deleção
function confirmacao(linha, id) {
    var i = linha.parentNode.parentNode.rowIndex;
    document.getElementById('tbody').deleteRow(i);
    console.log(id)
    fetch("http://localhost:8080/carro/" + id, {
        method: 'DELETE',
    }).then((response) => {
        console.log(response.status)
        if (!response.ok) {
            throw new Error(`${response.status}`)
        }
        alert("Elemento excluido com sucesso")
        return response;
    })
        .catch((erro) => {
            alert('Erro ao excluir elemento')
        });
}

//Chamada de função editar
function editar(index, id) {
    redirecionarPaginaEditar(id)
}