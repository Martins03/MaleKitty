<template>
    <div class="login-container">
      <h2>Login</h2>
      <form @submit.prevent="handleLogin">
        <div>
          <label for="username">Usuário:</label>
          <input type="text" id="username" v-model="username" required />
        </div>
        <div>
          <label for="password">Senha:</label>
          <input type="password" id="password" v-model="password" required />
        </div>
        <button type="submit">Entrar</button>
      </form>
      <p v-if="message">{{ message }}</p>
    </div>
  </template>
  
  <script>
  import axios from 'axios'
  
  export default {
    name: 'UserLogin',
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
          const response = await axios.post('http://127.0.0.1:8000/login', {
            username: this.username,
            password: this.password
          })
          this.message = response.data.message
        } catch (error) {
          this.message = error.response?.data.detail || 'Erro no login'
        }
      }
    }
  }
  </script>
  
  <style scoped>
  .login-container {
    max-width: 400px;
    margin: 2rem auto;
    padding: 2rem;
    border: 1px solid #ccc;
    border-radius: 4px;
  }
  .login-container div {
    margin-bottom: 1rem;
  }
  </style>
  