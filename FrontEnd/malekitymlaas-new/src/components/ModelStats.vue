<template>
  <div class="model-stats">
    <h1>Estatísticas do Modelo</h1>

    <!-- Só renderiza quando tiver exatamente 4 valores em data -->
    <div v-if="datasets[0].data.length === labels.length">
      <BarChart
        :chart-data="{ labels, datasets }"
        :chart-options="chartOptions"
      />
    </div>
    <div v-else>
      <p>Carregando gráfico...</p>
    </div>

    <button @click="goBack">Voltar ao Dashboard</button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import BarChart from '@/components/BarChart.vue'

// 4 rótulos fixos
const labels = ['Acurácia', 'Precisão', 'Recall', 'F1 Score']

// datasets começa vazio (sem data)
const datasets = ref([
  {
    label: 'Métricas do Modelo',
    backgroundColor: ['#42b983', '#ff6384', '#36a2eb', '#ffce56'],
    data: []
  }
])

// opções do Chart.js
const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: 'top' },
    title: { display: true, text: 'Estatísticas do Modelo' }
  }
}

// Quando o componente monta, carrega métricas e preenche data
onMounted(() => {
  const saved = localStorage.getItem('modelMetrics')
  if (saved) {
    const m = JSON.parse(saved)
    datasets.value[0].data = [
      m.accuracy ?? 0,
      m.precision ?? 0,
      m.recall ?? 0,
      m.f1 ?? 0
    ]
  }
})

// Volta para trás
function goBack() {
  window.history.back()
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
