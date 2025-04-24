<template>
  <div class="train-model">
    <h1>Treinar Modelo</h1>
    <form @submit.prevent="submitForm">
      <div class="form-group">
        <label>Nome:</label>
        <input v-model="form.model_name" required />
      </div>
      <div class="form-group">
        <label>Descrição:</label>
        <input v-model="form.description" />
      </div>
      <div class="form-group">
        <label>Algoritmo:</label>
        <select v-model="form.algorithm">
          <option>FNN</option>
        </select>
      </div>
      <div class="form-group">
        <label>CSV:</label>
        <input type="file" @change="handleFileUpload" accept=".csv" required />
      </div>
      <button type="submit">Enviar</button>
    </form>
    <div v-if="response">
      <p>{{ response.message }}</p>
      <ul>
        <li>Acurácia: {{ (response.accuracy*100).toFixed(2) }}%</li>
        <li>Precisão: {{ (response.precision*100).toFixed(2) }}%</li>
        <li>Recall: {{ (response.recall*100).toFixed(2) }}%</li>
        <li>F1: {{ (response.f1*100).toFixed(2) }}%</li>
        <li>Épocas: {{ response.epochs }}</li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  data() {
    return {
      form: { model_name:'', description:'', algorithm:'FNN' },
      file: null,
      response: null,
      user_id: localStorage.getItem('user_id')
    }
  },
  methods: {
    handleFileUpload(e) { this.file = e.target.files[0] },
    async submitForm() {
      const fd = new FormData()
      fd.append('user_id', this.user_id)
      fd.append('model_name', this.form.model_name)
      fd.append('description', this.form.description||'')
      fd.append('algorithm', this.form.algorithm)
      fd.append('file', this.file)
      const r = await axios.post('http://localhost:8000/treinar', fd)
      this.response = r.data
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
