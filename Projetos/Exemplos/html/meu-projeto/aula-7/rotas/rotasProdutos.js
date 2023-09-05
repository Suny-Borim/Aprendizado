const express = require ('express');
const produtoController = require ('../controllers/produtosControler')

const router = express.Router();

router.get('/criar', produtoController.criarProduto);
router.get('/deletar', produtoController.deletarProduto);


module.exports = routerno
