<script setup>
  import { onMounted, ref } from 'vue';
  import axios from 'axios';

  const companies = ref([]);
  const clients = ref([]);
  const projects = ref([]);
  const currentCompany = 'T.T.C 株式会社';
  const companyId = ref(0);

  const fetchData = async () => {
    try{
      const companyResponse = await axios.get('http://localhost:3000/api/v1/company');
      companies.value = companyResponse.data;
      companies.value.forEach(company => {
      if(company.name === currentCompany) {
        companyId.value = company.id;
      }
    })
    } catch(error) {
      console.log('会社情報の取得に失敗しました', error);
    }

    try{
      const clientResponse = await axios.get(`http://localhost:3000/api/v1/client`);
      clients.value = clientResponse.data;
    } catch(error) {
      console.log('クライアント情報の取得に失敗しました', error);
    }

    try{
      const projectResponse = await axios.get(`http://localhost:3000/api/v1/project`);
      projects.value = projectResponse.data;
    } catch(error) {
      console.log('プロジェクト情報の取得に失敗しました', error);
    }
  }

  onMounted(() => {
    fetchData()
  });
</script>

<template>
  <v-row>
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
  </v-row>
</template>
