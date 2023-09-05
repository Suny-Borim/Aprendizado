/*nome social*/
$('#social').change(function(){
    var valor = $('#social').val();
    if (valor == "Sim"){
      $('#nome-social-js').show();
    }
    else {
      $('#nome-social-js').hide();
    }
  });
  
/*pcd*/
function mostra(id){
  if(document.getElementById(id).style.display == 'block'){
  document.getElementById(id).style.display = 'none';
  } else { 
  document.getElementById(id).style.display = 'block'; }
}
 //VALIDAÇÃO CELULAR
 // Celular
 let campo_celular = document.getElementById('number');
 campo_celular.addEventListener("blur", function(e) {
    //Remove tudo o que não é dígito
    let celular = this.value.replace( /\D/g , "");
    if (celular.length==11){
     celular = celular.replace(/^(\d{2})(\d)/g,"($1) $2");
     resultado_celular = celular.replace(/(\d)(\d{4})$/,"$1-$2");
     document.getElementById('number').value = resultado_celular;
   } else {
     alert("Digite 11 números para celular ou 10 número para telefone fixo");
   }
 })
 // VALIDAÇÃO CPF
let value_cpf = document.getElementById('input-cpf');
value_cpf.addEventListener("keydown", function(e) {
  if (e.key > "a" && e.key < "z") {
    e.preventDefault();
  }
});
value_cpf.addEventListener("blur", function(e) {
    //Remove tudo o que não é dígito
    let validar_cpf = this.value.replace( /\D/g , "");
    //verificação da quantidade números
    if (validar_cpf.length==11){
    // verificação de CPF valido
     var Soma;
     var Resto;
     Soma = 0;
     for (i=1; i<=9; i++) Soma = Soma + parseInt(validar_cpf.substring(i-1, i)) * (11 - i);
        Resto = (Soma * 10) % 11;
     if ((Resto == 10) || (Resto == 11))  Resto = 0;
     if (Resto != parseInt(validar_cpf.substring(9, 10)) ) return alert("CPF Inválido!");;
     Soma = 0;
     for (i = 1; i <= 10; i++) Soma = Soma + parseInt(validar_cpf.substring(i-1, i)) * (12 - i);
     Resto = (Soma * 10) % 11;
     if ((Resto == 10) || (Resto == 11))  Resto = 0;
     if (Resto != parseInt(validar_cpf.substring(10, 11) ) ) return alert("CPF Inválido!");;
     //formatação final
     cpf_final = validar_cpf.replace( /(\d{3})(\d)/ , "$1.$2");
     cpf_final = cpf_final.replace( /(\d{3})(\d)/ , "$1.$2");
     cpf_final = cpf_final.replace(/(\d{3})(\d{1,2})$/ , "$1-$2");
     document.getElementById('input-cpf').value = cpf_final;
    } else {
      alert("CPF Inválido! É esperado 11 dígitos numéricos.")
    }
//campo vermelho
function valida_form (){
  if(document.getElementById("input-nome").value.length < 3){
  alert('Por favor, preencha o campo nome');
  document.getElementById("input-nome").focus();
  return false
  }
  }
})