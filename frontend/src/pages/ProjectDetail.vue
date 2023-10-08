<script setup>
  import { onMounted, ref } from 'vue';
  import { useRoute, useRouter } from 'vue-router'
  import axios from 'axios';
  import VueDatePicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css';
  import Schedule from '../components/Schedule.vue';
  import { useStore } from 'vuex';

  const store = useStore();
  const router = useRouter();
  const route = useRoute();
  const projectId = route.params.id;
  const sheetWithCurrentProject = ref([]);
  const selectedSheet = ref('');
  const currentSheet = ref('');
  const selectedStatus = ref('');

  const requestCreateSheetObj = ref({
    sheet: {
      name: '',
      project_id: projectId
    }
  })

  const requestCreateTaskObj = ref({
    task: {
      trader_name: '',
      name: '',
      work_place: '',
      start_datetime: '',
      end_datetime: '',
      vehicles: '',
      notes: '',
      status: selectedStatus.value === '完了' ? 2 : selectedStatus.value === '着手中' ? 1 : 0,
      sheet_id: 3
    }
  })

  const createSheetDialog = ref(false);
  const updateSheetDialog = ref(false);
  const deleteSheetDialog = ref(false);
  const createTaskDialog = ref(false);

  async function fetchSheetData() {
    store.dispatch('startLoading');
    try{
      const sheetResponse = await axios.get(`http://localhost:3000/api/v1/sheet`);
      const currentProjectSheets = [];
      sheetResponse.data.forEach(sheet => {
        if(projectId == sheet.project_id) {
          currentProjectSheets.push(sheet)
        }
      });
      sheetWithCurrentProject.value = currentProjectSheets;
      selectedSheet.value = currentProjectSheets[0];
    } catch(error) {
      console.log('シート情報の取得に失敗しました', error);
    } finally {
      setTimeout(() => {
        store.dispatch('stopLoading');
      }, 1000);
    }
  }

  async function createSheet() {
    try {
      await axios.post('http://localhost:3000/api/v1/sheet', requestCreateSheetObj.value);
      router.go(0)
    } catch(error) {
      console.log('シートの作成に失敗しました', error);
    }
  }

  async function deleteSheet() {
    try {
      await axios.delete(`http://localhost:3000/api/v1/sheet/${selectedSheet.value.id}`);
      router.go(0)
    } catch(error) {
      console.log('シートの削除に失敗しました', error);
    }
  }

  async function updateSheet() {
    try {
      await axios.patch(
        `http://localhost:3000/api/v1/sheet/${selectedSheet.value.id}`,
        {
          sheet: {
            name: selectedSheet.value.name,
            project_id: projectId
          }
        }
        );
      router.go(0);
    } catch(error) {
      console.log('シートの編集に失敗しました', error);
    }
  }

  async function createTask() {
    requestCreateTaskObj.value.task.sheet_id = selectedSheet.value.id
    try {
      await axios.post('http://localhost:3000/api/v1/task', requestCreateTaskObj.value);
      router.go(0)
    } catch(error) {
      console.log('タスクの作成に失敗しました', error);
    }
  }

  onMounted(() => {
    fetchSheetData()
  })
</script>

<template>
  <v-sheet>
    <v-container class="d-flex justify-end">
      <div v-if="sheetWithCurrentProject.length !== 0">
        <v-menu transition="scale-transition">
          <template v-slot:activator="{ props }">
            <v-btn v-if="store.state.user.role === 'project_manager'" variant="outlined" class="mr-3 text-blue-darken-4 text-h5" icon="mdi-plus" v-bind="props"></v-btn>
          </template>
          <v-list>
            <v-list-item>
              <v-dialog v-model="createSheetDialog" >
                <template v-slot:activator="{ props }">
                  <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props">
                    シート追加
                  </v-btn>
                </template>
                <v-card width="500" class="py-3 mx-auto">
                  <div class="d-flex justify-end mr-3">
                    <v-btn variant="text" icon="mdi-window-close" @click="createSheetDialog = false"></v-btn>
                  </div>
                  <v-form @submit.prevent="createSheet">
                    <v-card-text class="pb-0">
                      <v-container class="pb-0">
                        <v-text-field label="シート名" required v-model="requestCreateSheetObj.sheet.name"></v-text-field>
                      </v-container>
                    </v-card-text>
                    <v-card-actions class="d-flex justify-center pb-5">
                      <div>
                        <v-btn type="submit" variant="text" color="black" block>追加</v-btn>
                      </div>
                    </v-card-actions>
                  </v-form>
                </v-card>
              </v-dialog>
            </v-list-item>
            <v-list-item>
              <v-dialog v-model="createTaskDialog">
                <template v-slot:activator="{ props }">
                  <v-btn rounded="0" variant="plain" class="ma-0" v-bind="props">
                    タスク追加
                  </v-btn>
                </template>
                <v-card width="650" class="py-3 mx-auto">
                  <div class="d-flex justify-end mr-3">
                    <v-btn variant="text" icon="mdi-window-close" @click="createTaskDialog = false"></v-btn>
                  </div>
                  <v-card-text class="pb-0 px-15">
                    <v-container class="pb-0">
                      <v-form @submit.prevent="createTask">
                        <v-row>
                          <v-col cols="12">
                            <v-text-field label="業者名" required v-model="requestCreateTaskObj.task.trader_name" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="12">
                            <v-text-field label="作業内容" required v-model="requestCreateTaskObj.task.name" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="12">
                            <v-text-field label="作業場所" required v-model="requestCreateTaskObj.task.work_place" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="6">
                            <VueDatePicker locale="jp" v-model="requestCreateTaskObj.task.start_datetime"></VueDatePicker>
                          </v-col>
                          <v-col cols="6">
                            <VueDatePicker locale="jp" v-model="requestCreateTaskObj.task.end_datetime"></VueDatePicker>
                          </v-col>
                          <v-col cols="6">
                            <v-text-field label="車輌台数" required v-model="requestCreateTaskObj.task.vehicles" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="12">
                            <v-textarea label="注意事項" v-model="requestCreateTaskObj.task.notes" class="mb-3"></v-textarea>
                          </v-col>
                          <v-col cols="6">
                            <v-select label="ステータス" :items="['未着手', '着手中', '完了']" v-model="selectedStatus" class="mb-3"></v-select>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-container>
                  </v-card-text>
                  <v-card-actions class="d-flex justify-center">
                    <div>
                      <v-btn type="submit" variant="tonal" block @click="createTask">追加</v-btn>
                    </div>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-list-item>
          </v-list>
        </v-menu>
      </div>
    </v-container>
    <v-container class="d-flex align-center py-8 px-0">
      <template v-for="sheet in sheetWithCurrentProject" :key="sheet">
        <div class="mr-5">
          <v-card v-if="store.state.user.role === 'project_manager'" :ripple="false" rounded="0" class="d-flex text-blue-darken-3" variant="outlined" @click="selectedSheet = {...sheet}">
            <v-card-text class="align-self-center text-black py-3 pr-1">{{ sheet.name }}</v-card-text>
            <v-menu transition="scale-transition">
              <template v-slot:activator="{ props }">
                <v-btn density="compact" v-bind="props" :ripple="false" icon="mdi-dots-vertical" class="align-self-center text-caption text-blue-darken-3 mr-1" variant="text" @click="currentSheet = {...sheet}"></v-btn>
              </template>
              <v-list>
                <v-list-item>
                <v-dialog v-model="updateSheetDialog">
                  <template v-slot:activator="{ props }">
                    <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props" color="yellow-darken-4">
                      編集
                    </v-btn>
                  </template>
                  <v-card width="500" class="mx-auto">
                    <v-form @submit.prevent="updateSheet">
                      <v-card-text class="pb-0">
                        <v-container class="pb-0">
                          <v-text-field label="シート名" required v-model="currentSheet.name"></v-text-field>
                        </v-container>
                      </v-card-text>
                      <v-card-actions class="d-flex justify-center pb-5">
                        <div>
                          <v-btn type="submit" variant="text" color="black" block @click="updateSheet">編集</v-btn>
                        </div>
                      </v-card-actions>
                    </v-form>
                  </v-card>
                </v-dialog>
              </v-list-item>
              <v-list-item>
                <v-dialog v-model="deleteSheetDialog">
                  <template v-slot:activator="{ props }">
                    <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props" color="red-darken-4">
                      削除
                    </v-btn>
                  </template>
                  <v-card width="500" class="mx-auto">
                    <v-card-text class="text-center">{{ currentSheet.name }}シートを削除してよろしいですか？</v-card-text>
                    <v-card-actions class="d-flex justify-center pb-5">
                      <div class="d-flex justify-center">
                        <v-btn class="pa-0 ma-0" type="submit" variant="tonal" color="black" block @click="deleteSheetDialog = false">キャンセル</v-btn>
                        <v-btn class="pa-0 ma-0 ml-3" type="submit" variant="tonal" color="red-darken-2" block @click="deleteSheet">削除</v-btn>
                      </div>
                    </v-card-actions>
                  </v-card>
                </v-dialog>
              </v-list-item>
              </v-list>
            </v-menu>
          </v-card>
          <v-btn v-else rounded="0" variant="outlined" @click="selectedSheet = sheet">
            <p>{{ sheet.name }}</p>
          </v-btn>
        </div>
      </template>
    </v-container>
  </v-sheet>
  <v-sheet class="d-flex justify-center align-center mt-15 mb-10">
    <p class="text-h6 font-weight-bold">週間揚重予定表</p>
  </v-sheet>
  <Schedule :sheet="selectedSheet" />
</template>