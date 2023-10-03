import { createApp } from 'vue'
import './style.css'
import App from './App.vue'

// Vue Router
import { router } from './router/router'

// Vuetify
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

// ress
import 'ress'

// Vuex
import store from './store'

const vuetify = createVuetify({
  components,
  directives,
})

const app = createApp(App)

app.use(router)
app.use(vuetify)
app.use(store)
app.mount('#app')
