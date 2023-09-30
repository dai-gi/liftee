import { createRouter, createWebHistory} from 'vue-router'
import ProjectList from '../pages/ProjectList.vue'
import ProjectDetail from '../pages/ProjectDetail.vue'
import Login from '../pages/Login.vue'

import store from '../store'

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/project-list',
      component: ProjectList,
      meta: { requiresAuth: true }
    },
    {
      path: '/project-detail/:id',
      component: ProjectDetail,
      meta: { requiresAuth: true }
    },
    {
      path: '/login',
      component: Login
    }
  ]
});

router.beforeEach((to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  console.log(requiresAuth)
  if(requiresAuth && !store.state.isLoggedIn) {
    next('/login');
  } else {
    next();
  }
});