<script setup>
import { onBeforeMount, onMounted, ref, computed } from 'vue';
import { useRoute } from 'vue-router'
import { DateTime } from 'luxon';
import axios from 'axios';

const startDate = DateTime.fromSQL('2022-08-01');
const endDate = DateTime.fromSQL('2022-09-01');
const dateAndWeekdayList = ref([]);
const displayList = ref([]);
const itemsPerPage = 7;
const currentPage = ref(1);
const paginateNumbersList = ref([]);
const totalNumberOfPages = ref(0);
const sheets = ref([])
const companies = ref([]);
const clients = ref([]);
const projects = ref([]);
const currentCompany = 'T.T.C 株式会社';
const companyId = ref(0);

const route = useRoute();
const projectId = route.params.id;

const currentSheets = ref([]);


const getDates = (start_date, end_date) => {
  let currentDate = start_date;
  while(currentDate <= end_date) {
    dateAndWeekdayList.value.push({
      date: currentDate.toFormat('M月d日'),
      weekday: currentDate.setLocale('ja').toFormat('EEE')
    });
    currentDate = currentDate.plus({ days: 1 });
  }
  displayList.value = dateAndWeekdayList.value.slice(0, 7);
}

const paginateNumbers = () => {
  totalNumberOfPages.value = Math.ceil(dateAndWeekdayList.value.length / itemsPerPage);
  let num = 1;
  let startNumber = 0;
  let endNumber= itemsPerPage;
  while(paginateNumbersList.value.length < totalNumberOfPages.value) {
    paginateNumbersList.value.push({
      id: num,
      startNumber: startNumber,
      endNumber: endNumber
    })
    num++
    startNumber = endNumber
    endNumber = endNumber + 7
  }
}

const clickPageNumber = (element) => {
  currentPage.value = element.id
  for(let i = 0; i < paginateNumbersList.value.length; i++) {
    if(paginateNumbersList.value[i].id == currentPage.value) {
      displayList.value = dateAndWeekdayList.value.slice(element.startNumber, element.endNumber)
    }
  }
}

const clickNextButton = () => {
  currentPage.value = currentPage.value < totalNumberOfPages.value ? currentPage.value + 1 : 5
  const paginateNumber = paginateNumbersList.value.find((element) => element.id === currentPage.value);
  for(let i = 0; i < paginateNumbersList.value.length; i++) {
    if(paginateNumbersList.value[i].id == currentPage.value) {
      displayList.value = dateAndWeekdayList.value.slice(paginateNumber.startNumber, paginateNumber.endNumber)
    }
  }
}

const clickPrevButton = () => {
  currentPage.value = currentPage.value > 1 ? currentPage.value - 1 : 1
  const paginateNumber = paginateNumbersList.value.find((element) => element.id === currentPage.value);
  for(let i = 0; i < paginateNumbersList.value.length; i++) {
    if(paginateNumbersList.value[i].id == currentPage.value) {
      displayList.value = dateAndWeekdayList.value.slice(paginateNumber.startNumber, paginateNumber.endNumber)
    }
  }
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
      const clientResponse = await axios.get(`http://localhost:3000/api/v1/company/${companyId.value}/client`);
      clients.value = clientResponse.data;
    } catch(error) {
      console.log('クライアント情報の取得に失敗しました', error);
    }

    try{
      for (const client of clients.value) {
        const projectResponse = await axios.get(`http://localhost:3000/api/v1/company/:company_id/client/${client.id}/project`);
        projects.value = projectResponse.data;
      }
    } catch(error) {
      console.log('プロジェクト情報の取得に失敗しました', error);
    }

    try{
      for (const project of projects.value) {
        const sheetResponse = await axios.get(`http://localhost:3000/api/v1/company/:company_id/client/:client_id/project/${project.id}/sheet`);
        sheets.value = sheetResponse.data;
      }
      getSheets();
    } catch(error) {
      console.log('シート情報の取得に失敗しました', error);
    }
  }

  const getSheets = () => {
    sheets.value.forEach(sheet => {
      if(projectId == sheet.project_id) {
        currentSheets.value.push(sheet);
      }
    })
    console.log(currentSheets.value)
  }

  onBeforeMount(() => {
    fetchData()
  })

  onMounted(() => {
    getDates(startDate, endDate),
    paginateNumbers()
  })

</script>

<template>
  <v-sheet class="d-flex justify-space-between">
    <div class="d-flex align-center">
      <template v-for="sheet in currentSheets" :key="sheet">
        <v-btn rounded="0" class="text-blue-darken-3 mr-3" variant="outlined">
          <p class="text-caption text-black" >{{ sheet.name }}</p>
        </v-btn>
      </template>
    </div>
    <div v-if="currentSheets.length !== 0" class="d-flex align-center">
      <v-btn variant="plain" icon="mdi-plus-circle-outline" size="x-large">
        <template v-slot>
          <v-icon color="blue-darken-4"></v-icon>
        </template>
      </v-btn>
    </div>
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
    <template v-for="sheet in currentSheets" :key="sheet">
      <v-container>
        <v-btn :style="{ 'opacity': [ currentPage === 1 ?  0.2 : 1] }" variant="plain" :ripple="toggleRipple" icon="mdi-chevron-left" @click="clickPrevButton"></v-btn>
        <template v-for="number in paginateNumbersList" :key="number">
          <v-btn :variant="[number.id === currentPage ? 'tonal' : 'text']" class="px-0" @click="clickPageNumber(number)">{{ number.id }}</v-btn>
        </template>
        <v-btn :style="{ 'opacity': [ currentPage === totalNumberOfPages ?  0.2 : 1] }" :ripple="toggleRipple" variant="plain" icon="mdi-chevron-right" @click="clickNextButton"></v-btn>
      </v-container>
      <div class="x-scroll">
        <div class="w-1800 h-4500 pa-3">
          <v-sheet class="d-flex mb-4">
            <p class="text-h6">プロジェクトA｜</p>
            <p class="text-h6">{{ sheet.name }}</p>
          </v-sheet>
          <template v-for="date in displayList" :key="date">
            <div class="w-250 float-left">
              <div :style="{ 'background-color': [ date.weekday === '土' ? '#448AFF' : [ date.weekday === '日' ? '#E57373' : 'white' ] ] }" class="border-all minus-margin py-3">
                  <p>{{ date.date }}({{ date.weekday }})</p>
              </div>
              <div class="border-all minus-margin h-800 pa-2">
                <p class="text-caption text-left text-grey-darken-3 mb-2">7:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromSQL(task.start_datetime).toFormat('M月d日') === date.date">
                    <template v-if="DateTime.fromSQL(task.start_datetime).hour === 7">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromSQL(task.start_datetime).toFormat('H:m') }}〜</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 1" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 2" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 3" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2">
                <p class="text-caption text-left text-grey-darken-3 mb-2">8:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromSQL(task.start_datetime).toFormat('M月d日') === date.date">
                    <template v-if="DateTime.fromSQL(task.start_datetime).hour >= 8 && DateTime.fromSQL(task.start_datetime).hour < 10">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromSQL(task.start_datetime).toFormat('H:m') }}〜</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 1" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 2" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 3" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2">
                <p class="text-caption text-left text-grey-darken-3 mb-2">10:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromSQL(task.start_datetime).toFormat('M月d日') === date.date">
                    <template v-if="DateTime.fromSQL(task.start_datetime).hour >= 10 && DateTime.fromSQL(task.start_datetime).hour < 12">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromSQL(task.start_datetime).toFormat('H:m') }}〜</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 1" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 2" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 3" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2">
                <p class="text-caption text-left text-grey-darken-3 mb-2">12:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromSQL(task.start_datetime).toFormat('M月d日') === date.date">
                    <template v-if="DateTime.fromSQL(task.start_datetime).hour === 12">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromSQL(task.start_datetime).toFormat('H:m') }}〜</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 1" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 2" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 3" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2">
                <p class="text-caption text-left text-grey-darken-3 mb-2">13:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromSQL(task.start_datetime).toFormat('M月d日') === date.date">
                    <template v-if="DateTime.fromSQL(task.start_datetime).hour >= 13 && DateTime.fromSQL(task.start_datetime).hour < 15">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromSQL(task.start_datetime).toFormat('H:m') }}〜</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 1" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 2" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 3" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2">
                <p class="text-caption text-left text-grey-darken-3 mb-2">15:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromSQL(task.start_datetime).toFormat('M月d日') === date.date">
                    <template v-if="DateTime.fromSQL(task.start_datetime).hour >= 15 && DateTime.fromSQL(task.start_datetime).hour < 17">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromSQL(task.start_datetime).toFormat('H:m') }}〜</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 1" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 2" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 3" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
                          </div>
                        </v-card>
                      </router-link>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2">
                <p class="text-caption text-left text-grey-darken-3 mb-2">17:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="DateTime.fromSQL(task.start_datetime).toFormat('M月d日') === date.date">
                    <template v-if="DateTime.fromSQL(task.start_datetime).hour >= 17">
                      <router-link to="/project-detail">
                        <v-card variant="outlined" class="text-grey-lighten-1 mb-2" @click="active = true" v-click-outside="onClickOutside">
                          <p class="text-body-2 text-grey-darken-2 bg-grey-lighten-2 pa-1">{{ task.trader_name }}</p>
                          <div class="text-body-2 pa-2 text-grey-darken-2">
                            <p>{{ DateTime.fromSQL(task.start_datetime).toFormat('H:m') }}〜</p>
                            <p>{{ task.work_place }} {{ task.name }}</p>
                            <p>{{ task.vehicles }}</p>
                            <p>{{ task.notes }}</p>
                            <v-chip v-if="task.status === 1" class="mt-2" size="small" label color="red-darken-4">未着手</v-chip>
                            <v-chip v-if="task.status === 2" class="mt-2" size="small" label color="yellow-darken-4">着手中</v-chip>
                            <v-chip v-if="task.status === 3" class="mt-2" size="small" label color="blue-darken-4">完了</v-chip>
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
        <template v-for="number in paginateNumbersList" :key="number">
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

  .minus-margin {
    margin-right: -1px;
    margin-bottom: -1px;
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