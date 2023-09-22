const readline = require('readline');
const fs = require('fs');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let listaDeTextosRomanticos = [];

// Função para carregar os textos românticos do arquivo JSON
function carregarTextosRomanticos() {
  try {
    const data = fs.readFileSync('db.json', 'utf8');
    const db = JSON.parse(data);
    listaDeTextosRomanticos = db.textosRomanticos;
  } catch (error) {
    console.error('Erro ao carregar os textos românticos:', error);
  }
}

// Função para salvar os textos românticos no arquivo JSON
function salvarTextosRomanticos() {
  try {
    const db = { textosRomanticos: listaDeTextosRomanticos };
    const data = JSON.stringify(db, null, 2);
    fs.writeFileSync('db.json', data, 'utf8');
  } catch (error) {
    console.error('Erro ao salvar os textos românticos:', error);
  }
}

// Carregar textos românticos do arquivo ao iniciar o programa
carregarTextosRomanticos();

function listarTextosRomanticos() {
  console.log('Textos Românticos:');
  listaDeTextosRomanticos.forEach((texto) => {
    console.log(`ID: ${texto.ID}, Nome: ${texto.Nome}\nTexto: ${texto.Texto}\nTítulo: ${texto.Titulo}\nApaixonada: ${texto.Apaixonada}\n`);
  });
}

function adicionarTextoRomantico() {
  rl.question('Digite o Nome: ', (nome) => {
    rl.question('Digite o Título: ', (titulo) => {
      rl.question('Digite a Apaixonada: ', (apaixonada) => {
        rl.question('Digite o Texto Romântico: ', (texto) => {
          const novoID = listaDeTextosRomanticos.length + 1;
          const novoTextoRomantico = {
            ID: novoID,
            Nome: nome,
            Texto: texto,
            Titulo: titulo,
            Apaixonada: apaixonada,
          };
          listaDeTextosRomanticos.push(novoTextoRomantico);
          salvarTextosRomanticos(); // Salva os textos no arquivo JSON
          console.log(`Texto romântico adicionado com sucesso! (ID: ${novoID})\n`);
          listarTextosRomanticos();
          showMenu();
        });
      });
    });
  });
}

function removerTextoRomantico() {
  rl.question('Digite o ID do texto romântico a ser removido: ', (id) => {
    const index = listaDeTextosRomanticos.findIndex((texto) => texto.ID == id);
    if (index !== -1) {
      const removido = listaDeTextosRomanticos.splice(index, 1);
      salvarTextosRomanticos(); // Salva os textos atualizados no arquivo JSON
      console.log(`Texto romântico removido com sucesso:\n${JSON.stringify(removido[0])}\n`);
    } else {
      console.log('Texto romântico não encontrado com o ID especificado.\n');
    }
    listarTextosRomanticos();
    showMenu();
  });
}

function showMenu() {
  console.log('\nOpções:');
  console.log('1. Listar Textos Românticos');
  console.log('2. Adicionar Texto Romântico');
  console.log('3. Remover Texto Romântico');
  console.log('4. Sair');
  rl.question('Escolha uma opção: ', (option) => {
    switch (option) {
      case '1':
        listarTextosRomanticos();
        showMenu();
        break;
      case '2':
        adicionarTextoRomantico();
        break;
      case '3':
        removerTextoRomantico();
        break;
      case '4':
        rl.close();
        break;
      default:
        console.log('Opção inválida.');
        showMenu();
        break;
    }
  });
}

console.log('Bem-vindo ao CRUD de Textos Românticos!\n');
showMenu();

rl.on('close', () => {
  console.log('Encerrando aplicação.');
  process.exit(0);
});