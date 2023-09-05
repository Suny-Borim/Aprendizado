// VALIDAÇÃO CPF
let value_cpf = document.getElementById('input-cpf');

value_cpf.addEventListener("keydown", function (e) {
  if (e.key > "a" && e.key < "z") {
    e.preventDefault();
  }
});
value_cpf.addEventListener("blur", function (e) {
  //Remove tudo o que não é dígito
  let validar_cpf = this.value.replace(/\D/g, "");

  //verificação da quantidade números
  if (validar_cpf.length == 11) {

    // verificação de CPF valido
    var Soma;
    var Resto;

    Soma = 0;
    for (i = 1; i <= 9; i++) Soma = Soma + parseInt(validar_cpf.substring(i - 1, i)) * (11 - i);
    Resto = (Soma * 10) % 11;

    if ((Resto == 10) || (Resto == 11)) Resto = 0;
    if (Resto != parseInt(validar_cpf.substring(9, 10))) return alert("CPF Inválido!");;

    Soma = 0;
    for (i = 1; i <= 10; i++) Soma = Soma + parseInt(validar_cpf.substring(i - 1, i)) * (12 - i);
    Resto = (Soma * 10) % 11;

    if ((Resto == 10) || (Resto == 11)) Resto = 0;
    if (Resto != parseInt(validar_cpf.substring(10, 11))) return alert("CPF Inválido!");;

    //formatação final
    cpf_final = validar_cpf.replace(/(\d{3})(\d)/, "$1.$2");
    cpf_final = cpf_final.replace(/(\d{3})(\d)/, "$1.$2");
    cpf_final = cpf_final.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
    document.getElementById('input-cpf').value = cpf_final;

  } else {
    alert("CPF Inválido! É esperado 11 dígitos numéricos.")
  }

})

//VALIDAÇÃO CELULAR

// Celular
$('#contato').change(function () {
  var valor = $('#social').val();
  if (valor === "Celular") {
    $('#phone').show(validandocel);
  }
  else {
    $('#fixed').hide(validandotel);
  }
});


function validandotel() {
  let campo_telefone = document.getElementById('number');

  campo_telefone.addEventListener("click", function (e) {
    //Remove tudo o que não é dígito
    let telefone = this.value.replace(/\D/g, "");

    const numberTyp = document.getElementById('contatoPutaria').value



    if (numberTyp == 'fixed') {
      if (telefone.length == 10) {
        telefone = telefone.replace(/^(\d{2})(\d)/g, "($1) $2");
        resultado_telefone = telefone.replace(/(\d)(\d{4})$/, "$1-$2");
        document.getElementById('number').value = resultado_telefone;
      } else {
        alert("Digite 10 números para telefone");
      }
    } else if (numberTyp == 'phone') {
      if (telefone.length == 11) {
        telefone = telefone.replace(/^(\d{2})(\d)/g, "($1) $2");
        resultado_telefone = telefone.replace(/(\d)(\d{4})$/, "$1-$2");
        document.getElementById('number').value = resultado_telefone;
      } else {
        alert("Digite 11 números para celular");
      }
    }


  })
}


//TABS PCD
$(function () {
  $("#tabs").tabs();
});


//Data
function validacao() {


  let data = document.querySelector('#datee');

  let erro = false;

  dataAtual = new Date();

  data = new Date(data);

  if (data > dataAtual) {
    alert("Data inválida, você não pode ter nascido hoje ou no futuro!");
  }
}


let value_data = document.getElementById('dataa');

value_data.addEventListener("blur", function (e) {


  dateString = document.getElementById('dataa').value
  niver = new Date(dateString);
  idade = Math.floor((Date.now() - niver) / (31557600000));
  if (idade < 14) {
    alert('Você tem que ter 14 anos ou mais')
  }



  let data = document.querySelector('#dataa').value;

  let erro = false;

  dataAtual = new Date();


  data = new Date(data);

  if (data > dataAtual) {
    alert("Data inválida, você não pode ter nascido hoje ou no futuro!");

  }
});


function mudaCor(pcd){
  if(pcd){
  document.getElementById('idli1').style.backgroundColor = "white";
  document.getElementById('idli2').style.backgroundColor = "#808080";
  }else  {
  document.getElementById('idli2').style.backgroundColor = "white";
  document.getElementById('idli1').style.backgroundColor = "#808080";
  }
  }


