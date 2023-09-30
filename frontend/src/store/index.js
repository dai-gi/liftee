import { createStore } from 'vuex';

export default createStore({
  state: {
    user: null,
    isLoggedIn: false
  },
  mutations: {
    login(state, user) {
      state.user = user,
      state.isLoggedIn = !!user
    },

    logout(state, blank, bool) {
      state.user = blank,
      state.isLoggedIn = bool
    }
  }
});