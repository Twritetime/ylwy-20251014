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
  border: none;
  color: white;
  font-weight: 500;
  transition: all var(--transition-normal) ease;
  box-shadow: 0 2px 4px rgba(59, 130, 246, 0.2);
  border-radius: 8px;
  padding: 0.75rem 1.5rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  position: relative;
  overflow: hidden;
}

.gradient-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: 0.5s;
}

.gradient-button:hover:not(.is-disabled)::before {
  left: 100%;
}

.gradient-button:hover:not(.is-disabled) {
  background: var(--secondary-gradient);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(59, 130, 246, 0.3);
}

.gradient-button:active:not(.is-disabled) {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(59, 130, 246, 0.2);
}

.gradient-button.is-disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* 按钮尺寸 */
.gradient-button.small {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}

.gradient-button.default {
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
}

.gradient-button.large {
  padding: 1rem 2rem;
  font-size: 1.125rem;
}

/* 文字按钮样式 */
.gradient-button.text {
  background: transparent;
  box-shadow: none;
  color: #3b82f6;
}

.gradient-button.text:hover {
  background: rgba(59, 130, 246, 0.1);
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