<template>
  <div class="homepage">
    <header class="hero">
      <img :src="catImage" alt="Logo" class="logo" />
      <div class="hero-text">
        <h1>MaleKitty</h1>
        <h2>Machine Learning para Todos</h2>
        <router-link to="/login" class="login-button">Login</router-link>
      </div>
    </header>

    <section class="intro">
      <div class="text-block">
        <h2>Machine Learning no MaleKitty</h2>
        <p>
          O MaleKitty permite criar, treinar e utilizar modelos de Machine Learning diretamente no browser.
          A plataforma foi criada para ser simples, rápida e acessível a todos, sem necessidade de instalações complicadas.
        </p>
      </div>
      <img :src="catImage" alt="Machine Learning" class="illustration" />
    </section>

    <section class="tools">
      <h2>Ferramentas de Machine Learning</h2>
      <div class="cards">
        <div class="card">
          <h3>Feedforward Neural Network (FNN)</h3>
          <p>
            Ideal para problemas simples com dados tabulares. Rede direta sem ciclos.
          </p>
        </div>
        <div class="card">
          <h3>Deep Neural Network (DNN)</h3>
          <p>
            Perfeita para padrões mais complexos e maior profundidade de camadas.
          </p>
        </div>
        <div class="card">
          <h3>Inferência</h3>
          <p>
            Faça previsões com os modelos treinados, de forma rápida e segura na nuvem.
          </p>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import catImage from '@/assets/cat_loader.png'
</script>

<style scoped>
.homepage {
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
}

.cards {
  display: flex;
  gap: 2rem;
  margin-top: 1rem;
  flex-wrap: wrap;
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
