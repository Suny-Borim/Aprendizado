import React from 'react';
import './Login.css';
import { Link } from 'react-router-dom';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import { useForm, Controller } from 'react-hook-form';
import Button from '@mui/material/Button';
import axios from 'axios';

const Login = () => {
  const { control, handleSubmit } = useForm({
    defaultValues: {
      email: '',
      senha: ''
    }
  });

  const onSubmit = async data => {
    try {
      const response = await axios.post('https://backend/api/login', {
        email: data.email,
        senha: data.senha
      });

      console.log('Resposta do backend:', response.data);

    } catch (error) {
      console.error('Erro ao enviar dados:', error.response ? error.response.data : error.message);
    }
  };

  return (
    <div className="login">
      <div className="rectangle22" />
      <div className="camposCriar">
        <div className="campoEmail">
          <Controller
            name="email"
            control={control}
            render={({ field }) => (
              <TextField
                {...field}
                label="Email"
                variant="outlined"
                fullWidth
                type="email"
                margin="normal"
              />
            )}
          />
        </div>
        <div className="campoSenha">
          <Controller
            name="senha"
            control={control}
            render={({ field }) => (
              <TextField
                {...field}
                label="Senha"
                variant="outlined"
                type="password"
                fullWidth
                margin="normal"
              />
            )}
          />
        </div>
      </div>
      <div className="loginEsqueci">
        <div className="rectangle18" />
        <div className="rectangle19" />
        <div className="loginText">Login</div>
        <div className="cadastreSeText">Cadastre-se</div>
        <div className="esqueciMinhaSenha">
          <Link to="/EsqueciSenha">Esqueci minha Senha</Link>
        </div>
      </div>
      <div className="logo">LOGO.</div>
      <div className="rectangle19Bottom" />
      <Box textAlign="center" marginTop={2}>
        <Button variant="contained" color="primary" onClick={handleSubmit(onSubmit)}>
          Login
        </Button>
      </Box>
    </div>
  );
};

export default Login;
