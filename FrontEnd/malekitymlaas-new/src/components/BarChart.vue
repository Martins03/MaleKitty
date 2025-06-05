<template>
  <div class="chart-container">
    <canvas ref="chartCanvas"></canvas>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted, watch } from 'vue'
import Chart from 'chart.js/auto'

export default defineComponent({
  name: 'BarChart',
  props: {
    chartData: {
      type: Object,
      required: true
    },
    chartOptions: {
      type: Object,
      default: () => ({})
    }
  },
  setup(props) {
    const chartCanvas = ref(null)
    let chart = null

    // Função para criar ou atualizar o gráfico
    const renderChart = () => {
      if (chart) {
        chart.destroy()
      }

      if (chartCanvas.value) {
        const ctx = chartCanvas.value.getContext('2d')
        chart = new Chart(ctx, {
          type: 'bar',
          data: props.chartData,
          options: props.chartOptions
        })
      }
    }

    // Observa mudanças nos dados do gráfico
    watch(() => props.chartData, () => {
      renderChart()
    }, { deep: true })

    // Inicializa o gráfico quando o componente é montado
    onMounted(() => {
      renderChart()
    })

    return {
      chartCanvas
    }
  }
})
</script>

<style scoped>
.chart-container {
  position: relative;
  height: 400px;
  width: 100%;
}
</style>
