<template>
  <div>
    <AppNavbar />
    <RouterView />
  </div>

  <div class="model-list">
    <h2>Modelos do Utilizador</h2>
    <ul v-if="modelos.length > 0">
      <li v-for="modelo in modelos" :key="modelo.id" class="modelo">
        <p><strong>Nome:</strong> {{ modelo.model_name }}</p>
        <p><strong>Descrição:</strong> {{ modelo.description || 'Sem descrição' }}</p>
        <p><strong>Ficheiro:</strong> {{ modelo.file_path }}</p>
        <button @click="selecionarModelo(modelo)">Usar este modelo</button>
        <hr />
      </li>
    </ul>
    <p v-else>Sem modelos encontrados.</p>
  </div>
</template>

<script setup>
import AppNavbar from './AppNavbar.vue';

</script>

<script>
import axios from 'axios';

export default {
  name: 'ModelList',
  data() {
    return {
      modelos: [],
      userId: 1  // ID de teste, pode vir de props ou sessão
    };
  },
  methods: {
    async carregarModelos() {
      try {
        const response = await axios.get(`http://127.0.0.1:8000/modelos`, {
          params: { user_id: this.userId }
        });
        this.modelos = response.data;
      } catch (error) {
        console.error('Erro ao carregar modelos:', error);
      }
    },
    selecionarModelo(modelo) {
      console.log('Selecionado:', modelo);
      // Aqui podes emitir evento para o parent ou guardar em store global
    }
  },
  mounted() {
    this.carregarModelos();
  }
};
</script>

<style scoped>
.model-list {
  padding: 1rem;
}
.modelo {
  margin-bottom: 1rem;
}
</style>
