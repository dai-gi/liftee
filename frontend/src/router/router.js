import { createRouter, createWebHistory} from 'vue-router'
import ProjectList from '../pages/ProjectList.vue'

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/project-list',
      name: 'project-list',
      component: ProjectList,
    },
  ]
})
