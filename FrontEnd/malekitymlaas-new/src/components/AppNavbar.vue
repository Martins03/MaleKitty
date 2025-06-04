<template>
  <nav class="navbar">
    <div class="navbar-left">
      <RouterLink to="/male-kitty-page" :class="{ active: route.path === '/male-kitty-page' }">MaleKitty</RouterLink>
      <RouterLink to="/dashboardpage" :class="{ active: route.path === '/dashboardpage' }">Modelos</RouterLink>
      <RouterLink to="/train" :class="{ active: route.path === '/train' }">Treinar</RouterLink>
      <RouterLink to="/model-stats" :class="{ active: route.path === '/model-stats' }">Estatísticas</RouterLink>
    </div>

    <div class="navbar-right">
      <span class="username">{{ username }}</span>
      <button @click="logout">Logout</button>
    </div>
  </nav>
</template>

<script setup>
import { useRoute, useRouter } from 'vue-router'
import { ref, onMounted } from 'vue'

const route = useRoute()
const router = useRouter()
const username = ref("")

onMounted(() => {
  username.value = localStorage.getItem("username") || "Utilizador"
})

const logout = () => {
  localStorage.removeItem("username")
  localStorage.removeItem("user_id")
  router.push("/")
}
</script>

<style scoped>
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #111d32;
  padding: 1rem 2rem;
  font-family: 'Segoe UI', sans-serif;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.navbar-left,
.navbar-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.brand {
  font-size: 1.5rem;
  font-weight: bold;
  color: #00ccff;
  text-decoration: none;
  margin-right: 1.5rem;
}

a {
  color: white;
  text-decoration: none;
  padding: 0.5rem 0.8rem;
  border-radius: 4px;
  transition: background-color 0.3s;
}

a:hover:not(.active) {
  background-color: #1c2b40;
}

.active {
  background-color: #00ccff;
  color: #000;
}

.username {
  color: #ddd;
  font-weight: 500;
}

button {
  background-color: #c0392b;
  border: none;
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #e74c3c;
}
</style>
