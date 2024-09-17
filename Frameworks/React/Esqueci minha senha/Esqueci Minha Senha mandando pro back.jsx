import React from 'react';
import './Criar.css'; // Certifique-se de que o CSS esteja ajustado para o novo layout
import { useForm, Controller } from 'react-hook-form';
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import Box from '@mui/material/Box';
import axios from 'axios';

const Criar = () => {
  const { control, handleSubmit } = useForm({
    defaultValues: {
      nome: '',
      email: '',
      senha: ''
    }
  });

  const onSubmit = async data => {
    try {
      // Envia os dados para o backend
      const response = await axios.post('https://seu-backend-url/api/criar', data);
      console.log('Resposta do backend:', response.data);
      // Adicione lógica para redirecionamento ou exibição de mensagem de sucesso
    } catch (error) {
      console.error('Erro ao enviar dados:', error);
      // Adicione lógica para exibir uma mensagem de erro
    }
  };

  return (
    <div className="criar">
      <Box
        sx={{
          backgroundImage: 'url(https://via.placeholder.com/1920x1080)',
          backgroundSize: 'cover',
          height: '100vh',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center'
        }}
      >
        <div className="form-container">
          <Box
            component="form"
            onSubmit={handleSubmit(onSubmit)}
            sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}
          >
            <Controller
              name="nome"
              control={control}
              render={({ field }) => (
                <TextField
                  {...field}
                  label="Nome"
                  variant="outlined"
                  fullWidth
                  margin="normal"
                />
              )}
            />
            <Controller
              name="email"
              control={control}
              render={({ field }) => (
                <TextField
                  {...field}
                  label="E-mail"
                  variant="outlined"
                  fullWidth
                  type="email"
                  margin="normal"
                />
              )}
            />
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
            <Box textAlign="center" marginTop={2}>
              <Button variant="contained" color="primary" type="submit">
                Criar Conta
              </Button>
            </Box>
          </Box>
          <div className="greeting">
            <div className="bem">Bem</div>
            <div className="vindo">Vindo!</div>
          </div>
        </div>
      </Box>
    </div>
  );
};

export default Criar;