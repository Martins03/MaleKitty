<template>
  <div>
    <AppNavbar />
  </div>

  <div class="dashboard-page">
    <h1>Os Seus Modelos Treinados</h1>

    <table v-if="models.length" class="models-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nome</th>
          <th>Acurácia</th>
          <th>Inferência</th>
          <th>Eliminar</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="m in models" :key="m.id">
          <td>{{ m.id }}</td>
          <td>{{ m.model_name }}</td>
          <td>{{ formatPct(m.accuracy) }}</td>
          <td>
            <div class="infer-action">
              <input
                type="file"
                class="infer-input"
                @change="e => handleFileSelect(m.id, e)"
                accept=".csv"
              />
              <button
                v-if="selectedFiles[m.id]"
                class="infer-button"
                @click="inferModel(m.id)"
              >
                Inferir
              </button>
            </div>
          </td>
          <td>
            <button class="delete-button" @click="deleteModel(m.id)">
              Eliminar
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <p v-else class="no-models">
      Ainda não treinou nenhum modelo.
    </p>
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
      models: [],
      selectedFiles: {}
    }
  },
  async mounted() {
    const uid = localStorage.getItem('user_id')
    if (!uid) {
      this.$router.replace('/login')
      return
    }

    try {
      const { data } = await axios.get('http://localhost:8000/modelos', {
        params: { user_id: uid }
      })
      this.models = data
    } catch (err) {
      console.error(err)
      alert('Não foi possível carregar os seus modelos.')
    }
  },
  methods: {
    formatPct(val) {
      return val != null ? (val * 100).toFixed(2) + '%' : '—'
    },
    handleFileSelect(modelId, event) {
      const file = event.target.files[0]
      if (file) {
        this.selectedFiles[modelId] = file
      }
    },
    async inferModel(modelId) {
      const file = this.selectedFiles[modelId]
      if (!file) {
        alert("Selecione um ficheiro antes de inferir.")
        return
      }

      const fd = new FormData()
      fd.append('file', file)
      fd.append('model_id', modelId)

      try {
        const res = await axios.post('http://localhost:8000/inferir_modelo', fd, {
          responseType: 'blob'
        })

        const blob = new Blob([res.data], { type: 'text/csv' })
        const url = URL.createObjectURL(blob)

        const a = document.createElement('a')
        a.href = url
        a.download = `resultado_modelo_${modelId}.csv`
        a.click()
        URL.revokeObjectURL(url)
      } catch (err) {
        console.error(err.response?.data || err)
        alert('Erro na inferência.')
      }
    },
    async deleteModel(modelId) {
      const uid = localStorage.getItem('user_id')
      if (!uid) {
        alert('Não autenticado.')
        return
      }

      if (!confirm(`Tem a certeza que quer eliminar o modelo #${modelId}?`)) {
        return
      }

      try {
        // Supondo que o endpoint DELETE existe em /modelos/{modelo_id}
        await axios.delete(`http://localhost:8000/modelos/${modelId}`, {
          params: { user_id: uid }
        })

        // Remove da lista local
        this.models = this.models.filter(m => m.id !== modelId)
      } catch (err) {
        console.error(err)
        alert('Erro ao eliminar o modelo.')
      }
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

.infer-action {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.infer-input {
  color: #ccc;
  background-color: #1c2b40;
  border: 1px solid #444;
  border-radius: 5px;
  padding: 0.4rem;
  max-width: 220px;
  flex-shrink: 0;
}

.infer-button {
  background-color: #1e90ff;
  color: white;
  padding: 0.45rem 0.9rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}
.infer-button:hover {
  background-color: #007acc;
}

.delete-button {
  background-color: #ff4c4c;
  color: white;
  padding: 0.45rem 0.9rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}
.delete-button:hover {
  background-color: #e53939;
}

.no-models {
  margin-top: 1rem;
  font-size: 1.1rem;
  color: #ccc;
}
</style>
