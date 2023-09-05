$('#contato').change(function(){
    var valor = $('#social').val();
    console.log('oi');
    if (valor == "celular"){
      $('#phone').show(validandocel);
    }
    else {
      $('#fixed').hide(validandotel);
    }
  });


  function validandocel(){
let campo_celular = document.getElementById('number');

campo_celular.addEventListener("blur", function(e) {
   //Remove tudo o que não é dígito
   let celular = this.value.replace( /\D/g , "");

   if (celular.length==11){
    celular = celular.replace(/^(\d{2})(\d)/g,"($1) $2"); 
    resultado_celular = celular.replace(/(\d)(\d{4})$/,"$1-$2");
    document.getElementById('number').value = resultado_celular;
  } else {
    alert("Digite 11 números para celular");
  }
})
}

function validandotel(){
    let campo_telefone = document.getElementById('number');

campo_telefone.addEventListener("blur", function(e) {
   //Remove tudo o que não é dígito
   let telefone = this.value.replace( /\D/g , "");

   if (telefone.length==10){
    telefone = telefone.replace(/^(\d{2})(\d)/g,"($1) $2"); 
    resultado_telefone = telefone.replace(/(\d)(\d{4})$/,"$1-$2");
    document.getElementById('number').value = resultado_telefone;
  } else {
    alert("Digite 10 números para telefone");
  }
})
}
