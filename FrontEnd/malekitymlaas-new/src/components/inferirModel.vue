<template>
  <div>
    <AppNavbar />
    <RouterView />
  </div>

  <div class="infer-model">
    <h1>Inferência de Modelo</h1>
    <form @submit.prevent="submitInference">
      <!-- Algoritmo -->
      <div class="form-group">
        <label for="algorithm">Tipo de Modelo:</label>
        <select id="algorithm" v-model="form.algorithm">
          <option value="fnn">FNN</option>
          <option value="dnn">DNN</option>
        </select>
      </div>

      <!-- Upload CSV -->
      <div class="form-group">
        <label for="file">CSV de Inferência:</label>
        <input
          id="file"
          type="file"
          @change="handleFileUpload"
          accept=".csv"
          required
        />
      </div>

      <button type="submit">Inferir</button>
    </form>

    <!-- LOADING -->
    <div v-if="loading" class="loading-container">
      <img src="@/assets/cat_loader.png" alt="A inferir..." class="loader-image" />
      <p>A processar inferência... Aguarde</p>
      <div class="progress-bar"><div class="bar"></div></div>
    </div>

    <!-- RESULTADO -->
    <div v-else-if="downloadUrl" class="response">
      <p>Inferência concluída com sucesso!</p>
      <a :href="downloadUrl" download="resultado_inferencia.csv">
        <button>📥 Fazer Download do Resultado</button>
      </a>
    </div>
  </div>
</template>

<script setup>
import AppNavbar from './AppNavbar.vue'
</script>

<script>
import axios from 'axios'

export default {
  name: 'InferModel',
  data() {
    return {
      form: {
        algorithm: 'fnn'
      },
      file: null,
      loading: false,
      downloadUrl: null
    }
  },
  methods: {
    handleFileUpload(e) {
      this.file = e.target.files[0]
    },
    async submitInference() {
      if (!this.file) return
      const fd = new FormData()
      fd.append('file', this.file)
      fd.append('algorithm', this.form.algorithm)
      this.loading = true
      this.downloadUrl = null
      try {
        const response = await axios.post('http://localhost:8000/inferir', fd, {
          responseType: 'blob',
          headers: { 'Content-Type': 'multipart/form-data' }
        })
        const blob = new Blob([response.data], { type: 'text/csv' })
        this.downloadUrl = URL.createObjectURL(blob)
      } catch (err) {
        console.error(err.response?.data || err)
        alert('Erro na inferência. Verifique o console.')
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.infer-model {
  max-width: 600px;
  margin: 2rem auto;
  padding: 2rem;
  background-color: #111d32;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.4);
  color: white;
  font-family: 'Segoe UI', sans-serif;
}

h1 {
  text-align: center;
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.3rem;
  font-weight: 500;
  color: #ccc;
}

input[type="file"],
select {
  width: 100%;
  padding: 0.6rem;
  background-color: #1c2b40;
  color: white;
  border: 1px solid #444;
  border-radius: 5px;
  box-sizing: border-box;
}

input::file-selector-button {
  background: #2575fc;
  border: none;
  padding: 0.5rem 1rem;
  color: white;
  cursor: pointer;
  border-radius: 4px;
}

button {
  width: 100%;
  padding: 0.75rem;
  background-color: #04AA6D;
  color: white;
  font-size: 1rem;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  margin-top: 1rem;
}

button:hover {
  background-color: #03975f;
}

.response {
  margin-top: 2rem;
  background: #1c2b40;
  padding: 1.5rem;
  border-radius: 8px;
  color: #eee;
  text-align: center;
}

.loading-container {
  text-align: center;
  margin-top: 2rem;
  background: #1c2b40;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  color: #ddd;
}

.loader-image {
  width: 100px;
  margin-bottom: 1rem;
  animation: pulse 1.5s infinite ease-in-out;
}

.progress-bar {
  width: 100%;
  height: 12px;
  background-color: #333;
  border-radius: 10px;
  overflow: hidden;
}

.bar {
  height: 100%;
  background-color: #04AA6D;
  animation: loadingAnim 1.5s infinite ease-in-out;
  transform: translateX(-100%);
}

@keyframes loadingAnim {
  0% { transform: translateX(-100%); }
  50% { transform: translateX(0); }
  100% { transform: translateX(100%); }
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.8; }
}
</style>
