<template>
    <div class="model-stats">
      <h1>Estatísticas do Modelo</h1>
      <div v-if="chartData && chartData.labels && chartData.labels.length">
        <bar-chart :chart-data="chartData" :chart-options="chartOptions" />
      </div>
      <div v-else>
        <p>Carregando gráfico...</p>
      </div>
      <button @click="goBack">Voltar ao Dashboard</button>
    </div>
  </template>
    
  <script>
  import { Bar } from 'vue-chartjs'
  import { Chart, BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend } from 'chart.js'
  
  // Registra os elementos necessários do Chart.js
  Chart.register(BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend)
  
  export default {
    name: 'ModelStats',
    components: {
      BarChart: Bar
    },
    data() {
      return {
        chartData: {
          labels: ['Acurácia', 'Precisão', 'Recall', 'F1 Score'],
          datasets: [
            {
              label: 'Métricas do Modelo',
              backgroundColor: ['#42b983', '#ff6384', '#36a2eb', '#ffce56'],
              data: []
            }
          ]
        },
        chartOptions: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { position: 'top' },
            title: { display: true, text: 'Estatísticas do Modelo' }
          }
        }
      }
    },
    mounted() {
      const savedMetrics = localStorage.getItem('modelMetrics')
      if (savedMetrics) {
        const metrics = JSON.parse(savedMetrics)
        this.chartData.datasets[0].data = [
          metrics.accuracy,
          metrics.precision,
          metrics.recall,
          metrics.f1
        ]
      }
    },
    methods: {
      goBack() {
        this.$router.push('/dashboardpage')
      }
    }
  }
  </script>
    
  <style scoped>
  .model-stats {
    max-width: 600px;
    margin: 2rem auto;
    text-align: center;
    padding: 1rem;
  }
  button {
    margin-top: 1rem;
    padding: 0.5rem 1rem;
    background-color: #2575fc;
    border: none;
    color: #fff;
    border-radius: 4px;
    cursor: pointer;
  }
  </style>
  