<script setup>
import { ref } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';

const store = useStore();
const router = useRouter();
const email = ref('');
const password = ref('');
const errorMessages = ref('');

async function loginUser() {
  const requestData = {
    session: {
      email: email.value,
      password: password.value
    }
  };

  try {
    const response = await axios.post('http://localhost:3000/api/v1/sessions', requestData);
    console.log('ログイン成功', response.data);
    store.commit('login', response.data.user);
    router.push('/project-list');
  } catch (error) {
    errorMessages.value = 'メールアドレスまたは、パスワードが間違っています';
    console.log('ログイン失敗', error.response.data);
  }
};
</script>

<template>
  <div class="d-flex justify-center align-center h-600">
    <div class="w-400">
      <h1 class="mb-15">Liftee</h1>
      <h2 class="mb-15">ログイン</h2>
      <p v-if="!!email && !!password || errorMessages == ''" class="text-red my-5">{{ errorMessages }}</p>
      <v-form @submit.prevent="loginUser">
        <v-text-field v-model="email" label="メールアドレス" outlined required @input="errorMessages = ''"></v-text-field>
        <v-text-field v-model="password" label="パスワード" type="password" outlined required @input="errorMessages = ''"></v-text-field>
        <v-btn type="submit" class="mt-10" color="blue-darken-3" @click="loginUser">ログイン</v-btn>
      </v-form>
    </div>
  </div>
</template>

<style scoped>
  .w-400 {
    width: 400px;
  }

  .h-600 {
    height: 600px;
  }
</style>