<template>
  <div class="register-page">
    <div class="register-card">
      <img :src="logo" alt="Logo MaleKitty" class="logo" />
      <h2>Criar Conta</h2>
      <p class="subtitle">Regista-te para começar a usar o MaleKitty.</p>
      <form @submit.prevent="handleRegister">
        <div class="form-group">
          <label for="username">Utilizador</label>
          <input type="text" id="username" v-model="username" required />
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" v-model="email" required />
        </div>
        <div class="form-group">
          <label for="password">Senha</label>
          <input type="password" id="password" v-model="password" required />
        </div>
        <button type="submit">Registrar</button>
      </form>
      <p v-if="message" class="error">{{ message }}</p>
      <p class="login-link">
        Já tem uma conta?
        <router-link to="/login">Faça login</router-link>.
      </p>
    </div>
  </div>
</template>

<script>
import logo from '@/assets/cat_loader.png'
import axios from 'axios'

export default {
  name: 'RegisterPage',
  data() {
    return {
      username: '',
      email: '',
      password: '',
      message: '',
      logo
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
        this.$router.push('/login')
      } catch (error) {
        this.message = error.response?.data.detail || 'Erro no registo'
      }
    }
  }
}
</script>

<style scoped>
.register-page {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #0b172a;
}

.register-card {
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
  margin-bottom: 0.3rem;
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
  background-color: #d7263d;
  border: none;
  color: white;
  font-size: 1rem;
  border-radius: 8px;
  cursor: pointer;
  margin-top: 0.5rem;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #b21f36;
}

.error {
  color: #ff5555;
  margin-top: 1rem;
}

.login-link {
  margin-top: 1rem;
  font-size: 0.9rem;
}

.login-link a {
  color: #1e90ff;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>
