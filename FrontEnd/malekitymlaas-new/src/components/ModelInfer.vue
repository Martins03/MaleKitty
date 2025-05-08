<template>
    <div class="infer-model">
      <h1>Inferência: {{ model && model.model_name }}</h1>
      <p v-if="model">Acurácia: {{ formatPct(model.accuracy) }}</p>
      <p v-else-if="error" class="error">{{ error }}</p>
  
      <form v-if="model" @submit.prevent="handleInfer">
        <div v-for="i in model.n_features" :key="i" class="form-group">
          <label :for="`f${i}`">Feature {{ i }}</label>
          <input
            :id="`f${i}`"
            v-model.number="inputs[i - 1]"
            type="number"
            step="any"
            required
          />
        </div>
        <button type="submit">Inferir</button>
      </form>
  
      <p v-if="result !== null" class="result">
        Predição: {{ result }}
      </p>
    </div>
  </template>
  
  <script>
  import axios from 'axios'
  
  export default {
    name: 'ModelInfer',
    data() {
      return {
        model: null,
        inputs: [],
        result: null,
        error: null
      }
    },
    async mounted() {
      const id = this.$route.params.id
      try {
        const resp = await axios.get(`http://localhost:8000/modelos/${id}`)
        this.model = resp.data
        this.inputs = Array(this.model.n_features).fill(0)
      } catch (e) {
        console.error(e)
        this.error = 'Não foi possível carregar o modelo.'
      }
    },
    methods: {
      formatPct(v) {
        return v != null ? (v * 100).toFixed(2) + '%' : '—'
      },
      async handleInfer() {
        this.error = null
        this.result = null
        try {
          const resp = await axios.post(
            'http://localhost:8000/inferir',
            {
              modelo_id: this.model.id,
              input_data: this.inputs
            }
          )
          this.result = resp.data.resultado.join(', ')
        } catch (e) {
          console.error(e)
          this.error = 'Erro na inferência.'
        }
      }
    }
  }
  </script>
  
  <style scoped>
  .infer-model {
    max-width: 500px;
    margin: 2rem auto;
    padding: 1.5rem;
    background: #fafafa;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  }
  .form-group {
    margin-bottom: 1rem;
  }
  label {
    display: block;
    margin-bottom: 0.2rem;
    font-weight: 500;
  }
  input {
    width: 100%;
    padding: 0.4rem;
    border: 1px solid #ccc;
    border-radius: 4px;
  }
  button {
    margin-top: 1rem;
    padding: 0.6rem 1.2rem;
    background: #4caf50;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  button:hover {
    background: #45a049;
  }
  .result {
    margin-top: 1.5rem;
    padding: 1rem;
    background: #eef;
    border-radius: 4px;
  }
  .error {
    margin-top: 1rem;
    color: #c00;
    font-weight: bold;
  }
  </style>
  