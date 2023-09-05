// crier o servidor 

/*const http = require ('http');

http.createServer( (req, res ) => {
    console.log("Meu primeiro servidor")
}).listen(3000);*/

// enviar uma mensagem/resposta para o servidor



const http = require ('http');

http.createServer( (req, res ) => {
    res.writeHead(200, {"Content-type":"text/plain"})
    res.end("Meu primeiro servidor    !");
}).listen(3000);


//Criar uma rota de resposta para o usuário caso ele digite coisas diferentes


const http = require ('http');

http.createServer( (req, res ) => {
    res.writeHead(200, {"Content-type":"text/plain"})
    
    switch(req.url){
        case "/":
            res.end("Você está na página home!")
            break;
            case "/contato":
            res.end("Você está na página contato!")
            break;
            default:
                res.end("Você está no nosso servidor!");
    }
}).listen(3000);