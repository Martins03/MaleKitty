<template>
    <div class="register-container">
      <h2>Registro</h2>
      <form @submit.prevent="handleRegister">
        <div>
          <label for="username">Usuário:</label>
          <input type="text" id="username" v-model="username" required />
        </div>
        <div>
          <label for="email">Email:</label>
          <input type="email" id="email" v-model="email" required />
        </div>
        <div>
          <label for="password">Senha:</label>
          <input type="password" id="password" v-model="password" required />
        </div>
        <button type="submit">Registrar</button>
      </form>
      <p v-if="message">{{ message }}</p>
    </div>
  </template>
  
  <script>
  import axios from 'axios'
  
  export default {
    name: 'UserRegister',
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
          const response = await axios.post('http://127.0.0.1:8000/register', {
            username: this.username,
            email: this.email,
            password: this.password
          })
          this.message = response.data.message
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
  }
  .register-container div {
    margin-bottom: 1rem;
  }
  </style>
  