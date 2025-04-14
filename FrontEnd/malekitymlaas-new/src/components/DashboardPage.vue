<template>
    <div class="dashboard">
      <h1>Bem-vindo ao Dashboard!</h1>
      <p>Esta é a página principal após o login.</p>
      <button @click="handleLogout">Sair</button>
      <!-- Botão para redirecionar para a página de treino -->
      <button @click="goToTrain">Treinar Novo Modelo</button>
    </div>
  </template>
    
  <script>
  export default {
    name: 'DashboardPage',
    methods: {
      handleLogout() {
        localStorage.removeItem('username')
        this.$router.push('/')
      },
      goToTrain() {
        this.$router.push('/train')
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
    margin: 0.5rem;
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
  