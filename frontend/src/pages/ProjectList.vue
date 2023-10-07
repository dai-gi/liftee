<script setup>
  import { onMounted, ref } from 'vue';
  import axios from 'axios';
  import { useStore } from 'vuex';

  const store = useStore();
  const companyId = store.state.user.company_id;
  const clients = ref([]);
  const projects = ref([]);

  async function fetchClientData() {
    try{
      const response = await axios.get(`http://localhost:3000/api/v1/client`);
      response.data.forEach(client => {
        if(client.company_id === companyId) {clients.value.push(client)};
      })
    } catch(error) {
      console.log('クライアント情報の取得に失敗しました', error);
    }
  }

  async function fetchProjectData() {
    try{
      const projectResponse = await axios.get(`http://localhost:3000/api/v1/project`);
      projects.value = projectResponse.data;
    } catch(error) {
      console.log('プロジェクト情報の取得に失敗しました', error);
    }
  }

  onMounted(() => {
    fetchClientData(),
    fetchProjectData()
  });
</script>

<template>
  <v-row>
    <template v-if="!clients.length">
      <v-col cols="12">
        <v-sheet class="h-800 d-flex justify-center align-center pa-0">
          <p class="text-h5 font-weight-light">管理者に顧客情報の作成依頼をしてください</p>
        </v-sheet>
      </v-col>
    </template>
    <template v-else>
      <v-col v-for="client in clients" :key="client" cols="12" class="mb-5">
        <h3 class="d-flex flex-row ma-2">{{ client.name }}</h3>
        <template v-for="project in projects" :key="project">
          <router-link :to="'/project-detail/' + project.id">
            <template v-if="client.id === project.client_id">
              <v-card v-click-outside="onClickOutside" @click="active = true" :color="active ? 'grey-lighten-4' : undefined" :dark="active" class="d-flex align-center ma-3 pa-3 text-blue-darken-2" variant="outlined">
                <v-row>
                  <v-col cols="3">
                    <v-card-subtitle class="pb-3">プロジェクト名</v-card-subtitle>
                    <v-card-text class="pa-0 text-truncate text-black">{{ project.name }}</v-card-text>
                  </v-col>
                  <v-col cols="3">
                    <v-card-subtitle class="pb-3">概要</v-card-subtitle>
                    <v-card-text class="pa-0 text-truncate text-black">{{ project.overview }}</v-card-text>
                  </v-col>
                  <v-col cols="3">
                    <v-card-subtitle class="pb-3">期間</v-card-subtitle>
                    <v-card-text class="pa-0 text-black">{{ project.start_date }} 〜 {{ project.end_date }}</v-card-text>
                  </v-col>
                  <v-col cols="2">
                    <v-card-subtitle class="pb-3">ステータス</v-card-subtitle>
                    <v-card-text v-if="project.status === 'pending'" class="pa-0 text-black">未着工</v-card-text>
                    <v-card-text v-if="project.status === 'start'" class="pa-0 text-black">着工</v-card-text>
                    <v-card-text v-if="project.status === 'end'" class="pa-0 text-black">竣工</v-card-text>
                  </v-col>
                  <v-col cols="1" class="d-flex align-center justify-center">
                    <v-btn size="small" variant="text" icon="mdi-dots-vertical">
                      <template v-slot>
                        <v-icon color="blue-lighten-3"></v-icon>
                      </template>
                    </v-btn>
                  </v-col>
                </v-row>
              </v-card>
            </template>
          </router-link>
        </template>
      </v-col>
    </template>
  </v-row>
</template>

<style scoped>
  .h-800 {
    height: 800px;
  }
</style>