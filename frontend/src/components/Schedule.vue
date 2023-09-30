<script setup>
  import { onMounted, ref, computed } from 'vue';
  import { useRoute } from 'vue-router'
  import { DateTime } from 'luxon';
  import axios from 'axios';
  import Task from './Task.vue';

  defineProps(['sheet']);

  const route = useRoute();
  const dateAndWeekdayList = ref([]);
  const displayList = ref([]);
  const totalNumberOfPages = ref(0);
  const itemsPerPage = 7;
  const paginateNumbersList = ref([]);
  const currentPage = ref(1);
  const filterPaginateNumberList = ref([]);
  const projects = ref([]);
  const currentProject = ref('');
  const projectId = route.params.id;
  const currentSheets = ref([]);
  const currentSheet = ref('');
  const tasks = ref([]);

  function getDates(start_date, end_date) {
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

  function paginateNumbers() {
    totalNumberOfPages.value = Math.ceil(dateAndWeekdayList.value.length / itemsPerPage);

    let num = 1;
    let startNumber = 0;
    let endNumber = itemsPerPage;
    let startPageNumber = 0;
    let endPageNumber = 10;
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

  function clickPageNumber(element) {
    currentPage.value = element.id
    displayList.value = dateAndWeekdayList.value.slice(element.startNumber, element.endNumber)
  }

  function increasePaginateNumberList() {
    if(currentPage.value > endPageNumber) {
      startPageNumber = endPageNumber;
      endPageNumber += 10;
    }
    filterPaginateNumberList.value = paginateNumbersList.value.slice(startPageNumber, endPageNumber);
  }

  function clickNextButton() {
    currentPage.value = currentPage.value < totalNumberOfPages.value ? currentPage.value + 1 : currentPage.value
    const paginateNumber = paginateNumbersList.value.find((element) => element.id === currentPage.value);
    for(let i = 0; i < paginateNumbersList.value.length; i++) {
      if(paginateNumbersList.value[i].id == currentPage.value) {
        displayList.value = dateAndWeekdayList.value.slice(paginateNumber.startNumber, paginateNumber.endNumber)
      }
    }
    increasePaginateNumberList();
  }

  function diminishPaginateNumberList() {
    if(currentPage.value < startPageNumber + 1) {
      startPageNumber -= 10;
      endPageNumber -= 10;
    }
    filterPaginateNumberList.value = paginateNumbersList.value.slice(startPageNumber, endPageNumber);
  }

  function clickPrevButton() {
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

  async function fetchProjectData() {
    try{
      const projectResponse = await axios.get(`http://localhost:3000/api/v1/project`);
      projects.value = projectResponse.data;
      getCurrentProject();
    } catch(error) {
      console.log('プロジェクト情報の取得に失敗しました', error);
    }
  }

  function getCurrentProject() {
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

  function sortedTasks() {
    tasks.value = [...tasks.value].sort((a, b) => (a.start_datetime > b.start_datetime ? 1 : -1));
  }

  async function fetchTaskData() {
    try{
      const taskResponse = await axios.get(`http://localhost:3000/api/v1/task`);
      tasks.value = taskResponse.data;
      sortedTasks()
    } catch(error) {
      console.log('タスク情報の取得に失敗しました', error);
    }
  }

  onMounted(() => {
    fetchProjectData(),
    fetchSheetData(),
    fetchTaskData()
  })
</script>

<template>
  <div>
    <template v-if="currentSheets.length === 0">
      <v-sheet class="h-400 d-flex justify-center align-center pa-0">
        <v-btn size="x-large" class="text-blue-darken-3" variant="outlined">
          <p class="text-black">シートを作成する</p>
        </v-btn>
      </v-sheet>
    </template>
    <template v-if="currentSheets.length !== 0">
      <v-container class="my-5">
        <v-btn :style="{ 'opacity': [ currentPage === 1 ?  0.2 : 1] }" variant="plain" :ripple="toggleRipple" icon="mdi-chevron-left" @click="clickPrevButton"></v-btn>
        <template v-for="number in filterPaginateNumberList" :key="number">
          <v-btn :variant="[number.id === currentPage ? 'tonal' : 'text']" class="px-0" @click="clickPageNumber(number)">{{ number.id }}</v-btn>
        </template>
        <v-btn :style="{ 'opacity': [ currentPage === totalNumberOfPages ?  0.2 : 1] }" :ripple="toggleRipple" variant="plain" icon="mdi-chevron-right" @click="clickNextButton"></v-btn>
      </v-container>
      <div class="x-scroll">
        <div class="w-1800 h-4500 pa-3 my-5">
          <v-sheet class="d-flex mb-4">
            <p class="text-h6">プロジェクトA｜</p>
            <p class="text-h6">{{ sheet.name }}</p>
          </v-sheet>
          <template v-for="date in displayList" :key="date">
            <div class="w-250 float-left mr">
              <div :style="{ 'background-color': [ date.weekday === '土' ? '#448AFF' : [ date.weekday === '日' ? '#E57373' : '#EEEEEE' ] ] }" class="border-all minus-margin py-3 mb">
                  <p>{{ date.date }}({{ date.weekday }})</p>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">7:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="task.sheet_id === sheet.id">
                    <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                      <template v-if="DateTime.fromISO(task.start_datetime).hour === 7">
                        <Task :task="task" :tasks="tasks"/>
                      </template>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">8:00</p>
                <template v-for="task in tasks" :key="task.id">
                  <template v-if="task.sheet_id === sheet.id">
                    <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                      <template v-if="DateTime.fromISO(task.start_datetime).hour >= 8 && DateTime.fromISO(task.start_datetime).hour < 10">
                        <Task :task="task" />
                      </template>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">10:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="task.sheet_id === sheet.id">
                    <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                      <template v-if="DateTime.fromISO(task.start_datetime).hour >= 10 && DateTime.fromISO(task.start_datetime).hour < 12">
                        <Task :task="task" />
                      </template>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">12:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="task.sheet_id === sheet.id">
                    <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                      <template v-if="DateTime.fromISO(task.start_datetime).hour === 12">
                        <Task :task="task" />
                      </template>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">13:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="task.sheet_id === sheet.id">
                    <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                      <template v-if="DateTime.fromISO(task.start_datetime).hour >= 13 && DateTime.fromISO(task.start_datetime).hour < 15">
                        <Task :task="task" />
                      </template>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">15:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="task.sheet_id === sheet.id">
                    <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                      <template v-if="DateTime.fromISO(task.start_datetime).hour >= 15 && DateTime.fromISO(task.start_datetime).hour < 17">
                        <Task :task="task" />
                      </template>
                    </template>
                  </template>
                </template>
              </div>
              <div class="border-all minus-margin h-800 pa-2 mb">
                <p class="text-caption text-left text-grey-darken-3 mb-2">17:00</p>
                <template v-for="task in tasks" :key="task">
                  <template v-if="task.sheet_id === sheet.id">
                    <template v-if="DateTime.fromISO(task.start_datetime).toFormat('y年M月d日') === date.date">
                      <template v-if="DateTime.fromISO(task.start_datetime).hour >= 17">
                        <Task :task="task" />
                      </template>
                    </template>
                  </template>
                </template>
              </div>
            </div>
          </template>
        </div>
      </div>
      <v-container class="my-5">
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