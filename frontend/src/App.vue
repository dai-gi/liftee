<script setup>
  import CompanyName from './components/CompanyName.vue';
</script>

<template>
  <v-app>
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
          <v-col cols="4" offset="1" class="d-flex flex-row">
            <v-text-field density="compact" variant="solo" label="検索" placeholder="プロジェクト名、作業内容など..." append-inner-icon="mdi-magnify"  hide-details @click:append-inner="onClick"></v-text-field>
            <v-btn icon="mdi-dots-vertical" class="mx-5"></v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-app-bar>
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