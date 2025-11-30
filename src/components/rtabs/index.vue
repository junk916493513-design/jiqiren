<template>
  <div class="smooth-tabs-container">
    <div class="tabs-nav-wrap">
      <div class="bottom-rail"></div>
      <div class="tab-glider" :style="gliderStyle"></div>
      <div
          v-for="(tab, index) in tabs"
          :key="index"
          ref="tabItems"
          class="tab-item"
          :class="{ 'is-active': activeKey === tab.value }"
          @click="handleClick(tab.value, index)"
      >
        <span class="tab-text">{{ tab.label }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'rTabs',
  model: {
    prop: 'activeKey',
    event: 'change'
  },
  props: {
    activeKey: { type: String, required: true },
    tabs: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      gliderStyle: {
        width: '0px',
        transform: 'translateX(0)',
        opacity: 0
      }
    }
  },
  watch: {
    activeKey: {
      handler(val) {
        this.$nextTick(() => {
          const index = this.tabs.findIndex(t => t.value === val)
          if (index !== -1) this.moveGlider(index)
        })
      },
      immediate: true
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    setTimeout(() => { this.gliderStyle.opacity = 1 }, 50)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  },
  methods: {
    handleClick(val, index) {
      this.$emit('change', val)
      this.moveGlider(index)
    },
    moveGlider(index) {
      const items = this.$refs.tabItems
      if (!items || !items[index]) return
      const target = items[index]
      const width = target.offsetWidth
      const left = target.offsetLeft
      this.gliderStyle = {
        ...this.gliderStyle,
        width: `${width}px`,
        transform: `translateX(${left}px)`
      }
    },
    handleResize() {
      const index = this.tabs.findIndex(t => t.value === this.activeKey)
      this.moveGlider(index)
    }
  }
}
</script>

<style scoped>
.smooth-tabs-container {
  width: 100%;
  padding-top: 10px;
}

.tabs-nav-wrap {
  position: relative;
  display: flex;
  align-items: center;
  padding-left: 0;
}

/* 1. 底部长灰线 */
.bottom-rail {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 1px;
  background-color: #e8e8e8;
  z-index: 1;
}

/* 2. 滑动遮罩 (Active 样式的替身) */
.tab-glider {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  box-sizing: border-box;

  /* 核心修改：让滑块来显示“选中时的紫色边框” */
  background: #ffffff; /* 只有滑块有背景，用于遮挡底线 */

  /* 这里换成你的紫色，替换原来的灰色 #e8e8e8 */
  border: 1px solid #755EE3;
  border-radius: 4px 4px 0 0;

  /* 底部边框白色，用来遮挡灰线 */
  height: calc(100% + 1px);
  border-bottom-color: #ffffff;

  z-index: 3;
  pointer-events: none;
  transition: all 0.3s cubic-bezier(0.645, 0.045, 0.355, 1);
}

/* 3. Tab 每一项 */
.tab-item {
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 8px 20px;
  margin-right: 8px;
  cursor: pointer;
  user-select: none;
  border-radius: 4px 4px 0 0;

  /* 核心修改：去掉背景色，防止闪烁 */
  background: transparent;

  /* 未选中时：显示灰色边框 */
  border: 1px solid #e8e8e8;

  font-family: PingFangSC-Regular;
  font-size: 16px;
  color: #262626;
  letter-spacing: 0;
  line-height: 24px;
  font-weight: 400;
  transition: color 0.3s;
}

/* 4. 选中状态 (Active) */
.tab-item.is-active {
  font-family: PingFangSC-Medium;
  color: #733CE9;
  font-weight: 500;

  /* 选中时，边框完全透明，让位于底下的 gliter 显示紫色边框 */
  border-color: transparent;
  background: transparent;

  z-index: 4; /* 文字浮在 gliter 上面 */
}
</style>