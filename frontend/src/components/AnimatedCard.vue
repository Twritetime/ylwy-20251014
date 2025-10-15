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
  border-radius: 12px;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  box-shadow: var(--card-shadow);
  transition: all var(--transition-normal) ease;
  overflow: hidden;
  position: relative;
}

.dark .animated-card {
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
}

.animated-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--card-shadow-hover);
}

.animated-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--primary-gradient);
  transform: scaleX(0);
  transition: transform var(--transition-normal) ease;
}

.animated-card:hover::before {
  transform: scaleX(1);
}

.animated-card:active {
  transform: translateY(-1px);
}
</style>