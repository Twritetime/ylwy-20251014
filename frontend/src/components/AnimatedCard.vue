<template>
  <div 
    class="animated-card" 
    :class="{ 'cursor-pointer': clickable, 'animate-fade-in': animate }"
    @click="handleClick"
  >
    <div v-if="$slots.header" class="border-b border-gray-200 dark:border-gray-700 px-5 py-3">
      <slot name="header" />
    </div>
    <slot />
  </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  clickable: {
    type: Boolean,
    default: false
  },
  animate: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['click'])

const handleClick = () => {
  if (props.clickable) {
    emit('click')
  }
}
</script>

<style scoped>
.animated-card {
  border-radius: var(--radius-lg);
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  box-shadow: var(--card-shadow);
  transition: box-shadow var(--transition-fast) ease, transform var(--transition-fast) ease;
  overflow: hidden;
}

.dark .animated-card {
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
}

.animated-card:hover {
  transform: translateY(-1px);
  box-shadow: var(--card-shadow-hover);
}

/* 移除顶部渐变装饰，保持更纯净的卡片风格 */

.animated-card:active {
  transform: translateY(0);
}
</style>