<script setup>
  import CompanyName from './components/CompanyName.vue';
  import { ref } from 'vue';
  import { useStore } from 'vuex';
  import { useRouter } from 'vue-router';

  const store = useStore();
  const router = useRouter();
  const myPageDialog = ref(false);

  function logoutUser() {
    store.commit('logout', '', false);
    router.push('/login');
  }
</script>

<template>
  <v-app>
    <template v-if="store.state.isLoggedIn">
      <v-app-bar color="blue-darken-2">
        <v-container>
          <v-row align="center" no-gutters>
            <v-col cols="7" class="d-flex flex-row align-center">
              <router-link to="/">
                <v-toolbar-title class="text-white ma-2 pa-2">Liftee<CompanyName /></v-toolbar-title>
              </router-link>
              <router-link to="/project-list">
                <p class="project-list text-white text-button ml-5">プロジェクトリスト</p>
              </router-link>
            </v-col>
            <v-col cols="4" offset="1" class="d-flex justify-end">
              <v-menu transition="scale-transition">
                <template v-slot:activator="{ props }">
                  <v-btn icon="mdi-account-circle-outline" class="mr-5 text-h6" v-bind="props"></v-btn>
                </template>
                <v-list class="d-flex flex-column pa-3">
                  <v-lsit-item class="mb-1">
                    <v-dialog v-model="myPageDialog">
                      <template v-slot:activator="{ props }">
                        <v-btn variant="text" v-bind="props">マイページ</v-btn>
                      </template>
                      <v-card width="500" class="py-3 mx-auto">
                        <div class="d-flex justify-end mr-3">
                          <v-btn variant="text" icon="mdi-window-close" @click="myPageDialog = false"></v-btn>
                        </div>
                        <v-card-text class="pb-10 px-15">
                          <v-container>
                            <v-form>
                              <v-row>
                                <v-col cols="12">
                                  <v-text-field variant="underlined" readonly label="ひらがな" required v-model="store.state.user.syllabic_characters" class="mb-3"></v-text-field>
                                </v-col>
                                <v-col cols="12">
                                  <v-text-field variant="underlined" readonly label="名前" required v-model="store.state.user.name" class="mb-3"></v-text-field>
                                </v-col>
                                <v-col cols="12">
                                  <v-text-field variant="underlined" readonly label="メールアドレス" required v-model="store.state.user.email" class="mb-3"></v-text-field>
                                </v-col>
                                <v-col cols="12">
                                  <v-text-field variant="underlined" readonly label="電話番号" required v-model="store.state.user.phone_number" class="mb-3"></v-text-field>
                                </v-col>
                                <v-col cols="12">
                                  <v-text-field v-if="store.state.user.role === 'general'" model-value="作業員" variant="underlined" readonly label="役割" required class="mb-3"></v-text-field>
                                  <v-text-field v-else-if="store.state.user.role === 'project_manager'" model-value="職長" variant="underlined" readonly label="役割" required class="mb-3"></v-text-field>
                                  <v-text-field v-else variant="underlined" readonly label="役割" model-value="管理者" required class="mb-3"></v-text-field>
                                </v-col>
                              </v-row>
                            </v-form>
                          </v-container>
                        </v-card-text>
                      </v-card>
                    </v-dialog>
                  </v-lsit-item>
                  <v-lsit-item>
                    <v-btn variant="text" @click="logoutUser">ログアウト</v-btn>
                  </v-lsit-item>
                </v-list>
              </v-menu>
            </v-col>
          </v-row>
        </v-container>
      </v-app-bar>
    </template>
    <v-main>
      <v-container fluid>
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<style scoped>
  .project-list:hover {
    opacity: 0.7;
  }

  main {
    width: 1500px;
  }
</style>