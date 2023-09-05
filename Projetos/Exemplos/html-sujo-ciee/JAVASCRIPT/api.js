const cpf = document.getElementById('input-cpf');
const nameCompleto = document.getElementById('input-nome');
const nameSocial = document.getElementById('social');
const sexo = document.getElementById('escolha-sexo');
const data = document.getElementById('dataa');
const estadoCivil = document.getElementById('estadocivill');
const email = document.getElementById('email');
const numberTyp = document.getElementById('escolha-number')
const number = document.getElementById('number');
const cep = document.getElementById('input-cep');
const cidade = document.getElementById('input-cidade');
const uf = document.getElementById('input-uf');
const numeroHouse = document.getElementById('input-numero');
const logradouro = document.getElementById('input-logradouro');
const bairroHouse = document.getElementById('input-bairro')
const complementoHouse = document.getElementById('input-complemento')
const infoPCD = document.getElementById('tabs');


function cadastrar () {
    fetch("http://localhost:8080/api/ciee/estudante",
                {
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    method: 'POST',
                    body: JSON.stringify(
                        {
                            cpf: cpf.value,
                            nome_completo: nameCompleto.value,
                            nome_social: nameSocial.value,
                            sexo: sexo.value,
                            data_nascimento: data.value,
                            estado_civil: estadoCivil.value,
                            situacao: true,
                            enderecoEstudante: {
                                cep: cep.value,
                                cidade: cidade.value,
                                uf: uf.value,
                                logradouro: logradouro.value,
                                numero: numeroHouse.value,
                                bairro: bairroHouse.value,
                                complemento: complementoHouse.value
                            },
                            telefoneEstudante: {
                                tipo_numero: numberTyp.value,
                                numero: number.value,
                                principal: true
                            },
                            emailEstudante: {
                                email: email.value,
                                principal: true
                            }


                    })

                })
                .then(function () {
                    alert('estudante cadastrado com sucesso')
                   /* window.location.href = 'listar.html'*/
                })
                .catch(function (res) { console.log(res) })
        }