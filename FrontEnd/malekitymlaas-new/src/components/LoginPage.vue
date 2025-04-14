<template>
    <div class="login-page">
      <div class="login-card">
        <h2>Login</h2>
        <form @submit.prevent="handleLogin">
          <div class="form-group">
            <label for="username">Utilizador</label>
            <input
              type="text"
              id="username"
              v-model="username"
              placeholder="Digite seu utilizador"
              required
            />
          </div>
          <div class="form-group">
            <label for="password">Senha</label>
            <input
              type="password"
              id="password"
              v-model="password"
              placeholder="Digite sua senha"
              required
            />
          </div>
          <button type="submit">Entrar</button>
        </form>
        <p v-if="message" class="error">{{ message }}</p>
        <!-- Link para criar conta -->
        <p class="register-link">
          Não tem conta? <router-link to="/registerpage">Crie uma aqui</router-link>.
        </p>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios'
  export default {
    name: 'LoginPage',
    data() {
      return {
        username: '',
        password: '',
        message: ''
      }
    },
    methods: {
      async handleLogin() {
        try {
          await axios.post('http://127.0.0.1:8000/login', {
            username: this.username,
            password: this.password
          })
          // Armazena o username no localStorage
          localStorage.setItem('username', this.username)
          // Redireciona para o Dashboard
          this.$router.push('/dashboardpage')
        } catch (error) {
          this.message = error.response?.data.detail || 'Erro no login'
        }
      }
    }
  }
  </script>
  
  <style scoped>
  .login-page {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background: linear-gradient(to right, #6a11cb, #2575fc);
  }
  .login-card {
    background-color: #fff;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    width: 350px;
  }
  .login-card h2 {
    text-align: center;
    margin-bottom: 1.5rem;
  }
  .form-group {
    margin-bottom: 1rem;
  }
  .form-group label {
    display: block;
    margin-bottom: 0.5rem;
  }
  .form-group input {
    width: 100%;
    padding: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 4px;
  }
  button {
    width: 100%;
    padding: 0.75rem;
    background-color: #2575fc;
    border: none;
    color: #fff;
    font-size: 1rem;
    border-radius: 4px;
    cursor: pointer;
  }
  button:hover {
    background-color: #1a5bb8;
  }
  .error {
    color: red;
    text-align: center;
    margin-top: 1rem;
  }
  .register-link {
    text-align: center;
    margin-top: 1rem;
  }
  .register-link a {
    color: #2575fc;
    text-decoration: none;
  }
  .register-link a:hover {
    text-decoration: underline;
  }
  </style>
  