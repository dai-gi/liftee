import { createStore } from 'vuex';
import createPersistedState from "vuex-persistedstate";

export default createStore({
  state: {
    user: null,
    isLoggedIn: false,
    isLoading: false
  },
  mutations: {
    login(state, user) {
      state.user = user,
      state.isLoggedIn = !!user
    },
    logout(state, blank, bool) {
      state.user = blank,
      state.isLoggedIn = bool
    },
    setLoading(state, isLoading) {
      state.isLoading = isLoading;
    }
  },
  actions: {
    startLoading({ commit }) {
      commit('setLoading', true);
    },
    stopLoading({ commit }) {
      commit('setLoading', false);
    }
  },
  plugins: [createPersistedState()]
});