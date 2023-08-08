<template>
  <v-app>
    <v-app-bar color="blue-grey-lighten-2">
      <v-container>
        <v-row align="center" no-gutters>
          <v-col cols="5" class="d-flex flex-row align-center">
            <router-link to="/">
              <v-toolbar-title class="text-white text-h6 font-weight-bold ma-2 pa-2">Liftee</v-toolbar-title>
            </router-link>
            <router-link to="/project-list">
              <p class="text-white ma-2 pa-2">プロジェクトリスト</p>
            </router-link>
          </v-col>
          <v-col cols="2">
            <router-link to="/">
              <p class="text-white ma-2 pa-2 text-h6">xxxx株式会社</p>
            </router-link>
          </v-col>
          <v-col cols="3" offset="2" class="d-flex flex-row">
            <v-text-field density="compact" variant="solo" label="検索" append-inner-icon="mdi-magnify"  hide-details @click:append-inner="onClick"></v-text-field>
            <v-btn icon="mdi-dots-vertical"></v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-app-bar>
    <v-main>
      <v-conteiner class="py-8 px-6" fluid>
        <router-view></router-view>
      </v-conteiner>
    </v-main>
  </v-app>
</template>
