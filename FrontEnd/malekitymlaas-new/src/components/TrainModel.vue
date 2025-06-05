<template>
  <div>
    <AppNavbar />
    <RouterView />
  </div>

  <div class="train-model">
    <h1>Treinar Modelo</h1>
    <form @submit.prevent="submitForm">
      <!-- Tarefa -->
      <div class="form-group">
        <label for="task">Tarefa:</label>
        <select id="task" v-model="form.task">
          <option value="classification">Classificação</option>
          <option value="regression">Regressão</option>
        </select>
      </div>

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

      <!-- NOVA SECÇÃO: Modo de Configuração da Rede (apenas para DNN) -->
      <div v-if="form.algorithm === 'DNN'">
        <div class="form-group">
          <label for="networkMode">Configuração da Rede:</label>
          <select id="networkMode" v-model="form.network_mode">
            <option value="auto">Automático (Regra dos 2/3)</option>
            <option value="advanced">Avançado (Manual)</option>
          </select>
          <div class="help-text" v-if="form.network_mode === 'auto'">
            A regra dos 2/3 calcula automaticamente o número ideal de neurónios por camada.
          </div>
        </div>

        <!-- Opções avançadas (visíveis apenas se modo avançado selecionado e algoritmo DNN) -->
        <div v-if="form.network_mode === 'advanced'" class="advanced-options">
          <div class="form-group">
            <label for="hiddenLayers">Número de Camadas Ocultas:</label>
            <input
              id="hiddenLayers"
              type="number"
              v-model.number="form.hidden_layers"
              min="1"
              max="10"
              required
            />
            <div class="help-text">
              Para redes DNN, recomenda-se 2-6 camadas.
            </div>
          </div>

          <div class="form-group">
            <label for="neuronsPerLayer">Neurónios por Camada:</label>
            <input
              id="neuronsPerLayer"
              v-model="form.neurons_per_layer"
              placeholder="Ex: 64,32,16"
              required
            />
            <div class="help-text">
              Insira o número de neurónios para cada camada, separados por vírgula.
              O número de valores deve ser igual ao número de camadas ocultas.
            </div>
          </div>
        </div>
      </div>

      <!-- Upload CSV -->
      <div class="form-group">
        <label for="file">CSV de Treino:</label>
        <input
          id="file"
          type="file"
          @change="handleFileUpload"
          accept=".csv,.xlsx,.xls"
          required
        />
        <div class="help-text">
          Formatos suportados: CSV, Excel (.xlsx, .xls)
        </div>
      </div>

      <!-- NOVA SECÇÃO: Seleção de Colunas (Features e Target) -->
      <div v-if="headers.length" class="column-selection">
        <h3>Seleção de Colunas</h3>
        
        <!-- Seleção de Features (variáveis independentes) -->
        <div class="form-group">
          <label for="featureColumns">Colunas de Features (variáveis independentes):</label>
          <div class="columns-container">
            <div 
              v-for="col in headers" 
              :key="col" 
              class="column-checkbox"
              :class="{ 'selected-as-target': form.label_col === col }"
            >
              <input 
                type="checkbox" 
                :id="'feature_' + col" 
                :value="col" 
                v-model="form.feature_cols"
                :disabled="form.label_col === col"
              />
              <label :for="'feature_' + col">{{ col }}</label>
            </div>
          </div>
          <div class="help-text">
            Selecione as colunas que deseja usar como features (variáveis independentes).
            <span v-if="form.feature_cols.length > 0">
              {{ form.feature_cols.length }} colunas selecionadas.
            </span>
          </div>
          <div class="action-buttons">
            <button type="button" class="secondary-button" @click="selectAllFeatures">Selecionar Todas</button>
            <button type="button" class="secondary-button" @click="deselectAllFeatures">Desselecionar Todas</button>
          </div>
        </div>

        <!-- Coluna Alvo (Target) -->
        <div class="form-group">
          <label for="labelCol">Coluna Alvo (variável dependente):</label>
          <select id="labelCol" v-model="form.label_col" required>
            <option value="" disabled>-- escolha a coluna --</option>
            <option v-for="col in headers" :key="col" :value="col">{{ col }}</option>
          </select>
          <div class="help-text">
            Selecione a coluna que deseja prever (variável dependente).
          </div>
        </div>
      </div>

      <!-- Épocas -->
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

      <button type="submit" :disabled="!isFormValid">Enviar para Treinar</button>
      <div v-if="!isFormValid" class="validation-message">
        Por favor, preencha todos os campos obrigatórios e selecione pelo menos uma coluna de feature.
      </div>
    </form>

    <!-- LOADING -->
    <div v-if="loading" class="loading-container">
      <img src="@/assets/cat_loader.png" alt="A treinar..." class="loader-image" />
      <p>A treinar modelo... Aguarde</p>
      <div class="progress-bar">
        <div class="bar"></div>
      </div>
    </div>

    <!-- Resposta -->
    <div v-else-if="response" class="response">
      <!-- Erro -->
      <div v-if="response.error" class="error">
        <p>{{ response.message }}</p>
        
      </div>
      

      <!-- Sucesso -->
      <div v-else>
        <p>{{ response.message }}</p>
        <ul>
          <template v-if="form.task === 'classification'">
            <li v-if="response.accuracy != null">
              Acurácia: {{ (response.accuracy * 100).toFixed(2) }}%
            </li>
            <li v-if="response.precision != null">
              Precisão: {{ (response.precision * 100).toFixed(2) }}%
            </li>
            <li v-if="response.recall != null">
              Recall: {{ (response.recall * 100).toFixed(2) }}%
            </li>
            <li v-if="response.f1 != null">
              F1 Score: {{ (response.f1 * 100).toFixed(2) }}%
            </li>
          </template>
          <template v-else>
            <li v-if="response.mse != null">
              MSE: {{ response.mse.toFixed(4) }}
            </li>
            <li v-if="response.mae != null">
              MAE: {{ response.mae.toFixed(4) }}
            </li>
            <li v-if="response.r2_score != null">
              R² Score: {{ response.r2_score.toFixed(4) }}
            </li>
          </template>
          <li v-if="response.epochs != null">
            Épocas Executadas: {{ response.epochs }}
          </li>
        </ul>
      </div>
    </div>
  </div>
  
</template>

<script setup>
import AppNavbar from './AppNavbar.vue'
</script>

<script>
import axios from 'axios'
export default {
  name: 'TrainModel',
  data() {
    return {
      form: {
        task: 'classification',
        model_name: '',
        description: '',
        algorithm: 'FNN',
        label_col: '',
        max_epochs: 10,
        // Novos campos para configuração da rede
        network_mode: 'auto',
        hidden_layers: 1,
        neurons_per_layer: '',
        // Novo campo para seleção de features
        feature_cols: []
      },
      file: null,
      headers: [],
      response: null,
      loading: false,
      user_id: localStorage.getItem('user_id')
    }
  },
  computed: {
    isFormValid() {
      return this.form.model_name && 
             this.file && 
             this.form.label_col && 
             this.form.feature_cols.length > 0 &&
             this.validateNeuronsPerLayer(false);
    }
  },
  methods: {
    handleFileUpload(e) {
      const f = e.target.files[0]
      this.file = f
      this.headers = []
      this.form.label_col = ''
      this.form.feature_cols = []
      
      if (!f) return;
      
      const reader = new FileReader()
      reader.onload = () => {
        // Verifica se é um arquivo Excel (.xlsx, .xls)
        if (f.name.endsWith('.xlsx') || f.name.endsWith('.xls')) {
          // Para arquivos Excel, precisamos usar uma biblioteca como SheetJS
          // Mas como não podemos adicionar novas dependências, informamos ao usuário
          alert('Formato Excel detectado. Por favor, salve como CSV para melhor compatibilidade.');
          return;
        }
        
        // Processa como CSV
        // lê só a primeira linha
        const firstLine = reader.result.split(/\r?\n/)[0]
        // testa delimitadores comuns
        const delims = [',', ';', '\t', '|']
        let best = ',', max = 0
        delims.forEach(d => {
          const cnt = firstLine.split(d).length
          if (cnt > max) { max = cnt; best = d }
        })
        // separa pelo delimitador escolhido
        this.headers = firstLine.split(best).map(h => h.trim())
        
        // Por padrão, seleciona todas as colunas como features exceto a última
        if (this.headers.length > 1) {
          this.form.feature_cols = [...this.headers.slice(0, -1)]
          this.form.label_col = this.headers[this.headers.length - 1]
        }
      }
      reader.readAsText(f)
    },
    selectAllFeatures() {
      // Seleciona todas as colunas exceto a coluna alvo
      this.form.feature_cols = this.headers.filter(col => col !== this.form.label_col)
    },
    deselectAllFeatures() {
      // Limpa a seleção de features
      this.form.feature_cols = []
    },
    validateNeuronsPerLayer(showAlert = true) {
      // Validação para o modo avançado apenas se for DNN
      if (this.form.algorithm === 'DNN' && this.form.network_mode === 'advanced') {
        // Verifica se o número de camadas está definido
        if (!this.form.hidden_layers || this.form.hidden_layers < 1) {
          if (showAlert) alert('Por favor, defina um número válido de camadas ocultas (mínimo 1).')
          return false
        }
        
        // Verifica se os neurónios por camada estão definidos
        if (!this.form.neurons_per_layer) {
          if (showAlert) alert('Por favor, defina o número de neurónios por camada.')
          return false
        }
        
        // Verifica se o formato está correto
        const neurons = this.form.neurons_per_layer.split(',').map(n => n.trim())
        for (const n of neurons) {
          if (isNaN(parseInt(n)) || parseInt(n) <= 0) {
            if (showAlert) alert('Formato inválido para neurónios por camada. Use números positivos separados por vírgula.')
            return false
          }
        }
        
        // Verifica se o número de valores corresponde ao número de camadas
        if (neurons.length !== this.form.hidden_layers) {
          if (showAlert) alert(`O número de valores (${neurons.length}) deve ser igual ao número de camadas ocultas (${this.form.hidden_layers}).`)
          return false
        }
      }
      
      return true
    },
    async submitForm() {
  if (!this.isFormValid) {
    alert('Por favor, preencha todos os campos obrigatórios e selecione pelo menos uma coluna de feature.')
    return
  }
  
  // Validação adicional para o modo avançado
  if (!this.validateNeuronsPerLayer()) return
  
  const fd = new FormData()
  fd.append('user_id', this.user_id)
  fd.append('model_name', this.form.model_name)
  fd.append('description', this.form.description)
  fd.append('algorithm', this.form.algorithm)
  fd.append('label_col', this.form.label_col)
  fd.append('max_epochs', this.form.max_epochs)
  
  // Adiciona os novos campos apenas se for DNN
  if (this.form.algorithm === 'DNN') {
    fd.append('network_mode', this.form.network_mode)
    
    // Adiciona os campos do modo avançado apenas se necessário
    if (this.form.network_mode === 'advanced') {
      fd.append('hidden_layers', this.form.hidden_layers)
      fd.append('neurons_per_layer', this.form.neurons_per_layer)
    }
  } else {
    // Se for FNN, sempre usa o modo automático
    fd.append('network_mode', 'auto')
  }
  
  // Adiciona a lista de colunas de features selecionadas
  fd.append('feature_cols', JSON.stringify(this.form.feature_cols))
  
  fd.append('file', this.file)
  this.loading = true
  this.response = null
  try {
    const endpoint = this.form.task === 'classification'
      ? '/treinar/classificacao'
      : '/treinar/regressao'
    const r = await axios.post(
      `http://localhost:8000${endpoint}`,
      fd,
      { headers: { 'Content-Type': 'multipart/form-data' } }
     )
    this.response = r.data
    
    // NOVA PARTE: Guarda as métricas no localStorage para o ModelStats usar
    if (!this.response.error) {
      const metrics = {}
      
      if (this.form.task === 'classification') {
        metrics.accuracy = this.response.accuracy
        metrics.precision = this.response.precision
        metrics.recall = this.response.recall
        metrics.f1 = this.response.f1
      } else {
        // Para regressão, podemos guardar as métricas de regressão
        metrics.mse = this.response.mse
        metrics.mae = this.response.mae
        metrics.r2_score = this.response.r2_score
      }
      
      localStorage.setItem('modelMetrics', JSON.stringify(metrics))
      console.log('Métricas guardadas no localStorage:', metrics)
    }
    
  } catch (err) {
    console.error(err.response?.data || err)
    const detail = err.response?.data?.detail
    this.response = {
      error: true,
      message: detail || 'Erro ao treinar. Veja o console.'
    }
  } finally {
    this.loading = false
  }
}
  }
}
</script>

<style scoped>
.train-model {
  max-width: 800px;
  margin: 2rem auto;
  padding: 2rem;
  background-color: #111d32;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.4);
  color: white;
  font-family: 'Segoe UI', sans-serif;
}

h1 {
  text-align: center;
  margin-bottom: 1.5rem;
}

h3 {
  margin-top: 1.5rem;
  margin-bottom: 1rem;
  color: #04AA6D;
  border-bottom: 1px solid #2a3a56;
  padding-bottom: 0.5rem;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.3rem;
  font-weight: 500;
  color: #ccc;
}

input[type="text"],
input[type="number"],
select,
input[type="file"] {
  width: 100%;
  padding: 0.6rem;
  background-color: #1c2b40;
  color: white;
  border: 1px solid #444;
  border-radius: 5px;
  box-sizing: border-box;
}

input::file-selector-button {
  background: #2575fc;
  border: none;
  padding: 0.5rem 1rem;
  color: white;
  cursor: pointer;
  border-radius: 4px;
}

button {
  width: 100%;
  padding: 0.75rem;
  background-color: #04AA6D;
  color: white;
  font-size: 1rem;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  margin-top: 1rem;
}

button:hover {
  background-color: #03975f;
}

button:disabled {
  background-color: #666;
  cursor: not-allowed;
}

.secondary-button {
  background-color: #2575fc;
  padding: 0.5rem;
  font-size: 0.9rem;
  margin-right: 0.5rem;
  width: auto;
}

.secondary-button:hover {
  background-color: #1a65e0;
}

.action-buttons {
  display: flex;
  margin-top: 0.5rem;
}

.response {
  margin-top: 2rem;
  background: #1c2b40;
  padding: 1.5rem;
  border-radius: 8px;
  color: #eee;
}

.response ul {
  margin-top: 0.5rem;
  padding-left: 1.2rem;
}

.loading-container {
  text-align: center;
  margin-top: 2rem;
  background: #1c2b40;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  color: #ddd;
}

.loader-image {
  width: 100px;
  margin-bottom: 1rem;
  animation: pulse 1.5s infinite ease-in-out;
}

.loading-container p {
  color: #ccc;
  font-size: 1.1rem;
  margin-bottom: 1rem;
}

.progress-bar {
  width: 100%;
  height: 12px;
  background-color: #333;
  border-radius: 10px;
  overflow: hidden;
}

.bar {
  height: 100%;
  background-color: #04AA6D;
  animation: loadingAnim 1.5s infinite ease-in-out;
  transform: translateX(-100%);
}

/* Novos estilos para as opções avançadas */
.advanced-options {
  background-color: #1a2a45;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  border-left: 3px solid #04AA6D;
}

/* Novos estilos para seleção de colunas */
.column-selection {
  background-color: #1a2a45;
  padding: 1rem;
  border-radius: 8px;
  margin: 1.5rem 0;
  border-left: 3px solid #2575fc;
}

.columns-container {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin: 0.5rem 0;
  max-height: 200px;
  overflow-y: auto;
  padding: 0.5rem;
  background-color: #111d32;
  border-radius: 5px;
}

.column-checkbox {
  display: flex;
  align-items: center;
  background-color: #1c2b40;
  padding: 0.3rem 0.6rem;
  border-radius: 4px;
  margin-bottom: 0.3rem;
  border: 1px solid #2a3a56;
}

.column-checkbox input {
  margin-right: 0.5rem;
}

.column-checkbox label {
  margin: 0;
  font-weight: normal;
}

.selected-as-target {
  background-color: rgba(4, 170, 109, 0.2);
  border-color: #04AA6D;
  opacity: 0.7;
}

.help-text {
  font-size: 0.8rem;
  color: #aaa;
  margin-top: 0.3rem;
  font-style: italic;
}

.validation-message {
  color: #ff6b6b;
  font-size: 0.9rem;
  margin-top: 0.5rem;
  text-align: center;
}

.error {
  color: #ff6b6b;
}

@keyframes loadingAnim {
  0% { transform: translateX(-100%); }
  50% { transform: translateX(0); }
  100% { transform: translateX(100%); }
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.8; }
}
</style>
