// Parametrização do canvas
const sprites = new Image();
sprites.src = 'images/personagemTemp.png';

const canvas = document.querySelector('canvas');
const contexto = canvas.getContext('2d');

//funções 

mainloop();

function mainloop() {
    contexto.drawImage(
        drawImage(
            // imagem ou sprite a ser utilizado
            sprites, 
            // posição do sprite em relação a imagem a ser utilizada 
            0, 0, 
            // tamanho do corte da imagem  
            60, 60, 
            0, 60, 
            // tamanho da imagem dentro da tela
            60, 60)
    )
requestAnimationFrame(mainloop);
}
