<script setup>
import { onMounted, ref } from 'vue';
import moment from 'moment';

let day = moment('2022-08-22 06:00:00');
let time = day.format('HH:mm');
let date = day.format();
let dates = ref([]);
const num = 17;

const addDates = () => {
  for (let i = 0; i <= num; i++) {
    dates.value.push(
      {
        time: time,
        date: date
      }
    );
    time = day.add(1, 'hour').format('HH:mm');
    date = day.format();
  }
}

const years = () => {
  return day.format('YYYY年MM月DD日')
}

const timeOnly = (date) => {
  return moment(date).format('HH:mm')
}

const isMorning = (time) => {
  return moment(time).hour() <= 12;
}

const isAfternoon = (time) => {
  return moment(time).hour() >= 12;
}

const tasks = [
  {
    name: 'task1',
    date: '2022-08-22 06:30:59'
  },
  {
    name: 'task2',
    date: '2022-08-22 07:50:00'
  },
  {
    name: 'task3',
    date: '2022-08-22 22:30:59'
  },
]

onMounted(() => {
  addDates();
})

console.log(isAfternoon(tasks[1].date))

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
    <v-btn variant="plain" icon="mdi-plus-circle-outline">
      <template v-slot>
        <v-icon color="blue-darken-4"></v-icon>
      </template>
    </v-btn>
  </v-sheet>
  <v-sheet class="d-flex justify-space-between align-center my-10">
    <p class="font-weight-bold">仮設エレベータ１号機</p>
    <p class="font-weight-bold">週間揚重予定表</p>
    <p class="font-weight-bold">プロジェクトA</p>
  </v-sheet>
  <v-row>
    <v-col cols="2" class="px-1 py-0">
      <div class="border-non-bottom py-3">
        <p>8/1 (月)</p>
      </div>
      <div class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">7:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">8:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">10:00</p>
      </div>
      <div  class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">12:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">13:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">15:00</p>
      </div>
      <div class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">17:00</p>
      </div>
    </v-col>
    <v-col cols="2" class="px-1 py-0">
      <div class="border-non-bottom py-3">
        <p>8/1 (月)</p>
      </div>
      <div class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">7:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">8:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">10:00</p>
      </div>
      <div  class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">12:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">13:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">15:00</p>
      </div>
      <div class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">17:00</p>
      </div>
    </v-col>
    <v-col cols="2" class="px-1 py-0">
      <div class="border-non-bottom py-3">
        <p>8/1 (月)</p>
      </div>
      <div class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">7:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">8:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">10:00</p>
      </div>
      <div  class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">12:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">13:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">15:00</p>
      </div>
      <div class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">17:00</p>
      </div>
    </v-col>
    <v-col cols="2" class="px-1 py-0">
      <div class="border-non-bottom py-3">
        <p>8/1 (月)</p>
      </div>
      <div class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">7:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">8:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">10:00</p>
      </div>
      <div  class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">12:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">13:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">15:00</p>
      </div>
      <div class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">17:00</p>
      </div>
    </v-col>
    <v-col cols="2" class="px-1 py-0">
      <div class="border-non-bottom py-3">
        <p>8/1 (月)</p>
      </div>
      <div class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">7:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">8:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">10:00</p>
      </div>
      <div  class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">12:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">13:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">15:00</p>
      </div>
      <div class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">17:00</p>
      </div>
    </v-col>
    <v-col cols="2" class="px-1 py-0">
      <div class="border-non-bottom py-3">
        <p>8/1 (月)</p>
      </div>
      <div class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">7:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">8:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">10:00</p>
      </div>
      <div  class="border-non-bottom h-200">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">12:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">13:00</p>
      </div>
      <div  class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">15:00</p>
      </div>
      <div class="border-non-bottom h-500">
        <p class="text-caption float-left pl-1 pt-1 text-grey-darken-3">17:00</p>
      </div>
    </v-col>
  </v-row>
</template>

<style scoped>
  .border-non-bottom {
    border: 1px solid #1565C0;
    border-bottom: none;
  }

  .v-col div:last-child {
    border-bottom: 1px solid #1565C0;
  }

  .h-200 {
    height: 200px;
  }

  .h-500 {
    height: 500px;
  }

</style>