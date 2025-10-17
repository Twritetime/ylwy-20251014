<template>
  <el-button 
    class="gradient-button"
    :class="[type, size]"
    :loading="loading"
    :disabled="disabled"
    @click="handleClick"
  >
    <slot />
  </el-button>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  type: {
    type: String,
    default: 'primary'
  },
  size: {
    type: String,
    default: 'default'
  },
  loading: {
    type: Boolean,
    default: false
  },
  disabled: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['click'])

const handleClick = () => {
  if (!props.disabled && !props.loading) {
    emit('click')
  }
}
</script>

<style scoped>
.gradient-button {
  background: var(--primary-gradient);
  border: 1px solid rgba(10, 132, 255, 0.3);
  color: #fff;
  font-weight: 600;
  transition: background-color var(--transition-fast) ease, box-shadow var(--transition-fast) ease, transform var(--transition-fast) ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.10);
  border-radius: var(--radius-md);
  padding: 0.75rem 1.25rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}



.gradient-button:hover:not(.is-disabled) {
  background: linear-gradient(0deg, #1188ff, #1188ff);
  transform: translateY(-1px);
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.12);
}

.gradient-button:active:not(.is-disabled) {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.10);
}

.gradient-button.is-disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.gradient-button:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(10, 132, 255, 0.15), 0 3px 6px rgba(0, 0, 0, 0.12);
}

/* 按钮尺寸 */
.gradient-button.small {
  padding: 0.5rem 0.9rem;
  font-size: 0.875rem;
}

.gradient-button.default {
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
}

.gradient-button.large {
  padding: 0.9rem 1.75rem;
  font-size: 1.125rem;
}

/* 文字按钮样式 */
.gradient-button.text {
  background: transparent;
  box-shadow: none;
  color: #0a84ff;
}

.gradient-button.text:hover {
  background: rgba(10, 132, 255, 0.12);
  transform: none;
  box-shadow: none;
}

/* 成功状态按钮 */
.gradient-button.success {
  background: var(--success-gradient);
  box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
}

.gradient-button.success:hover:not(.is-disabled) {
  box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
}

/* 警告状态按钮 */
.gradient-button.warning {
  background: var(--warning-gradient);
  box-shadow: 0 2px 4px rgba(245, 158, 11, 0.2);
}

.gradient-button.warning:hover:not(.is-disabled) {
  box-shadow: 0 4px 8px rgba(245, 158, 11, 0.3);
}

/* 危险状态按钮 */
.gradient-button.danger {
  background: var(--danger-gradient);
  box-shadow: 0 2px 4px rgba(239, 68, 68, 0.2);
}

.gradient-button.danger:hover:not(.is-disabled) {
  box-shadow: 0 4px 8px rgba(239, 68, 68, 0.3);
}
</style>