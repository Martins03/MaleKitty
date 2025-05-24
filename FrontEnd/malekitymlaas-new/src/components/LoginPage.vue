<template>
  <div class="login-page">
    <div class="login-card">
      <img :src="logo" alt="Logo MaleKitty" class="logo" />
      <h2>Bem-vindo ao MaleKitty</h2>
      <p class="subtitle">Faça login para treinar e testar os seus modelos.</p>
      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <label for="username">Utilizador</label>
          <input type="text" id="username" v-model="username" required />
        </div>
        <div class="form-group">
          <label for="password">Senha</label>
          <input type="password" id="password" v-model="password" required />
        </div>
        <button type="submit">Entrar</button>
      </form>
      <p v-if="message" class="error">{{ message }}</p>
      <p class="register-link">
        Não tem conta?
        <router-link to="/registerpage">Crie uma aqui</router-link>.
      </p>
    </div>
  </div>
</template>

<script>
import logo from '@/assets/cat_loader.png'
import axios from 'axios'

export default {
  name: 'LoginPage',
  data() {
    return {
      username: '',
      password: '',
      message: '',
      logo
    }
  },
  methods: {
    async handleLogin() {
      try {
        const resp = await axios.post('http://127.0.0.1:8000/login', {
          username: this.username,
          password: this.password
        })
        localStorage.setItem('username', resp.data.username)
        localStorage.setItem('user_id', resp.data.user_id)
        this.$router.push('/dashboardpage')
      } catch (err) {
        this.message = err.response?.data.detail || 'Erro no login'
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
  background-color: #0b172a;
}

.login-card {
  background-color: #1c2b40;
  color: white;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.4);
  width: 400px;
  text-align: center;
}

.logo {
  width: 100px;
  margin-bottom: 1rem;
}

h2 {
  font-size: 1.8rem;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #ccc;
  font-size: 0.95rem;
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1.2rem;
  text-align: left;
}

.form-group label {
  display: block;
  margin-bottom: 0.3rem;
  color: #ccc;
}

.form-group input {
  width: 100%;
  padding: 0.6rem;
  border: 1px solid #3a4a65;
  border-radius: 6px;
  background-color: #0b172a;
  color: white;
}

button {
  width: 100%;
  padding: 0.8rem;
  background-color: #1e90ff;
  border: none;
  color: white;
  font-size: 1rem;
  border-radius: 8px;
  cursor: pointer;
  margin-top: 0.5rem;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #0077cc;
}

.error {
  color: #ff5555;
  margin-top: 1rem;
}

.register-link {
  margin-top: 1rem;
  font-size: 0.9rem;
}

.register-link a {
  color: #1e90ff;
  text-decoration: none;
}

.register-link a:hover {
  text-decoration: underline;
}
</style>
