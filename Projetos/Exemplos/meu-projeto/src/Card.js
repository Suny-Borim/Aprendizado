import './Card.css'

function Card () {
    const user = {
        nome:'Victor',
        email:'victor@gmail.com',
        telefone:'xxxx-xxxx'
    }
    return (
        <section>
        <header>
        <h1>{user.nome}</h1>
        </header>
        <sectio>
            <h3>{user.email}</h3>
            <h3>{user.telefone}</h3>
        </sectio>
        </section>
    );
}

export default Card;



//Para importar este componente:
//import Card from 'Card.js';