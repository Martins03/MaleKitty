<template>
  <div class="dashboard">
    <h1>Seus Modelos</h1>

    <table v-if="models.length" class="models-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nome</th>
          <th>Acurácia</th>
          <th>Baixar</th>
          <th>Inferir</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="m in models" :key="m.id">
          <td>{{ m.id }}</td>
          <td>{{ m.model_name }}</td>
          <td>{{ formatPct(m.accuracy) }}</td>
          <td>
            <a :href="m.download_url" target="_blank">📥</a>
          </td>
          <td>
            <!-- Programmatic navigation to your infer page -->
            <button @click="goToInfer(m.id)">🔮</button>
          </td>
        </tr>
      </tbody>
    </table>

    <p v-else>Você ainda não treinou nenhum modelo.</p>

    <div class="actions">
      <button @click="$router.push('/train')">Treinar Novo</button>
      <button @click="logout">Sair</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'DashboardPage',
  data() {
    return {
      models: []
    }
  },
  async mounted() {
    const uid = localStorage.getItem('user_id')
    if (!uid) return this.$router.replace('/')
    try {
      const { data } = await axios.get('http://localhost:8000/modelos', {
        params: { user_id: uid }
      })
      this.models = data
    } catch (err) {
      console.error(err)
      alert('Não foi possível carregar seus modelos.')
    }
  },
  methods: {
    logout() {
      localStorage.clear()
      this.$router.replace('/')
    },
    formatPct(val) {
      return val != null
        ? (val * 100).toFixed(2) + '%'
        : '—'
    },
    goToInfer(modeloId) {
      // route must be defined, e.g. { path: '/infer/:id', name: 'ModelInfer' }
      this.$router.push({ name: 'ModelInfer', params: { id: modeloId } })
    }
  }
}
</script>

<style scoped>
.dashboard {
  max-width: 900px;
  margin: 2rem auto;
  padding: 1rem;
  background: #fff;
  border-radius: 6px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  text-align: center;
}
.models-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 1.5rem;
}
.models-table th,
.models-table td {
  border: 1px solid #ddd;
  padding: 0.6rem;
}
.models-table th {
  background: #f5f5f5;
}
.actions {
  margin-top: 1rem;
}
.actions button {
  margin: 0 0.5rem;
  padding: 0.6rem 1.2rem;
  background: #4caf50;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.actions button:hover {
  background: #45a049;
}
</style>
