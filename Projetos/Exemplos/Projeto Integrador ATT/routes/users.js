var express = require('express');
var router = express.Router();
const multer = require('multer');
const UserController = require ('../controllers/UserController');
const validatorCadastro = require('../middleware/formValidator')
const { check, validationResult, body } = require('express-validator');


const storage = multer.diskStorage({
  destination (req, file, callback) {
    callback(null, 'public/images/uploads');
  },

  filename (req, file, callback) {
    const [filename, extension] = file.originalname.split('.');
    callback(null, filename + '-' + Date.now() + '.' + extension);
  }
});

const upload = multer({ storage });

// Criação  de Usuarios
router.post('/cadastrar',[
  check('nome')
    .notEmpty().withMessage('Campo nome é obrigatório!').bail()
    .isLength({ min: 3 }).withMessage('Campo nome precisa ter mais que 3 caracteres'),
  check('email')
    .notEmpty().withMessage('Campo email é obrigatório!').bail()
    .isEmail().withMessage('Campo valor precisa ser um número'),
  check('senha')
    .notEmpty().withMessage('Campo senha é obrigatório').bail()
    .isLength({ min: 3 }).withMessage('Campo senha precisa ter mais que 3 caracteres!')
], upload.single('arquivo')  , UserController.create);

// Atentificação
router.get('/login', UserController.login);
router.post('/login',validatorCadastro , UserController.autenticar);


module.exports = router;
