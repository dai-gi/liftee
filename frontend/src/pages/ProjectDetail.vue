<script setup>
  import { onMounted, ref } from 'vue';

  // Router
  import { useRoute, useRouter } from 'vue-router'

  // API
  import axios from 'axios';

  // 日付ピッカー
  import VueDatePicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css';

  // 予定表コンポーネント
  import Schedule from '../components/Schedule.vue';

  // Router
  const router = useRouter();
  const route = useRoute();

  // 現在表示されているプロジェクトのID
  const projectId = route.params.id;

  // 現在のプロジェクトが持つシートのリスト
  const currentSheets = ref([]);
  // 現在表示しているシート
  const currentSheet = ref('');
  // シート作成時のパラメータ
  const sheetObj = ref({
    sheet: {
      name: '',
      project_id: projectId
    }
  })

  // タスク作成時のパラメータ
  const taskObj = ref({
    task: {
      trader_name: '',
      name: '',
      work_place: '',
      start_datetime: '',
      end_datetime: '',
      vehicles: '',
      notes: '',
      status: '',
      sheet_id: 3
    }
  })

  // シートCRUD用のダイアログ
  const createSheetDialog = ref(false);
  const editSheetDialog = ref(false);
  const deleteSheetDialog = ref(false);

  // タスクCRUD用のダイアログ
  const createTaskDialog = ref(false);


  // シート情報取得
  async function fetchSheetData() {
    try{
      const sheetResponse = await axios.get(`http://localhost:3000/api/v1/sheet`);
      const currentProjectSheets = [];
      sheetResponse.data.forEach(sheet => {
        if(projectId == sheet.project_id) {
          currentProjectSheets.push(sheet)
        }
      });
      currentSheets.value = currentProjectSheets;
      currentSheet.value = currentProjectSheets[0];
    } catch(error) {
      console.log('シート情報の取得に失敗しました', error);
    }
  }
  // シート作成
  async function createSheet() {
    try {
      await axios.post('http://localhost:3000/api/v1/sheet', sheetObj.value);
      router.go(0)
    } catch(error) {
      console.log('シートの作成に失敗しました', error);
    }
  }
  // シート情報削除
  async function deleteSheet() {
    try {
      await axios.delete(`http://localhost:3000/api/v1/sheet/${currentSheet.value.id}`);
      router.go(0)
    } catch(error) {
      console.log('シートの削除に失敗しました', error);
    }
  }
  // シート情報更新
  async function updateSheet() {
    try {
      await axios.patch(
        `http://localhost:3000/api/v1/sheet/${currentSheet.value.id}`,
        {
          sheet: {
            name: currentSheet.value.name,
            project_id: projectId
          }
        }
      );
      router.go(0);
    } catch(error) {
      console.log('シートの編集に失敗しました', error);
    }
  }

  // タスク作成
  async function createTask() {
    taskObj.value.task.sheet_id = currentSheet.value.id
    try {
      await axios.post('http://localhost:3000/api/v1/task', taskObj.value);
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
      <div v-if="currentSheets.length !== 0">
        <v-menu transition="scale-transition">
          <template v-slot:activator="{ props }">
            <v-btn variant="outlined" class="mr-3 text-blue-darken-4 text-h5" icon="mdi-plus" v-bind="props"></v-btn>
          </template>
          <v-list>
            <v-list-item>
              <v-dialog v-model="createSheetDialog" >
                <template v-slot:activator="{ props }">
                  <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props">
                    シート追加
                  </v-btn>
                </template>
                <v-card width="500" class="mx-auto">
                  <v-form @submit.prevent="createSheet">
                    <v-card-text class="pb-0">
                      <v-container class="pb-0">
                        <v-text-field label="シート名" required v-model="sheetObj.sheet.name"></v-text-field>
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
                            <v-text-field label="業者名" required v-model="taskObj.task.trader_name" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="12">
                            <v-text-field label="作業内容" required v-model="taskObj.task.name" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="12">
                            <v-text-field label="作業場所" required v-model="taskObj.task.work_place" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="6">
                            <VueDatePicker locale="jp" v-model="taskObj.task.start_datetime"></VueDatePicker>
                          </v-col>
                          <v-col cols="6">
                            <VueDatePicker locale="jp" v-model="taskObj.task.end_datetime"></VueDatePicker>
                          </v-col>
                          <v-col cols="6">
                            <v-text-field label="車輌台数" required v-model="taskObj.task.vehicles" class="mb-3"></v-text-field>
                          </v-col>
                          <v-col cols="12">
                            <v-textarea label="注意事項" v-model="taskObj.task.notes" class="mb-3"></v-textarea>
                          </v-col>
                          <v-col cols="6">
                            <v-select label="ステータス" :items='[0, 1, 2]' v-model="taskObj.task.status" class="mb-3"></v-select>
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
      <template v-for="sheet in currentSheets" :key="sheet">
        <div class="relative-item mr-5">
          <v-btn rounded="0" class="d-flex pl-5 pr-0" variant="outlined" @click="currentSheet = sheet">
            <p>{{ sheet.name }}</p>
            <v-menu transition="scale-transition">
              <template v-slot:activator="{ props }">
                <v-btn  v-bind="props" icon="mdi-information-outline" class="text-caption text-grey-darken-1" variant="text" @click="currentSheet = sheet"></v-btn>
              </template>
              <v-list>
                <v-list-item>
                <v-dialog v-model="editSheetDialog">
                  <template v-slot:activator="{ props }">
                    <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props" color="yellow-darken-4">
                      編集
                    </v-btn>
                  </template>
                  <v-card width="500" class="mx-auto">
                    <v-form @submit.prevent="editSheet">
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
          </v-btn>
        </div>
      </template>
    </v-container>
  </v-sheet>
  <v-sheet class="d-flex justify-center align-center mt-15 mb-10">
    <p class="text-h6 font-weight-bold">週間揚重予定表</p>
  </v-sheet>
  <Schedule :sheet="currentSheet" />
</template>