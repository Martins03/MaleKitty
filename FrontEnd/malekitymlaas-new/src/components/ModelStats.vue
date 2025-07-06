<template>
  <div>
    <AppNavbar />

    <div class="model-stats">
      <h1>Resultados do Modelo</h1>

      <!-- Seleção de modelo -->
      <div class="form-group">
        <label for="model-select">Escolha um modelo:</label>
        <select
          id="model-select"
          v-model="selectedModelId"
          @change="fetchPlots"
        >
          <option value="" disabled>-- selecione --</option>
          <option
            v-for="m in models"
            :key="m.id"
            :value="m.id"
          >
            {{ m.model_name }} ({{ m.algorithm }})
          </option>
        </select>
      </div>

      <!-- Loading imagens -->
      <div v-if="loading" class="loading">
        Carregando resultados…
      </div>

      <!-- Grid de imagens -->
      <div v-else-if="hasImages" class="images-grid">
        <div
          v-for="(url, name) in plotUrls"
          :key="name"
          class="image-card"
          @click="openOverlay(url)"
        >
          <h3>{{ formatTitle(name) }}</h3>
          <img :src="url" :alt="name" />
        </div>
      </div>

      <!-- Sem imagens -->
      <div v-else-if="selectedModelId" class="no-images">
        Não há resultados em imagem para este modelo.
      </div>
    </div>

    <!-- Overlay full-screen -->
    <div v-if="overlayUrl" class="overlay" @click="closeOverlay">
      <img :src="overlayUrl" alt="Enlarged plot" />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import AppNavbar from '@/components/AppNavbar.vue'

const models = ref([])
const selectedModelId = ref('')
const plotUrls = ref({})
const loading = ref(false)

// estado do overlay
const overlayUrl = ref(null)

const hasImages = computed(() => Object.keys(plotUrls.value).length > 0)

async function loadModels() {
  loading.value = true
  try {
    const userId = localStorage.getItem('user_id')
    const res = await axios.get(`http://localhost:8000/modelos?user_id=${userId}`)
    models.value = res.data
  } catch (err) {
    console.error('Erro carregando modelos', err)
  } finally {
    loading.value = false
  }
}

async function fetchPlots() {
  if (!selectedModelId.value) return
  loading.value = true
  plotUrls.value = {}
  try {
    const res = await axios.get(`http://localhost:8000/modelos/${selectedModelId.value}`)
    plotUrls.value = res.data.history_plots || {}
  } catch (err) {
    console.error('Erro carregando imagens', err)
  } finally {
    loading.value = false
  }
}

function formatTitle(key) {
  return key
    .replace(/_/g, ' ')
    .replace(/\b\w/g, char => char.toUpperCase())
}

// abre o overlay com a imagem clicada
function openOverlay(url) {
  overlayUrl.value = url
}
// fecha o overlay
function closeOverlay() {
  overlayUrl.value = null
}

onMounted(loadModels)
</script>

<style scoped>
.model-stats {
  max-width: 800px;
  margin: 2rem auto;
  padding: 1rem;
  text-align: center;
}

.form-group {
  margin-bottom: 1.5rem;
  text-align: left;
  max-width: 400px;
  margin: 0 auto;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.form-group select {
  width: 100%;
  padding: 0.5rem;
  border-radius: 4px;
  border: 1px solid #ccc;
}

.loading {
  font-style: italic;
  color: #666;
  margin: 1rem 0;
}

.images-grid {
  display: grid;
  /* Miniaturas mínimas aumentadas para 300px */
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1rem;
  margin-top: 2rem;
}

.image-card {
  border: 1px solid #ddd;
  border-radius: 6px;
  padding: 0.5rem;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}
.image-card:hover {
  transform: scale(1.03);
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
}

.image-card h3 {
  font-size: 1rem;
  margin-bottom: 0.5rem;
}

.image-card img {
  width: 100%;
  /* altura mínima para dar destaque */
  min-height: 220px;
  object-fit: cover;
  border-radius: 4px;
}

/* Overlay full screen */
.overlay {
  position: fixed;
  top: 0; 
  left: 0;
  width: 100vw; 
  height: 100vh;
  background: rgba(0,0,0,0.85);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  z-index: 1000;
}
.overlay img {
  /* ocupa até 95% da tela */
  max-width: 95vw;
  max-height: 95vh;
  border-radius: 6px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.5);
}

.no-images {
  color: #999;
  margin-top: 2rem;
}
</style>
