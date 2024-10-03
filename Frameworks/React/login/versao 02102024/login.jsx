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
          <Controller
            name="email"
            control={control}
            rules={{
              required: 'Email é obrigatório',
              maxLength: {
                value: 50,
                message: 'O email não pode ter mais de 50 caracteres'
              },
              pattern: {
                value: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|com\.br)$/,
                message: 'O email deve conter "@" e "."' 
              }
            }}
            render={({ field, fieldState }) => (
              <TextField
                {...field}
                label="Email"
                variant="outlined"
                fullWidth
                type="email"
                margin="normal"
                className='campoEmail'
                error={!!fieldState.error}
                helperText={fieldState.error ? fieldState.error.message : null}
                inputProps={{ maxLength: 50 }} 
              />
            )}
          />
          <Controller
            name="senha"
            control={control}
            rules={{
              required: 'Senha é um campo obrigatório',
            }}
            render={({ field }) => (
              <TextField
                {...field}
                label="Senha"
                variant="outlined"
                type="password"
                fullWidth
                margin="normal"
                className='campoSenha'
              />
            )}
          />
          <Box >
            <Link to="/EsqueciSenha" className='link'> {}
              <Button  
                variant="contained" 
                color="primary" 
                sx={{ width: '300px', height: '60px', marginRight: '60px', backgroundColor: '#00A87A' }}>
                Esqueci minha Senha
              </Button>
            </Link>
            <Button  
              variant="contained" 
              color="primary" 
              onClick={handleSubmit(onSubmit)}
              sx={{ width: '300px', height: '60px', backgroundColor: '#860000' }}>
              Login
            </Button>
          </Box>
          Não tem uma conta? <Link to="/Criar" className='link'> {} Cadastre-se</Link>
      </div>
      <div className="logo">LOGO.</div>
    </div>
  );
};

export default Login;