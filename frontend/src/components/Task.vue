<script setup>
  import { ref, onMounted, computed} from 'vue';
  import { useRouter } from 'vue-router'
  import { DateTime } from 'luxon';
  import axios from 'axios';
  import VueDatePicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css';
  import { useStore } from 'vuex';

  defineProps(['task']);

  const store = useStore();
  const router = useRouter();
  const tasks = ref([]);
  const currentTask = ref('');
  const currentTaskId = ref(0);
  const dialog = ref(false);
  const deleteTaskDialog = ref(false);
  const notesDialog = ref(false);

  async function fetchTaskData() {
    store.dispatch('startLoading');
    try{
      const taskResponse = await axios.get(`http://localhost:3000/api/v1/task`);
      tasks.value = taskResponse.data;
    } catch(error) {
      console.log('タスク情報の取得に失敗しました', error);
    } finally {
      setTimeout(() => {
        store.dispatch('stopLoading');
      }, 1000);
    }
  }

  async function editTask() {
    store.dispatch('startLoading');
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
            status: currentTask.value.status === '完了' ? 2 : currentTask.value.status === '着手中' ? 1 : 0
          }
        }
      );
      router.go(0);
    } catch(error) {
      console.log('シートの編集に失敗しました', error);
    }
  }

  async function deleteTask() {
    try {
      await axios.delete(`http://localhost:3000/api/v1/task/${currentTaskId.value}`);
      router.go(0)
    } catch(error) {
      console.log('タスクの削除に失敗しました', error);
    }
  }

  function getCurrentTask(task) {
    currentTaskId.value = task.id
    currentTask.value = {...task}
    if( currentTask.value.status === 2 ) {
      currentTask.value.status = '完了'
    } else if ( currentTask.value.status === 1 ) {
      currentTask.value.status = '着手中'
    } else {
      currentTask.value.status = '未着手'
    }
  }

  onMounted(() => {
    fetchTaskData()
  })
</script>

<template>
  <v-dialog v-model="dialog">
    <template v-slot:activator="{ props }">
      <v-sheet @click="getCurrentTask(task)" v-bind="props">
        <v-card variant="outlined"  :style="{ 'opacity': [ task.status === 'end' ?  0.4 : 1] }" :class="{'text-grey-lighten-1 mb-2': task.status === 'pending', 'text-blue-lighten-4 mb-2': task.status === 'start', 'text-blue-darken-1 mb-2': task.status === 'end'}" @click="active = true" v-click-outside="onClickOutside">
          <p class="text-body-2 pa-1"  :class="{'bg-grey-lighten-1 text-grey-darken-2': task.status === 'pending', 'bg-blue-lighten-1 text-white': task.status === 'start', 'bg-blue-darken-2 text-white': task.status === 'end'}">
            {{ task.trader_name }}
          </p>
          <div class="py-2">
            <div class="text-body-2 pa-2 text-grey-darken-2">
              <div class="d-flex align-center justify-center relative pb-1">
                <v-icon v-if="task.status === 'pending'" class="absolute status" color="grey-lighten-1" icon="mdi-checkbox-blank-circle-outline"></v-icon>
                <v-icon v-if="task.status === 'start'" class="absolute status" color="blue-lighten-1" icon="mdi-check-circle-outline"></v-icon>
                <v-icon v-if="task.status === 'end'" class="absolute status text-" color="blue-darken-2" icon="mdi-check-circle"></v-icon>
                <v-dialog v-model="notesDialog">
                  <template v-slot:activator="{ props }">
                    <v-btn v-if="task.notes" v-bind="props" class="text-subtitle-2 absolute notes text-red-darken-4" variant="text" icon="mdi-alert-circle-outline"></v-btn>
                  </template>
                  <v-card width="500" class="mx-auto">
                    <v-card-text class="text-center pa-10">{{ task.notes }}</v-card-text>
                    <v-card-actions class="d-flex justify-center pb-5">
                      <div>
                        <v-btn type="submit" variant="tonal" block @click="notesDialog = false">閉じる</v-btn>
                      </div>
                    </v-card-actions>
                  </v-card>
                </v-dialog>
                <p>{{ DateTime.fromISO(task.start_datetime).toFormat('H:mm') }}〜{{ DateTime.fromISO(task.end_datetime).toFormat('H:mm') }}</p>
              </div>
              <p class="pb-1">{{ task.work_place }}</p>
              <p class="pb-1">{{ task.name }}</p>
              <p class="pb-1">{{ task.vehicles }}</p>
            </div>
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
                <v-text-field v-if="store.state.user.role === 'general'" variant="underlined" readonly label="業者名" required v-model="currentTask.trader_name" class="mb-3"></v-text-field>
                <v-text-field v-else label="業者名" required v-model="currentTask.trader_name" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field v-if="store.state.user.role === 'general'" variant="underlined" readonly label="作業名" required v-model="currentTask.name" class="mb-3"></v-text-field>
                <v-text-field v-else label="作業名" required v-model="currentTask.name" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field v-if="store.state.user.role === 'general'" variant="underlined" readonly label="作業場所" required v-model="currentTask.work_place" class="mb-3"></v-text-field>
                <v-text-field v-else label="作業場所" required v-model="currentTask.trader_name" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="6">
                <VueDatePicker :readonly="store.state.user.role === 'general' ? true : false" locale="jp" utc v-model.lazy="currentTask.start_datetime"></VueDatePicker>
              </v-col>
              <v-col cols="6">
                <VueDatePicker :readonly="store.state.user.role === 'general' ? true : false" locale="jp" utc v-model="currentTask.end_datetime"></VueDatePicker>
              </v-col>
              <v-col cols="6">
                <v-text-field v-if="store.state.user.role === 'general'" variant="underlined" readonly label="車輌台数" required v-model="currentTask.vehicles" class="mb-3"></v-text-field>
                <v-text-field v-else label="車輌台数" required v-model="currentTask.vehicles" class="mb-3"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea v-if="store.state.user.role === 'general'" variant="underlined" readonly label="注意事項" required v-model="currentTask.notes" class="mb-3"></v-textarea>
                <v-textarea v-else label="注意事項" required v-model="currentTask.notes" class="mb-3"></v-textarea>
              </v-col>
              <v-col cols="6">
                <v-select label="ステータス" :items="['未着手', '着手中', '完了']" required v-model="currentTask.status" class="mb-3"></v-select>
              </v-col>
            </v-row>
          </v-form>
        </v-container>
      </v-card-text>
      <v-card-actions class="d-flex justify-center mt-10 mb-5">
        <div class="mr-5">
          <v-btn class="px-5" type="submit" variant="tonal" color="yellow-darken-4" block @click="editTask">編集</v-btn>
        </div>
        <div class="mr-5" v-if="store.state.user.role === 'project_manager'">
          <v-dialog v-model="deleteTaskDialog">
            <template v-slot:activator="{ props }">
              <v-btn v-bind="props" class="px-5" type="submit" variant="tonal" color="red-darken-2" block>削除</v-btn>
            </template>
            <v-card width="500" class="mx-auto">
              <v-card-text class="text-center">本当に削除してよろしいですか？</v-card-text>
              <v-card-actions class="d-flex justify-center pb-5">
                <div class="d-flex justify-center">
                  <v-btn class="pa-0 ma-0" type="submit" variant="tonal" color="black" block @click="deleteTaskDialog = false">キャンセル</v-btn>
                  <v-btn class="pa-0 ma-0 ml-3" type="submit" variant="tonal" color="red-darken-2" block @click="deleteTask">削除</v-btn>
                </div>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </div>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
  .relative {
    position: relative;
  }

  .absolute {
    position: absolute;
  }

  .status {
    top: -10px;
    left: 0px;
  }

  .notes {
    top: 7px;
    left: -13.3px;
  }
</style>