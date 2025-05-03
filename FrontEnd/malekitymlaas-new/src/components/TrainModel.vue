<template>
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

      <!-- Upload e leitura de cabeçalhos -->
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

      <!-- Se já houver colunas lidas, mostra select para escolher label -->
      <div v-if="headers.length" class="form-group">
        <label for="labelCol">Coluna Alvo:</label>
        <select id="labelCol" v-model="form.label_col" required>
          <option value="" disabled>-- escolha a coluna --</option>
          <option v-for="col in headers" :key="col" :value="col">
            {{ col }}
          </option>
        </select>
      </div>

      <!-- Número de épocas -->
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

    <!-- Feedback de resposta -->
    <div v-if="response" class="response">
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
      headers: [],       // armazena nomes das colunas do CSV
      response: null,
      user_id: localStorage.getItem('user_id')
    }
  },
  methods: {
    handleFileUpload(e) {
      const f = e.target.files[0]
      this.file = f
      this.headers = []
      this.form.label_col = ''
      // Lê só a primeira linha do CSV para extrair cabeçalhos
      const reader = new FileReader()
      reader.onload = () => {
        const text = reader.result.split(/\r?\n/)[0]  // primeira linha
        this.headers = text.split(',').map(h => h.trim())
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

      try {
        const r = await axios.post(
          'http://localhost:8000/treinar',
          fd,
          { headers: { 'Content-Type': 'multipart/form-data' } }
        )
        this.response = r.data
      } catch (err) {
        console.error(err.response?.data || err)
        this.response = { message: 'Erro ao treinar. Veja o console.' }
      }
    }
  }
}
</script>

<style scoped>
.train-model {
  max-width: 500px;
  margin: 2rem auto;
  padding: 1.5rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: #fafafa;
}
.form-group {
  margin-bottom: 1rem;
}
label {
  display: block;
  margin-bottom: 0.3rem;
  font-weight: 500;
}
input[type="text"],
input[type="number"],
select,
input[type="file"] {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}
button {
  padding: 0.6rem 1.2rem;
  background-color: #4caf50;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
button:hover {
  background-color: #45a049;
}
.response {
  margin-top: 1.5rem;
  background: #eef;
  padding: 1rem;
  border-radius: 4px;
}
.response ul {
  margin: 0.5rem 0 0 1rem;
}
</style>
