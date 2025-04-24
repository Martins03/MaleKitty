import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../components/LoginPage.vue'
import DashboardPage from '../components/DashboardPage.vue'
import RegisterPage from '@/components/RegisterPage.vue'    

const routes = [
  {
    path: '/',
    name: 'Login',
    component: LoginPage
  },
  {
    path: '/dashboardpage',
    name: 'DashboardPage',
    component: DashboardPage
  },
  {
    path: '/registerpage',
    name: 'RegisterPage',
    component: RegisterPage
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
