import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../components/LoginPage.vue'
import DashboardPage from '../components/DashboardPage.vue'
import RegisterPage from '../components/RegisterPage.vue'
import TrainModel from '../components/TrainModel.vue'
import ModelStats from '../components/ModelStats.vue'
import HomePage from '../components/HomePage.vue'
import MaleKittyPage from '../components/MaleKittyPage.vue'

const routes = [
  { path: '/', name: 'HomePage', component: HomePage },
  { path: '/login', name: 'Login', component: LoginPage },
  { path: '/dashboardpage', name: 'DashboardPage', component: DashboardPage },
  { path: '/registerpage', name: 'RegisterPage', component: RegisterPage },
  { path: '/train', name: 'TrainModel', component: TrainModel },
  { path: '/model-stats', name: 'ModelStats', component: ModelStats },
  { path: '/male-kitty-page', name: 'MaleKittyPage', component: MaleKittyPage }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
