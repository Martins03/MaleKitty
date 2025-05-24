<template>
  <div>
    <AppNavbar />
  </div>

  <div class="dashboard-page">
    <h1>Seus Modelos Treinados</h1>

    <table v-if="models.length" class="models-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nome</th>
          <th>Acurácia</th>
          <th>Download</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="m in models" :key="m.id">
          <td>{{ m.id }}</td>
          <td>{{ m.model_name }}</td>
          <td>{{ formatPct(m.accuracy) }}</td>
          <td>
            <a :href="m.download_url" target="_blank" class="download-icon">📥</a>
          </td>
        </tr>
      </tbody>
    </table>

    <p v-else class="no-models">Você ainda não treinou nenhum modelo.</p>
  </div>
</template>

<script setup>
import AppNavbar from './AppNavbar.vue'
</script>

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
    if (!uid) return this.$router.replace('/login')

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
    formatPct(val) {
      return val != null ? (val * 100).toFixed(2) + '%' : '—'
    }
  }
}
</script>

<style scoped>
.dashboard-page {
  max-width: 1000px;
  margin: 2rem auto;
  padding: 2rem;
  background-color: #0b172a;
  color: white;
  border-radius: 12px;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
  text-align: center;
  font-family: 'Segoe UI', sans-serif;
}

h1 {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  color: #1e90ff;
}

.models-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #1c2b40;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

.models-table th,
.models-table td {
  padding: 1rem;
  border: 1px solid #2e3e57;
}

.models-table th {
  background-color: #23344d;
  color: #00ccff;
}

.models-table td {
  color: #eee;
}

.download-icon {
  font-size: 1.4rem;
  color: #1e90ff;
  text-decoration: none;
}

.download-icon:hover {
  color: #00bfff;
}

.no-models {
  margin-top: 1rem;
  font-size: 1.1rem;
  color: #ccc;
}
</style>
