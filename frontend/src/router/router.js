import { createRouter, createWebHistory} from 'vue-router'
import ProjectList from '../pages/ProjectList.vue'
import ProjectDetail from '../pages/ProjectDetail.vue'

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/project-list',
      component: ProjectList,
    },
    {
      path: '/project-detail/:id',
      component: ProjectDetail,
    },
  ]
})
