<script setup>
  import axios from 'axios';
  import { onMounted, ref } from 'vue';

  const clientList = ref([]);

  onMounted(async () => {
    try{
      const res = await axios.get('http://localhost:3000/api/v1/client');
      clientList.value = res.data;
    } catch(error) {
      console.log('Error: ', error);
    }
  });
</script>

<template>
  <v-row>
    <v-col v-for="client in clientList" :key="client" cols="12">
      <h4 class="d-flex flex-row">{{ client.name }}</h4>
      <v-card class="d-flex align-center">
        <p class="pa-4">プロジェクト名</p>
        <p class="pa-4">概要</p>
        <p class="pa-4">期間</p>
        <p class="pa-4">ステータス</p>
        <v-icon class="px-5" icon="mdi-dots-vertical"></v-icon>
      </v-card>
    </v-col>
  </v-row>
</template>