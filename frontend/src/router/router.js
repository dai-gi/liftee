import { createRouter, createWebHistory} from 'vue-router'
import Project from '../pages/Project.vue'

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/project',
      name: 'project',
      component: Project,
    },
  ]
})
