<template>
    <div class="train-model">
      <h1>Treinar Modelo</h1>
      <form @submit.prevent="submitForm">
        <!-- Nome do Modelo -->
        <div class="form-group">
          <label for="modelName">Nome do Modelo:</label>
          <input type="text" id="modelName" v-model="form.model_name" required />
        </div>
        <!-- Descrição (opcional) -->
        <div class="form-group">
          <label for="description">Descrição:</label>
          <input type="text" id="description" v-model="form.description" placeholder="Descrição opcional" />
        </div>
        <!-- Seleção do arquivo CSV -->
        <div class="form-group">
          <label for="file">Selecione o CSV:</label>
          <input type="file" id="file" @change="handleFileUpload" accept=".csv" required />
        </div>
        <button type="submit">Enviar para Treinar</button>
      </form>
      <div v-if="responseMessage" class="response">
        <p>{{ responseMessage }}</p>
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
          description: ''
        },
        file: null,
        responseMessage: '',
        username: '' // Será obtido no mounted()
      }
    },
    mounted() {
      const storedUsername = localStorage.getItem('username')
      if (!storedUsername) {
        this.$router.push('/')
      } else {
        this.username = storedUsername
      }
    },
    methods: {
      handleFileUpload(event) {
        this.file = event.target.files[0]
      },
      async submitForm() {
        if (!this.file) {
          this.responseMessage = 'Por favor, selecione um arquivo CSV.'
          return
        }
    
        const formData = new FormData()
        formData.append('username', this.username)
        formData.append('model_name', this.form.model_name)
        formData.append('description', this.form.description)
        formData.append('file', this.file)
    
        try {
          const response = await axios.post('http://127.0.0.1:8000/upload_model', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
          })
          if (response.data.metrics) {
            localStorage.setItem('modelMetrics', JSON.stringify(response.data.metrics))
          }
          this.responseMessage = `Sucesso: ${response.data.message}. Model ID: ${response.data.model_id}`
          this.$router.push('/model-stats')
        } catch (error) {
          console.error(error)
          this.responseMessage = 'Erro ao treinar o modelo. Verifique o console para mais detalhes.'
        }
      }
    }
  }
  </script>
    
  <style scoped>
  .train-model {
    max-width: 500px;
    margin: 2rem auto;
    padding: 1rem;
    border: 1px solid #ccc;
    border-radius: 8px;
  }
  .form-group {
    margin-bottom: 1rem;
  }
  label {
    display: block;
    margin-bottom: 0.3rem;
  }
  input[type="text"],
  input[type="file"] {
    width: 100%;
    padding: 0.4rem;
    box-sizing: border-box;
  }
  button {
    padding: 0.5rem 1rem;
    background-color: #4caf50;
    border: none;
    color: #fff;
    border-radius: 4px;
    cursor: pointer;
  }
  button:hover {
    background-color: #45a049;
  }
  .response {
    margin-top: 1rem;
    font-weight: bold;
    color: #333;
  }
  </style>
  