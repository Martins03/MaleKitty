<template>
    <div class="dashboard">
      <h1>Bem-vindo ao Dashboard!</h1>
      <p>Esta é a página principal após o login.</p>
      <button @click="handleLogout">Sair</button>
    </div>
  </template>
  
  <script>
  export default {
    name: 'DashboardPage',
    methods: {
      handleLogout() {
        // Você pode limpar dados de sessão, token, etc. e redirecionar para a página de login
        this.$router.push('/')
      }
    }
  }
  </script>
  
  <style scoped>
  .dashboard {
    padding: 2rem;
    text-align: center;
  }
  button {
    padding: 0.5rem 1rem;
    background-color: #ff4d4d;
    border: none;
    color: #fff;
    border-radius: 4px;
    cursor: pointer;
  }
  button:hover {
    background-color: #e60000;
  }
  </style>
  