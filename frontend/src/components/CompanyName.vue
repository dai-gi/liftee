<script setup>
  import axios from 'axios';
  import { onMounted, ref } from 'vue';

  const companyData = ref(null);

  onMounted(async () => {
    try{
      const res = await axios.get('http://localhost:3000/api/v1/company');
      companyData.value = res.data[0].name;
    } catch(error) {
      console.log('Error: ', error);
    }
  });
</script>

<template>
  <span v-if="companyData" class="text-white font-weight-light ma-2 pa-2"><span class="pr-3">｜</span>{{ companyData }}</span>
</template>