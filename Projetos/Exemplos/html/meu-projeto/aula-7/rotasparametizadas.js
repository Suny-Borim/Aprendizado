const express = required ('express');
const rotasProdutos = require('./rotas/rotasProdutos');

let app = express();

app.get('/produtos/:id?', (req,res) =>{
    let {id} = req.params;
    console.log("Eu tenho um produto com o id :", id)
});
 /* para a rota ser opcional, basta colocar "?" no final do id */

 app.use('/produtos', rotasProdutos);

app.listen(3000, ()=>console.log("Servidor rodando na porta 3000"));
