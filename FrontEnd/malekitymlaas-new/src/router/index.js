import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../components/LoginPage.vue'
import DashboardPage from '../components/DashboardPage.vue'
import RegisterPage from '../components/RegisterPage.vue'
import TrainModel from '../components/TrainModel.vue'
import ModelStats from '../components/ModelStats.vue'
import GetModel from '../components/GetModel.vue'

const routes = [
  { path: '/', name: 'Login', component: LoginPage },
  { path: '/dashboardpage', name: 'DashboardPage', component: DashboardPage },
  { path: '/registerpage', name: 'RegisterPage', component: RegisterPage },
  { path: '/train', name: 'TrainModel', component: TrainModel },
  { path: '/model-stats', name: 'ModelStats', component: ModelStats },
  { path: '/modelos', name: 'GetModel', component: GetModel }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
