<template>
  <div class="loading-overlay">
    <v-progress-circular indeterminate color="blue-darken-3" size="70" width="7"></v-progress-circular>
  </div>
</template>

<style scoped>
.loading-overlay {
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.857);
  z-index: 2000;
}
</style>

