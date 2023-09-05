//if ternário

let dia = "segunda-feira";

let resultado = dia == "domingo"? "Vou a praia":"Fico em casa";

console.log(resultado);


//switch

switch(dia){
    case "segunda": 
    console.log("Irei acordar cedo");
    break;
    case "quarta-feira":
        console.log("Estarei ausente, terei aula");
        break;
        default:
            console.log("Irei aproveita o fim de semana!");
        
}

//exercício playgraund

let semana = "sábado";

function fimDeSemana(semana){
    switch(semana){
        case "segunda-feira":
            console.log("você tem aulas!");
                    break;
            case "quarta-feira":
                console.log("você tem aulas!");
                    break;
                case "sexta-feira":
                    console.log("você tem aulas!");
                    break;
                    default:
                        console.log("você não tem aula");
    }
}

