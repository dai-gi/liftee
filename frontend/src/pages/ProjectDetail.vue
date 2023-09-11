<script setup>
import { onMounted, ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router'
import { DateTime } from 'luxon';
import axios from 'axios';
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';



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

// ======== 予定表 =========
const dateAndWeekdayList = ref([]);
const displayList = ref([]);

const getDates = (start_date, end_date) => {

  let currentDate = start_date;
  while(currentDate <= end_date) {
    dateAndWeekdayList.value.push({
      date: currentDate.toFormat('y年M月d日'),
      weekday: currentDate.setLocale('ja').toFormat('EEE')
    });
    currentDate = currentDate.plus({ days: 1 });
  }

  displayList.value = dateAndWeekdayList.value.slice(0, 7);
}

// ======== ページネーション =========
const totalNumberOfPages = ref(0);
const itemsPerPage = 7;
const paginateNumbersList = ref([]);

const paginateNumbers = () => {
  totalNumberOfPages.value = Math.ceil(dateAndWeekdayList.value.length / itemsPerPage);

  let num = 1;
  let startNumber = 0;
  let endNumber = itemsPerPage;
  while(paginateNumbersList.value.length < totalNumberOfPages.value) {
    paginateNumbersList.value.push({
      id: num,
      startNumber: startNumber,
      endNumber: endNumber
    })
    num++
    startNumber = endNumber
    endNumber = endNumber + itemsPerPage
  }

  filterPaginateNumberList.value = paginateNumbersList.value.slice(startPageNumber, endPageNumber);
}

// ======== ページネーションボタン =========
const currentPage = ref(1);
const filterPaginateNumberList = ref([]);
let startPageNumber = 0;
let endPageNumber = 10;

const increasePaginateNumberList = () => {
  if(currentPage.value > endPageNumber) {
    startPageNumber = endPageNumber;
    endPageNumber += 10;
  }
  filterPaginateNumberList.value = paginateNumbersList.value.slice(startPageNumber, endPageNumber);
}

const diminishPaginateNumberList = () => {
  if(currentPage.value < startPageNumber + 1) {
    startPageNumber -= 10;
    endPageNumber -= 10;
  }
  filterPaginateNumberList.value = paginateNumbersList.value.slice(startPageNumber, endPageNumber);
}

const clickPageNumber = (element) => {
  currentPage.value = element.id
  displayList.value = dateAndWeekdayList.value.slice(element.startNumber, element.endNumber)
  console.log(currentPage.value)
}

const clickNextButton = () => {
  currentPage.value = currentPage.value < totalNumberOfPages.value ? currentPage.value + 1 : currentPage.value
  const paginateNumber = paginateNumbersList.value.find((element) => element.id === currentPage.value);
  for(let i = 0; i < paginateNumbersList.value.length; i++) {
    if(paginateNumbersList.value[i].id == currentPage.value) {
      displayList.value = dateAndWeekdayList.value.slice(paginateNumber.startNumber, paginateNumber.endNumber)
    }
  }
  increasePaginateNumberList();
}

const clickPrevButton = () => {
  currentPage.value = currentPage.value > 1 ? currentPage.value - 1 : 1
  const paginateNumber = paginateNumbersList.value.find((element) => element.id === currentPage.value);
  for(let i = 0; i < paginateNumbersList.value.length; i++) {
    if(paginateNumbersList.value[i].id == currentPage.value) {
      displayList.value = dateAndWeekdayList.value.slice(paginateNumber.startNumber, paginateNumber.endNumber)
    }
  }
  diminishPaginateNumberList();
}

const toggleRipple = computed(() => {
  if(currentPage.value === totalNumberOfPages.value) {
    return false
  } else if (currentPage.value === 1) {
    return false
  } else {
    return true
  }
})

// ======== バックエンドからデータを取得 =========
const currentCompany = 'T.T.C 株式会社';
const companies = ref([]);
const clients = ref([]);
const projects = ref([]);
const currentSheet = ref('');
const companyId = ref(0);
const route = useRoute();
const projectId = route.params.id;
const currentSheets = ref([]);
const currentProject = ref('');
const tasks = ref([]);

const fetchData = async () => {

    // 会社情報
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

    // クライアント情報
    try{
      const clientResponse = await axios.get(`http://localhost:3000/api/v1/client`);
      clients.value = clientResponse.data;
    } catch(error) {
      console.log('クライアント情報の取得に失敗しました', error);
    }

    // プロジェクト情報
    try{
      const projectResponse = await axios.get(`http://localhost:3000/api/v1/project`);
      projects.value = projectResponse.data;
      getCurrentProject();
    } catch(error) {
      console.log('プロジェクト情報の取得に失敗しました', error);
    }

    // シート情報
    try{
      const sheetResponse = await axios.get(`http://localhost:3000/api/v1/sheet`);
      const currentProjectSheets = [];
      sheetResponse.data.forEach(sheet => {
        if(projectId == sheet.project_id) {
          currentProjectSheets.push(sheet)
        }
      });
      currentSheet.value = currentProjectSheets[0];
      currentSheets.value = currentProjectSheets;
    } catch(error) {
      console.log('シート情報の取得に失敗しました', error);
    }

    // タスク情報
    try{
      const taskResponse = await axios.get(`http://localhost:3000/api/v1/task`);
      tasks.value = taskResponse.data;
    } catch(error) {
      console.log('タスク情報の取得に失敗しました', error);
    }
  }

  const getCurrentProject = () => {
    projects.value.forEach(project => {
      if(projectId == project.id) {
        currentProject.value = project;
      }
    });
    const startDate = DateTime.fromSQL(currentProject.value.start_date);
    const endDate = DateTime.fromSQL(currentProject.value.end_date);
    getDates(startDate, endDate),
    paginateNumbers()
  }

  // ======== シートボタンのダイアログ =========
  let createSheetDialog = ref(false);
  let editSheetDialog = ref(false);
  let deleteSheetDialog = ref(false);

  // ======== シート追加機能 =========
  const router = useRouter();
  const sheetObj = ref({
    sheet: {
      name: '',
      project_id: projectId
    }
  })

  const createSheet = async () => {
    try {
      await axios.post('http://localhost:3000/api/v1/sheet', sheetObj.value);
      router.go(0)
    } catch(error) {
      console.log('シートの作成に失敗しました', error);
    }
  }

  // ======== シート削除機能 =========
  const deleteSheet = async () => {
    try {
      await axios.delete(`http://localhost:3000/api/v1/sheet/${currentSheet.value.id}`);
      router.go(0)
    } catch(error) {
      console.log('シートの削除に失敗しました', error);
    }
  }

  // ======== シート編集機能 =========
  const updateSheet = async () => {
    try {
      await axios.patch(`http://localhost:3000/api/v1/sheet/${currentSheet.value.id}`, {sheet: {name: currentSheet.value.name, project_id: projectId}});
      router.go(0);
    } catch(error) {
      console.log('シートの編集に失敗しました', error);
    }
  }


  // ======== タスク追加機能 =========
  const createTask = async () => {
    taskObj.value.task.sheet_id = currentSheet.value.id
    try {
      await axios.post('http://localhost:3000/api/v1/task', taskObj.value);
      router.go(0)
    } catch(error) {
      console.log('シートの作成に失敗しました', error);
    }
  }


  // ======== タスクボタンのダイアログ =========
  let taskDialog = ref(false);
  let editTaskDialog = ref(false);
  let deleteTaskDialog = ref(false);


  // ======== ライフサイクルフック =========
  onMounted(() => {
    fetchData()
  })
</script>

<template>
  <v-sheet>
    <v-container class="d-flex justify-end">
      <div v-if="currentSheets.length !== 0">
        <v-menu transition="scale-transition">
          <template v-slot:activator="{ props }">
            <v-btn rounded="0" variant="tonal" class="mr-3 text-black" v-bind="props">
              シート
            </v-btn>
          </template>
          <v-list>
            <v-list-item>
              <v-dialog v-model="createSheetDialog">
                <template v-slot:activator="{ props }">
                  <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props">
                    追加
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
                        <v-btn type="submit" variant="text" color="black" block @click="createSheetDialog = false">追加</v-btn>
                      </div>
                    </v-card-actions>
                  </v-form>
                </v-card>
              </v-dialog>
            </v-list-item>
            <v-list-item>
              <v-dialog v-model="editSheetDialog">
                <template v-slot:activator="{ props }">
                  <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props">
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
                  <v-btn rounded="0" variant="plain" class="mr-0" v-bind="props">
                    削除
                  </v-btn>
                </template>
                <v-card width="500" class="mx-auto">
                  <v-card-text class="text-center">本当に削除してよろしいですか？</v-card-text>
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
        <v-dialog v-model="taskDialog">
          <template v-slot:activator="{ props }">
            <v-btn rounded="0" variant="tonal" class="ma-0 text-blue-darken-3" v-bind="props">
              <p class="text-black">タスク追加</p>
            </v-btn>
          </template>
          <v-card width="650" class="py-3 mx-auto">
            <div class="d-flex justify-end mr-3">
              <v-btn variant="text" icon="mdi-window-close" @click="taskDialog = false"></v-btn>
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
                      <v-select label="車輌台数" :items='["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]'  v-model="taskObj.task.vehicles" class="mb-3"></v-select>
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
                <v-btn type="submit" variant="tonal" color="blue-darken-3" block @click="createTask">
                  <p class="text-black">追加</p>
                </v-btn>
              </div>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
    </v-container>
    <v-container class="d-flex align-center py-8 px-5">
      <template v-for="sheet in currentSheets" :key="sheet">
        <v-btn rounded="0" class="text-blue-darken-4 mr-3" variant="outlined" @click="currentSheet = sheet">
          <p class="text-caption text-black" >{{ sheet.name }}</p>
        </v-btn>
      </template>
    </v-container>
  </v-sheet>
  <v-sheet class="d-flex justify-center align-center mt-10">
    <p class="text-h6 font-weight-bold">週間揚重予定表</p>
  </v-sheet>
  <div>
    <template v-if="currentSheets.length === 0">
      <v-sheet class="h-400 d-flex justify-center align-center pa-0">
        <v-btn size="x-large" class="text-blue-darken-3" variant="outlined">
          <p class="text-black">シートを作成する</p>
        </v-btn>
      </v-sheet>
    </template>
    <template v-if="currentSheets.length !== 0">
      <v-container>
        <v-btn :style="{ 'opacity': [ currentPage === 1 ?  0.2 : 1] }" variant="plain" :ripple="toggleRipple" icon="mdi-chevron-left" @click="clickPrevButton"></v-btn>
        <template v-for="number in filterPaginateNumberList" :key="number">
          <v-btn :variant="[number.id === currentPage ? 'tonal' : 'text']" class="px-0" @click="clickPageNumber(number)">{{ number.id }}</v-btn>
        </template>
        <v-btn :style="{ 'opacity': [ currentPage === totalNumberOfPages ?  0.2 : 1] }" :ripple="toggleRipple" variant="plain" icon="mdi-chevron-right" @click="clickNextButton"></v-btn>
      </v-container>
      <div class="x-scroll">
        <div class="w-1800 h-4500 pa-3">
          <v-sheet class="d-flex mb-4">
            <p class="text-h6">プロジェクトA｜</p>
            <p class="text-h6">{{ currentSheet.name }}</p>
          </v-sheet>
          <template v-for="date in displayList" :key="date">
            <div class="w-250 float-left mr">
              <div :style="{ 'background-color': [ date.weekday === '土' ? '#448AFF' : [ date.weekday === '日' ? '#E57373' : 'white' ] ] }" class="border-all minus-margin py-3 mb">
                  <p>{{ date.date }}({{ date.weekday }})</p>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">7:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                    <template v-if="DateTime.fromISO(task.start_datetime).hour === 7">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 'pending'" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 'start'" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 'end'" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">8:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                    <template v-if="DateTime.fromISO(task.start_datetime).hour >= 8 && DateTime.fromISO(task.start_datetime).hour < 10">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 'pending'" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 'start'" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 'end'" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">10:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                    <template v-if="DateTime.fromISO(task.start_datetime).hour >= 10 && DateTime.fromISO(task.start_datetime).hour < 12">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 'pending'" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 'start'" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 'end'" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">12:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                    <template v-if="DateTime.fromISO(task.start_datetime).hour === 12">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 'pending'" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 'start'" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 'end'" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">13:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                    <template v-if="DateTime.fromISO(task.start_datetime).hour >= 13 && DateTime.fromISO(task.start_datetime).hour < 15">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 'pending'" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 'start'" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 'end'" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">15:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                    <template v-if="DateTime.fromISO(task.start_datetime).hour >= 15 && DateTime.fromISO(task.start_datetime).hour < 17">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 'pending'" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 'start'" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 'end'" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">17:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                    <template v-if="DateTime.fromISO(task.start_datetime).hour >= 17">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 'pending'" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 'start'" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 'end'" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
            </div>
          </template>
        </div>
      </div>
      <v-container>
        <v-btn :style="{ 'opacity': [ currentPage === 1 ?  0.2 : 1] }" variant="plain" :ripple="toggleRipple" icon="mdi-chevron-left" @click="clickPrevButton"></v-btn>
        <template v-for="number in filterPaginateNumberList" :key="number">
          <v-btn :variant="[number.id === currentPage ? 'tonal' : 'text']" class="px-0" @click="clickPageNumber(number)">{{ number.id }}</v-btn>
        </template>
        <v-btn :style="{ 'opacity': [ currentPage === totalNumberOfPages ?  0.2 : 1] }" :ripple="toggleRipple" variant="plain" icon="mdi-chevron-right" @click="clickNextButton"></v-btn>
      </v-container>
    </template>
  </div>
</template>

<style scoped>
  .border-all {
    border: 1px solid #1565C0;
  }

  .mr {
    margin-right: 3px;
  }

  .mb {
    margin-bottom: 3px;
  }

  .h-400 {
    height: 400px;
  }

  .h-800 {
    max-height: 1600px;
    min-height: 800px;
  }

  .h-4500 {
    height:4500px;
  }

  .w-700 {
    width: 700px;
  }

  .w-250 {
    width: 250px;
  }

  .w-1800 {
    width: 1800px;
  }

  .x-scroll {
    overflow-x: scroll;
    overflow-y: visible;
  }

  .float-left {
    float: left;
  }
</style>