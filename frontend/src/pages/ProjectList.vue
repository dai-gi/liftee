<!-- <script setup>
</script> -->

<template>
  <v-row>
    <v-col v-for="n in 3" :key="n" cols="12">
      <h4 class="d-flex flex-row">顧客{{ n }}</h4>
      <v-card>
        <v-list lines="two">
          <template v-for="n in 1" :key="n">
            <v-row align="center" no-gutters>
              <v-col cols="2">
                <p class="p-20" >プロジェクト名</p>
              </v-col>
              <v-col cols="4">
                <p>概要</p>
              </v-col>
              <v-col cols="3">
                <p>期間</p>
              </v-col>
              <v-col cols="2">
                <p>ステータス</p>
              </v-col>
              <v-col cols="1">
                <v-icon icon="mdi-dots-vertical"></v-icon>
              </v-col>
            </v-row>
          </template>
        </v-list>
      </v-card>
    </v-col>
  </v-row>
  <v-container class="py-8 px-6" fluid>
  </v-container>
  <v-main>
  </v-main>
</template>
