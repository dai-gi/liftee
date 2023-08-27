<script setup>
import { onMounted, ref, computed } from 'vue';
import { DateTime } from 'luxon';

const startDate = DateTime.fromSQL('2022-08-01');
const endDate = DateTime.fromSQL('2022-09-01');
const dateAndWeekdayList = ref([]);
const displayList = ref([]);
const itemsPerPage = 7;
const currentPage = ref(1);
const paginateNumbersList = ref([]);
const totalNumberOfPages = ref(0);

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

onMounted(() => {
  getDates(startDate, endDate),
  paginateNumbers()
})

</script>

<template>
  <v-sheet class="d-flex justify-space-between align-center mx-auto px-auto">
    <div>
      <v-btn rounded="0" class="text-blue-darken-3" variant="outlined">
        <p class="text-black">仮設EV1</p>
      </v-btn>
      <v-btn rounded="0" class="ml-3 text-blue-darken-3" variant="outlined">
        <p class="text-black">仮設EV2</p>
      </v-btn>
    </div>
    <v-btn variant="plain" icon="mdi-plus-circle-outline" size="x-large">
      <template v-slot>
        <v-icon color="blue-darken-4"></v-icon>
      </template>
    </v-btn>
  </v-sheet>
  <v-sheet class="d-flex justify-space-between align-center mt-10">
    <p class="font-weight-bold">仮設エレベータ１号機</p>
    <p class="font-weight-bold">週間揚重予定表</p>
    <p class="font-weight-bold">プロジェクトA</p>
  </v-sheet>
  <v-container>
    <v-btn :style="{ 'opacity': [ currentPage === 1 ?  0.2 : 1] }" variant="plain" :ripple="toggleRipple" icon="mdi-chevron-left" @click="clickPrevButton"></v-btn>
    <template v-for="number in paginateNumbersList" :key="number">
      <v-btn :variant="[number.id === currentPage ? 'tonal' : 'text']" class="px-0" @click="clickPageNumber(number)">{{ number.id }}</v-btn>
    </template>
    <v-btn :style="{ 'opacity': [ currentPage === totalNumberOfPages ?  0.2 : 1] }" :ripple="toggleRipple" variant="plain" icon="mdi-chevron-right" @click="clickNextButton"></v-btn>
  </v-container>
  <div class="x-scroll">
    <div class="w-1800 h-4500 pa-3">
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

<style scoped>
  .border-all {
    border: 1px solid #1565C0;
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