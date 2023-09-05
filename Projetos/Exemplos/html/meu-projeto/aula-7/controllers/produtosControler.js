const produtoController = {
    criarProduto: (req,res)=> {
        res.send("Criando um produto")
    },
    deletarProduto: (req,res) => {
        const {id} = req.params;

        res.send("Deletando o produto com o id: " + id)
    
    }
}

module.exports = produtoController
