<template>
  <div>
    <AppNavbar />
    <RouterView />
  </div>

  <div class="train-model">
    <h1>Treinar Modelo</h1>
    <form @submit.prevent="submitForm">
      <!-- Nome do modelo -->
      <div class="form-group">
        <label for="modelName">Nome do Modelo:</label>
        <input id="modelName" v-model="form.model_name" required />
      </div>

      <!-- Descrição opcional -->
      <div class="form-group">
        <label for="description">Descrição (opcional):</label>
        <input id="description" v-model="form.description" />
      </div>

      <!-- Algoritmo -->
      <div class="form-group">
        <label for="algorithm">Algoritmo:</label>
        <select id="algorithm" v-model="form.algorithm">
          <option>FNN</option>
          <option>DNN</option>
        </select>
      </div>

      <!-- Upload CSV -->
      <div class="form-group">
        <label for="file">CSV de Treino:</label>
        <input
          id="file"
          type="file"
          @change="handleFileUpload"
          accept=".csv"
          required
        />
      </div>

      <!-- Coluna Alvo -->
      <div v-if="headers.length" class="form-group">
        <label for="labelCol">Coluna Alvo:</label>
        <select id="labelCol" v-model="form.label_col" required>
          <option value="" disabled>-- escolha a coluna --</option>
          <option v-for="col in headers" :key="col" :value="col">{{ col }}</option>
        </select>
      </div>

      <!-- Épocas -->
      <div class="form-group">
        <label for="epochs">Épocas:</label>
        <input
          id="epochs"
          type="number"
          v-model.number="form.max_epochs"
          min="1"
          required
        />
      </div>

      <button type="submit">Enviar para Treinar</button>
    </form>

    <!-- LOADING -->
    <div v-if="loading" class="loading-container">
      <img src="@/assets/cat_loader.png" alt="A treinar..." class="loader-image" />
      <p>A treinar modelo... Aguarde</p>
      <div class="progress-bar">
        <div class="bar"></div>
      </div>
    </div>

    <!-- RESPOSTA -->
    <div v-else-if="response" class="response">
      <p>{{ response.message }}</p>
      <ul>
        <li>Acurácia: {{ (response.accuracy * 100).toFixed(2) }}%</li>
        <li>Precisão: {{ (response.precision * 100).toFixed(2) }}%</li>
        <li>Recall: {{ (response.recall * 100).toFixed(2) }}%</li>
        <li>F1 Score: {{ (response.f1 * 100).toFixed(2) }}%</li>
        <li>Épocas Executadas: {{ response.epochs }}</li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import AppNavbar from './AppNavbar.vue'
</script>

<script>
import axios from 'axios'

export default {
  name: 'TrainModel',
  data() {
    return {
      form: {
        model_name: '',
        description: '',
        algorithm: 'FNN',
        label_col: '',
        max_epochs: 10
      },
      file: null,
      headers: [],
      response: null,
      loading: false,
      user_id: localStorage.getItem('user_id')
    }
  },
  methods: {
    handleFileUpload(e) {
      const f = e.target.files[0]
      this.file = f
      this.headers = []
      this.form.label_col = ''
      const reader = new FileReader()
      reader.onload = () => {
      const text = reader.result.split(/\r?\n/)[0]
      this.headers = text.includes(';') ? text.split(';') : text.split(',')
      this.headers = this.headers.map(h => h.trim())

      }
      reader.readAsText(f)
    },
    async submitForm() {
      if (!this.file || !this.form.label_col) return
      const fd = new FormData()
      fd.append('user_id', this.user_id)
      fd.append('model_name', this.form.model_name)
      fd.append('description', this.form.description)
      fd.append('algorithm', this.form.algorithm)
      fd.append('label_col', this.form.label_col)
      fd.append('max_epochs', this.form.max_epochs)
      fd.append('file', this.file)
      this.loading = true
      this.response = null
      try {
        const r = await axios.post('http://localhost:8000/treinar', fd, {
          headers: { 'Content-Type': 'multipart/form-data' }
        })
        this.response = r.data
      } catch (err) {
        console.error(err.response?.data || err)
        this.response = { message: 'Erro ao treinar. Veja o console.' }
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.train-model {
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

input[type="text"],
input[type="number"],
select,
input[type="file"] {
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
}

.response ul {
  margin-top: 0.5rem;
  padding-left: 1.2rem;
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

.loading-container p {
  color: #ccc;
  font-size: 1.1rem;
  margin-bottom: 1rem;
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
