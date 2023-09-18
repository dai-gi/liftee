<script setup>
  import { ref, onMounted } from 'vue';

  // Router
  import { useRouter } from 'vue-router'

  // 日付ライブラリ
  import { DateTime } from 'luxon';

  // API
  import axios from 'axios';

  // 日付ピッカー
  import VueDatePicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css';

  // Props
  defineProps(['task']);

  // Router
  const router = useRouter();

  // 取得したタスク情報のリスト
  const tasks = ref([]);
  // 選択した現在のタスク
  let currentTask = ref('');
  // 選択した現在のタスクのID
  const currentTaskId = ref(0);

  // ダイアログ
  const dialog = ref(false);


  // タスク情報を取得
  async function fetchTaskData() {
    try{
      const taskResponse = await axios.get(`http://localhost:3000/api/v1/task`);
      tasks.value = taskResponse.data;
    } catch(error) {
      console.log('タスク情報の取得に失敗しました', error);
    }
  }
  // タスク情報を編集
  async function editTask() {
    try {
      await axios.patch(
        `http://localhost:3000/api/v1/task/${currentTaskId.value}`,
        {
          task: {
            trader_name: currentTask.value.trader_name,
            name: currentTask.value.name,
            work_place: currentTask.value.work_place,
            start_datetime: currentTask.value.start_datetime,
            end_datetime: currentTask.value.end_datetime,
            vehicles: currentTask.value.vehicles,
            notes: currentTask.value.notes,
            status: currentTask.value.status
          }
        }
        );
      router.go(0);
    } catch(error) {
      console.log('シートの編集に失敗しました', error);
    }
  }
  // 選択したタスク情報を取得
  function getCurrentTask(task) {
    currentTaskId.value = task.id
    currentTask.value = {...task}
  }


  onMounted(() => {
    fetchTaskData()
  })
</script>

<template>
  <v-dialog v-model="dialog">
    <template v-slot:activator="{ props }">
      <v-sheet @click="getCurrentTask(task)" v-bind="props">
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
      </v-sheet>
    </template>
    <v-card width="650" class="py-3 mx-auto">
      <div class="d-flex justify-end mr-3">
        <v-btn variant="text" icon="mdi-window-close" @click="dialog = false"></v-btn>
      </div>
      <v-card-text class="pb-0 px-15">
        <v-container class="pb-0">
          <v-form>
            <v-row>
              <v-col cols="12">
                <v-text-field label="業者名" required v-model="currentTask.trader_name" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field label="作業内容" required v-model="currentTask.name" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field label="作業場所" required v-model="currentTask.work_place" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="6">
                <VueDatePicker locale="jp" utc v-model.lazy="currentTask.start_datetime"></VueDatePicker>
              </v-col>
              <v-col cols="6">
                <VueDatePicker locale="jp" utc v-model="currentTask.end_datetime"></VueDatePicker>
              </v-col>
              <v-col cols="6">
                <v-text-field label="車輌台数" required v-model="currentTask.vehicles" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea label="注意事項" v-model="currentTask.notes" class="mb-3"></v-textarea>
              </v-col>
              <v-col cols="6">
                <v-select label="ステータス" :items='[0, 1, 2]' v-model="currentTask.status" class="mb-3"></v-select>
              </v-col>
            </v-row>
          </v-form>
        </v-container>
      </v-card-text>
      <v-card-actions class="d-flex justify-center mt-10 mb-5">
        <div class="mr-5">
          <v-btn class="px-5" type="submit" variant="tonal" color="yellow-darken-4" block @click="editTask">編集</v-btn>
        </div>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>