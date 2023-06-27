const express = require('express')
const server = express();
const filmes = require('./src/data/Filmes.json')

server.get('/cadastros',(req,res) => {
    return res.json({Usuarios: 'Suny'})
})
server.get('/filmes',(req,res) => {
    return res.json({filmes})
})
server.listen(3000, () => {
    console.log('Servidor online...')
});