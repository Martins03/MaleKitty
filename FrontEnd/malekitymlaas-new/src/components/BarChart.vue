<script setup>
import { defineProps } from 'vue'
import { Bar } from 'vue-chartjs'
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
} from 'chart.js'

// Regista todos os itens que o Bar precisa
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

// Define as props que este wrapper vai receber
defineProps({
  chartData: { type: Object, required: true },
  chartOptions: { type: Object, default: () => ({}) }
})
</script>

<template>
  <!-- Aqui passamos exatamente as props que o vue-chartjs espera -->
  <Bar :chart-data="chartData" :chart-options="chartOptions" />
</template>
