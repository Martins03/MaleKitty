<template>
    <div>
        <AppNavbar />
        <RouterView />
    </div>
    <div class="main-page">
      <header class="hero">
        <img :src="catImage" alt="Logo" class="logo" />
        <div class="hero-text">
          <h1>MaleKitty</h1>
          <h2>O seu portal de Machine Learning na Web</h2>
        </div>
      </header>
  
      <section class="intro">
        <div class="text-block">
          <h2>Machine Learning no MaleKitty</h2>
          <p>
            O MaleKitty é uma plataforma simples e poderosa para treinar modelos de machine learning
            diretamente no navegador. Sem configurações complexas ou instalações.
          </p>
        </div>
        <img :src="catImage" alt="Machine Learning" class="illustration" />
      </section>

      <section class="tools">
  <h2>Funcionalidades Disponíveis</h2>
  <div class="cards">
    <!-- Cartões com navegação -->
    <div class="card link-card" @click="$router.push('/dashboardpage')">
      <h3>➡ Ver Modelos</h3>
      <p>Acesse os modelos que treinou e descarregue os ficheiros .pt.</p>
    </div>
    <div class="card link-card" @click="$router.push('/train')">
      <h3>➡ Treinar Modelo</h3>
      <p>Carregue os seus dados e treine FNN ou DNN com poucos cliques.</p>
    </div>
    <div class="card link-card" @click="$router.push('/model-stats')">
      <h3>➡ Inferencia</h3>
      <p>Teste os seus modelos treinados com dados reais e obtenha previsões automáticas.</p>
    </div>
    <div class="card link-card" @click="$router.push('/model-stats')">
      <h3>➡ Estatísticas</h3>
      <p>Visualize as métricas dos modelos treinados (accuracy, F1, etc.).</p>
    </div>
  </div>
</section>

    </div>
  </template>
  
  <script setup>
    import catImage from '@/assets/cat_loader.png'
    import AppNavbar from './AppNavbar.vue'
  </script>
  
  <style scoped>
  .main-page {
    font-family: 'Segoe UI', sans-serif;
    background-color: #0b172a;
    color: white;
    padding-bottom: 2rem;
  }
  
  .hero {
    display: flex;
    align-items: center;
    padding: 3rem;
    background-color: #111d32;
    border-bottom: 1px solid #222;
  }
  
  .logo {
    width: 150px;
    margin-right: 2rem;
  }
  
  .hero-text h1 {
    font-size: 3rem;
    margin: 0;
  }
  
  .hero-text h2 {
    font-weight: 400;
    color: #ccc;
  }
  
  .login-button {
    display: inline-block;
    margin-top: 1rem;
    padding: 0.7rem 1.4rem;
    background-color: #1e90ff;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    transition: background-color 0.3s ease;
  }
  
  .login-button:hover {
    background-color: #0077cc;
  }
  
  .intro {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 3rem;
    flex-wrap: wrap;
  }
  
  .text-block {
    max-width: 500px;
  }
  
  .illustration {
    max-width: 400px;
    border-radius: 12px;
    margin-top: 1rem;
  }
  
  .tools {
    padding: 3rem;
    background: #0f223a;
  }
  
  .cards {
    display: flex;
    gap: 2rem;
    margin-top: 1rem;
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .card {
    background-color: #1c2b40;
    padding: 1.5rem;
    border-radius: 10px;
    flex: 1 1 250px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  }
  
  .card h3 {
    margin-top: 0;
    color: #00ccff;
  }
  
  .card p {
    color: #ddd;
  }
  </style>
  