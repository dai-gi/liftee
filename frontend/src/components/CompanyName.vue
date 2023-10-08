<script setup>
  import axios from 'axios';
  import { onMounted, ref } from 'vue';
  import { useStore } from 'vuex';

  const store = useStore();

  const companyData = ref(null);

  onMounted(async () => {
    store.dispatch('startLoading');
    try{
      const res = await axios.get(`http://localhost:3000/api/v1/company/${store.state.user.company_id}`);
      companyData.value = res.data.name;
    } catch(error) {
      console.log('Error: ', error);
    } finally {
      setTimeout(() => {
        store.dispatch('stopLoading');
      }, 1000);
    }
  });
</script>

<template>
  <span class="text-white font-weight-light ma-2 pa-2"><span class="pr-3">｜</span>{{ companyData }}</span>
</template>