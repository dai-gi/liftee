<script setup>
import { onMounted, ref } from 'vue';
import { DateTime } from 'luxon';

const startDate = DateTime.fromISO('2022-08-01');
const endDate = DateTime.fromISO('2022-09-01');
const dateAndWeekdayList = ref([])

const getDates = (start_date, end_date) => {
  let currentDate = start_date;
  while(currentDate <= end_date) {
    dateAndWeekdayList.value.push({
      date: currentDate.toFormat('MM月dd日'),
      weekday: currentDate.setLocale('ja').toFormat('EEE')
    });
    currentDate = currentDate.plus({ days: 1 });
  }
}

onMounted(() => {
  getDates(startDate, endDate);
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
    <template v-for="date in dateAndWeekdayList" :key="date">
      <v-col cols="2" class="px-1 py-0 mb-5">
        <div :style="{ 'background-color': [ date.weekday === '土' ? '#448AFF' : [ date.weekday === '日' ? '#E57373' : 'white' ] ] }" class="border-non-bottom py-3">
            <p>{{ date.date }}({{ date.weekday }})</p>
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
    </template>
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