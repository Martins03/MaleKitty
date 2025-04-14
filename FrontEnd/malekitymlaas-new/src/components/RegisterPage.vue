<template>
    <div class="register-container">
      <h2>Crie sua Conta</h2>
      <form @submit.prevent="handleRegister">
        <div class="form-group">
          <label for="username">Utilizador:</label>
          <input type="text" id="username" v-model="username" required />
        </div>
        <div class="form-group">
          <label for="email">Email:</label>
          <input type="email" id="email" v-model="email" required />
        </div>
        <div class="form-group">
          <label for="password">Senha:</label>
          <input type="password" id="password" v-model="password" required />
        </div>
        <button type="submit">Registrar</button>
      </form>
      <p v-if="message">{{ message }}</p>
      <p class="login-link">
        Já tem uma conta? <router-link to="/">Faça login</router-link>.
      </p>
    </div>
  </template>
    
  <script>
  import axios from 'axios'
  export default {
    name: 'RegisterPage',
    data() {
      return {
        username: '',
        email: '',
        password: '',
        message: ''
      }
    },
    methods: {
      async handleRegister() {
        try {
          await axios.post('http://127.0.0.1:8000/register', {
            username: this.username,
            email: this.email,
            password: this.password
          })
          this.$router.push('/')
        } catch (error) {
          this.message = error.response?.data.detail || 'Erro no registro'
        }
      }
    }
  }
  </script>
    
  <style scoped>
  .register-container {
    max-width: 400px;
    margin: 2rem auto;
    padding: 2rem;
    border: 1px solid #ccc;
    border-radius: 4px;
    background: #fff;
  }
  .register-container h2 {
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
    background-color: #d7263d;
    border: none;
    color: #fff;
    font-size: 1rem;
    border-radius: 4px;
    cursor: pointer;
  }
  button:hover {
    background-color: #b21f36;
  }
  .login-link {
    text-align: center;
    margin-top: 1rem;
  }
  .login-link a {
    color: #d7263d;
    text-decoration: none;
  }
  .login-link a:hover {
    text-decoration: underline;
  }
  .error {
    color: red;
    text-align: center;
    margin-top: 1rem;
  }
  </style>
  