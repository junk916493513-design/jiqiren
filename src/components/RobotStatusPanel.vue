<template>
  <div class="robot-dashboard">
    <!-- 导航栏 -->
    <nav class="navbar">
      <!-- Logo区域 -->
      <div class="navbar-logo">
        <img src="../assets/ic/logo.png" alt="JIQIREN Logo" />
        <span class="navbar-logo-text">JIQIREN</span>
      </div>

      <!-- 导航链接 -->
      <div class="navbar-links">
        <div
          class="nav-link"
          :class="{ active: activeNav === 'dashboard' }"
          @click="switchNav('dashboard')"
        >
          <span class="nav-link-text">机器人大屏</span>
        </div>
        <div
          class="nav-link"
          :class="{ active: activeNav === 'console' }"
          @click="switchNav('console')"
        >
          <span class="nav-link-text">控制台</span>
        </div>
      </div>

      <!-- 登陆人员  -->
      <div class="navbar-login">
        <img class="navbar-user" src="../assets/ic/user_people.png" />
        <span class="navbar-user-text">张三</span>
        <img class="navbar-expand" src="../assets/ic/arrow_up.png" />
      </div>
    </nav>

    <!-- Banner区域 -->
    <div class="banner">
      <img
        src="../assets/ic/bg.png"
        alt="Banner Background"
        class="banner-background"
      />
      <div class="banner-wrapper">
        <div class="banner-content">
          <p class="banner-label">
            资金总量（运行中）
            <img
              :src="
                isPrivate
                  ? require('../assets/ic/eye_close.png')
                  : require('../assets/ic/eye_open.png')
              "
              alt="eye"
              @click="isPrivate = !isPrivate"
            />
          </p>
          <div class="banner-amount-box">
            <!-- <img
                src="../assets/ic/jiner_bg.png"
                alt="Amount Background"
                class="banner-amount-bg"
            /> -->
            <span class="banner-amount" :class="{ 'is-private': isPrivate }">{{
              isPrivate
                ? Array(displayAmount.toString().length).fill("*").join("")
                : displayAmount
            }}</span>
            <span class="banner-amount-unit" v-if="!isPrivate">USDT</span>
            <img
              class="banner-amount-fold"
              :class="{ 'is-fold': isFold }"
              src="../assets/ic/shouqi.png"
              @click="isFold = !isFold"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- 列表模块 -->
    <div class="list-container">
      <div class="list-content">
        <div class="list-header">
          <h2 class="list-title">机器人列表</h2>

          <!-- 标签页 -->
          <div class="list-tabs">
            <button
              class="list-tab"
              :class="{ active: activeTab === 'data' }"
              @click="switchTab('data')"
            >
              <img
                src="../assets/ic/robotdata_tab_default.png"
                alt="数据机器人"
                class="list-tab-icon unselected"
              />
              <img
                src="../assets/ic/robotdata_tab_click.png"
                alt="数据机器人"
                class="list-tab-icon selected"
              />
              <span>数据机器人</span>
            </button>
            <button
              class="list-tab"
              :class="{ active: activeTab === 'strategy' }"
              @click="switchTab('strategy')"
            >
              <img
                src="../assets/ic/robotdecision_tab_default.png"
                alt="策略机器人"
                class="list-tab-icon unselected"
              />
              <img
                src="../assets/ic/robotdecision_tab_click.png"
                alt="策略机器人"
                class="list-tab-icon selected"
              />
              <span>策略机器人</span>
            </button>
          </div>

          <!-- 筛选器 -->
          <!--          <div class="list-filters">-->
          <!--          <span-->
          <!--              class="filter-item"-->
          <!--              :class="{ active: activeFilter === 'all' }"-->
          <!--              @click="switchFilter('all')"-->
          <!--          >-->
          <!--            全部 (230)-->
          <!--          </span>-->
          <!--            <span-->
          <!--                class="filter-item"-->
          <!--                :class="{ active: activeFilter === 'running' }"-->
          <!--                @click="switchFilter('running')"-->
          <!--            >-->
          <!--            运行中 (180)-->
          <!--          </span>-->
          <!--            <span-->
          <!--                class="filter-item"-->
          <!--                :class="{ active: activeFilter === 'paused' }"-->
          <!--                @click="switchFilter('paused')"-->
          <!--            >-->
          <!--            已暂停 (50)-->
          <!--          </span>-->
          <!--          </div>-->
          <rTabs
            v-model="activeFilter"
            :tabs="[
              { label: '全部 (230)', value: 'all' },
              { label: '运行中 (180)', value: 'running' },
              { label: '已暂停 (50)', value: 'paused' },
            ]"
            v-if="false"
          ></rTabs>
        </div>

        <!-- 表格 -->
        <div
          class="list-table"
          :class="`list-table--${activeTab}`"
          style="overflow-x: auto"
        >
          <div class="table-header">
            <div>名称</div>
            <div v-if="activeTab === 'strategy'">资金</div>
            <div>实时日志</div>
            <div v-if="false">操控</div>
          </div>

          <div class="table-body">
            <div
              v-for="(robot, index) in robotList"
              :key="index"
              class="table-row"
              :class="{ flashing: flashingBots.has(robot.name) }"
            >
              <div class="robot-name">
                <span
                  class="status-dot"
                  :class="robot.enabled ? 'online' : 'offline'"
                ></span>
                <div class="robot-icon">
                  <img
                    :src="
                      activeTab === 'strategy'
                        ? require('../assets/ic/robotdecision_tab_click.png')
                        : require('../assets/ic/robotdata_tab_default.png')
                    "
                  />
                </div>
                <span class="robot-name-text">{{ robot.name }}</span>
              </div>
              <div class="robot-funds" v-if="activeTab === 'strategy'">
                {{ robot.funds }}
              </div>
              <div class="robot-log">{{ robot.log }}</div>
              <div class="robot-control" v-if="false">
                <div
                  class="toggle-switch"
                  :class="{ active: robot.enabled }"
                  @click="toggleSwitch(index)"
                >
                  <!--                  <span class="toggle-switch-label">{{ robot.enabled ? 'On' : 'Off' }}</span>-->
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 活动列表模块 -->
    <div class="activity-container">
      <div class="activity-content">
        <div class="activity-header">
          <h2 class="activity-title">最近活动</h2>
        </div>

        <!-- 活动表格 -->
        <div class="activity-table">
          <div class="activity-table-header">
            <div>时间</div>
            <div>名称</div>
            <div>订单类型</div>
            <div>状态</div>
            <div>方向</div>
            <div>价格</div>
            <div>数量</div>
            <div>扩展</div>
          </div>

          <div class="activity-table-body">
            <div
              v-for="(activity, index) in activityList"
              :key="index"
              class="activity-row"
            >
              <div class="activity-time">{{ activity.time }}</div>
              <div class="activity-name">
                <img
                  class="activity-icon"
                  :class="
                    activity.type === '数据机器人'
                      ? 'icon-data'
                      : 'icon-strategy'
                  "
                  :src="
                    activity.type === '数据机器人'
                      ? require('../assets/ic/robotdata_tab_default.png')
                      : require('../assets/ic/robotdecision_tab_click.png')
                  "
                />
                <div class="active-name-text">
                  <span class="activity-name-main">{{ activity.name }}</span>
                  <span class="activity-name-type">{{ activity.type }}</span>
                </div>
              </div>
              <div class="activity-order-type">{{ activity.orderType }}</div>
              <div class="activity-status">
                {{ activity.status === "started" ? "启动" : "暂停" }}
              </div>
              <div>
                <span
                  class="activity-direction"
                  :class="activity.direction === 'buy' ? 'buy' : 'sell'"
                >
                  {{ activity.direction === "buy" ? "买入" : "卖出" }}
                </span>
              </div>
              <div class="activity-price">{{ activity.price }}</div>
              <div class="activity-quantity">{{ activity.quantity }}</div>
              <div class="activity-expand" @click="expandActivity(activity)">
                <img src="../assets/ic/arrow-link.svg" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import rTabs from "./rtabs/index.vue";

export default {
  name: "RobotDashboard",
  components: {
    rTabs,
  },
  data() {
    return {
      isPrivate: false,
      isFold: true,
      activeNav: "dashboard",
      activeTab: "data",
      activeFilter: "all",
      totalAmount: "$9090.00",
      collectors: [],
      strategies: [],
      activityList: [],
      eventSource: null,
      flashingBots: new Set(),
    };
  },
  computed: {
    robotList() {
      return this.activeTab === "data" ? this.collectors : this.strategies;
    },
    displayAmount() {
      const t = (this.totalAmount || "").toString();
      return t.replace(/^\$/, "");
    },
  },
  methods: {
    switchNav(type) {
      this.activeNav = type;
      console.log("切换到:", type);
    },
    switchTab(type) {
      this.activeTab = type;
      console.log("切换到:", type);
    },
    switchFilter(type) {
      this.activeFilter = type;
      console.log("筛选:", type);
    },
    toggleSwitch(index) {
      const list =
        this.activeTab === "data" ? this.collectors : this.strategies;
      list[index].enabled = !list[index].enabled;
    },
    expandActivity(activity) {
      if (activity.tx) {
        window.open(`https://solscan.io/tx/${activity.tx}`, "_blank");
      }
    },
    updateRobots(data) {
      // 检测哪些机器人有更新
      const oldBots = new Map(
        [...this.collectors, ...this.strategies].map((r) => [r.name, r.log])
      );

      this.collectors = data.collectors.map((r) => ({
        name: r.name || r.botId,
        log: r.lastLog || "",
        status: r.online && r.status === "running" ? "success" : "failure",
        enabled: r.online,
        extra: r.extra,
      }));
      this.strategies = data.strategies.map((r) => ({
        name: r.name || r.botId,
        log: r.lastLog || "",
        status: r.online && r.status === "running" ? "success" : "failure",
        enabled: r.online,
        funds: r.extra?.funds || "-",
        extra: r.extra,
      }));

      // 触发闪烁效果
      [...this.collectors, ...this.strategies].forEach((r) => {
        if (oldBots.get(r.name) !== r.log || !oldBots.has(r.name)) {
          this.flashingBots.add(r.name);
          setTimeout(() => {
            this.flashingBots.delete(r.name);
            this.$forceUpdate();
          }, 500);
        }
      });
      this.$forceUpdate();
    },
    updateActivities(data) {
      this.activityList = data.map((a) => ({
        time: this.formatTime(a.timestamp),
        name: a.botName || a.botId,
        type: a.botId?.startsWith("collector") ? "数据机器人" : "策略机器人",
        orderType: a.action,
        status: "started",
        direction: a.details?.direction || "buy",
        price: a.details?.price ? `$${a.details.price}` : "-",
        quantity: a.details?.amount?.toLocaleString() || "-",
        tx: a.tx,
      }));
    },
    formatTime(ts) {
      const diff = Date.now() - ts;
      const seconds = Math.floor(diff / 1000);
      if (seconds < 60) return `${seconds}s ago`;
      const minutes = Math.floor(seconds / 60);
      if (minutes < 60) return `${minutes}m ago`;
      const hours = Math.floor(minutes / 60);
      if (hours < 24) return `${hours}h ago`;
      return `${Math.floor(hours / 24)}d ago`;
    },
    connectSSE() {
      this.eventSource = new EventSource("/api/events");

      this.eventSource.addEventListener("robots", (e) => {
        this.updateRobots(JSON.parse(e.data));
      });

      this.eventSource.addEventListener("activities", (e) => {
        this.updateActivities(JSON.parse(e.data));
      });

      this.eventSource.onerror = () => {
        console.error("SSE 连接断开，3秒后重连");
        this.eventSource.close();
        setTimeout(() => this.connectSSE(), 3000);
      };
    },
  },
  mounted() {
    console.log("机器人大屏页面加载完成");
    this.connectSSE();
  },
  beforeDestroy() {
    if (this.eventSource) {
      this.eventSource.close();
    }
  },
};
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.robot-dashboard {
  font-family: -apple-system, BlinkMacSystemFont, "PingFang SC", "Segoe UI",
    "Microsoft YaHei", sans-serif;
  background: #ffffff;
  overflow-x: hidden;
  min-height: 100vh;
}

/* 导航栏 */
.navbar {
  position: relative;
  width: 100%;
  height: 64px;
  background: #000000;
  display: flex;
  align-items: center;
  padding: 0 24px 0 45px;
  z-index: 100;
  overflow: hidden;
}

.navbar-logo {
  display: flex;
  align-items: center;
  gap: 11px;
  height: 64px;
  padding: 19px 0;
}

.navbar-logo img {
  width: 32px;
  height: 33px;
  object-fit: contain;
}

.navbar-logo-text {
  font-family: PingFangSC-Semibold;
  font-size: 22px;
  color: #ffffff;
  font-weight: 600;
  white-space: nowrap;
}

.navbar-links {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 0;
  height: 64px;
}

.navbar-login {
  position: absolute;
  right: 24px;
  display: flex;
  height: 64px;
  align-items: center;
}

.navbar-login .navbar-user {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

.navbar-login .navbar-user-text {
  font-family: PingFangSC-Regular;
  font-size: 14px;
  color: #ffffff;
  text-align: right;
  font-weight: 400;
  margin: 0 4.5px 0 18px;
}

.navbar-login .navbar-expand {
  width: 16px;
  height: 16px;
  object-fit: contain;
}

.nav-link {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  padding: 19px 20px 0 20px;
  height: 64px;
  cursor: pointer;
  transition: all 0.3s;
  box-sizing: border-box;
  overflow: visible;
}

.nav-link-text {
  font-family: PingFangSC-Semibold;
  font-size: 18px;
  color: #c5c4c4;
  font-weight: 600;

  white-space: nowrap;
  margin-bottom: 10px;
  position: relative;
  z-index: 2;
  display: inline-block;
}

.nav-link.active .nav-link-text {
  color: #ffffff;
}

/* 使用伪元素根据文字宽度显示下划线，紧贴导航栏底部（64px） */
.nav-link-text::after {
  content: "";
  position: absolute;
  bottom: -34px;
  left: 50%;
  transform: translateX(-50%);
  width: 0;
  height: 1px;
  background-color: #ffffff;
  transition: width 0.3s, opacity 0.3s;
  opacity: 0;
}

.nav-link.active .nav-link-text::after {
  width: 100%;
  opacity: 1;
}

/* Banner区域 */
.banner {
  position: relative;
  width: 100%;
  height: 200px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 27px 0;
  overflow: hidden;
}

.banner-wrapper {
  width: 100%;
  max-width: 1920px;
  margin: 0 auto;
  padding: 0 762px;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.banner-background {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: 1;
}

.banner-content {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  justify-content: center;
  /* gap: 8px; */
  width: 395px;
  height: 113px;
}

.banner-amount-box {
  position: relative;
  width: 100%;
  /* height: 80px; */
  display: flex;
  align-items: baseline;
  justify-content: flex-start;
  /* padding: 12px 64px; */
}

.banner-amount-bg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: 1;
}

.banner-amount {
  position: relative;
  font-family: PingFangSC-Medium;
  font-size: 40px;
  color: #ffffff;
  letter-spacing: 0;
  font-weight: 500;
  z-index: 2;
  white-space: pre-wrap;
  /* height: 56px; */
}

.banner-amount.is-private {
  display: flex;
  align-items: flex-end;
}

.banner-amount-unit {
  display: flex;
  font-family: PingFangSC-Medium;
  font-size: 18px;
  color: #ffffff;
  letter-spacing: 0;
  font-weight: 500;
  margin: 0 4px 0px 8px;
}

.banner-amount-fold {
  width: 20px;
  height: 20px;
  object-fit: contain;
  display: flex;
  transition: transform 0.3s ease;
  transform-origin: center;
}
.banner-amount-fold:not(.is-fold) {
  transform: rotate(-180deg);
  top: 20px;
}

/* Hide the dropdown icon next to USDT in the banner */
.banner-amount-fold {
  display: none !important;
}

/* .banner-amount-fold.is-fold {
  margin-top: 4px;
} */

.banner-label-box {
  position: relative;
}

.banner-label {
  white-space: nowrap;
  opacity: 0.7;
  font-family: PingFangSC-Medium;
  font-size: 18px;
  color: #ffffff;
  letter-spacing: 0;
  font-weight: 500;
  display: flex;
  /* margin: 0 64px; */
}

/* 列表模块容器 */
.list-container {
  width: 100%;
  max-width: 1500px;
  margin: 40px auto 0;
  box-sizing: border-box;
}

/*阴影区域*/
.list-content {
  box-shadow: 0px 0px 12px 0px rgba(0, 0, 0, 0.06);
  border-radius: 4px;
  background: #ffffff;
  display: flex;
  flex-direction: column;
}

/* 列表标题和标签页 */
.list-header {
  background: #ffffff;
  border-radius: 8px 8px 0 0;
  padding: 24px 24px 0;
  margin-bottom: 0;
}

/* 卡片标题 */
.list-title {
  font-family: PingFangSC-Medium;
  font-size: 16px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
  margin-left: 6px;
  position: relative;
  margin-bottom: 16px;
}

.list-title::before {
  content: "";
  position: absolute;
  left: -6px;
  top: 50%;
  width: 2px;
  height: 12px;
  background: #262626;
  transform: translateY(-50%);
}

/*卡片tab*/
.list-tabs {
  display: flex;
  gap: 0;
  margin-bottom: 16px;
}

.list-tab {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 24px;
  font-family: PingFangSC-Medium;
  font-size: 16px;
  color: #262626;
  letter-spacing: 0;
  line-height: 24px;
  font-weight: 500;
  background: transparent;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  margin-bottom: -1px;
  white-space: nowrap;
  border: 1px solid rgba(115, 60, 233, 0.1);
}

.list-tab:first-child {
  border-radius: 8px 0px 0px 8px;
}

.list-tab:last-child {
  border-radius: 0 8px 8px 0;
}

.list-tab-icon {
  width: 20px;
  height: 20px;
  object-fit: contain;
  flex-shrink: 0;
  transition: opacity 0.3s;
  display: block;
}

.list-tab-icon.unselected {
  display: block;
}

.list-tab-icon.selected {
  display: none;
}

.list-tab.active .list-tab-icon.unselected {
  display: none;
}

.list-tab.active .list-tab-icon.selected {
  display: block;
}

.list-tab.active {
  font-family: PingFangSC-Regular;
  font-size: 16px;
  color: #262626;
  letter-spacing: 0;
  line-height: 24px;
  font-weight: 400;
  background: rgba(115, 60, 233, 0.1);
}

.list-tab:hover {
  color: #333333;
}

.list-tab:hover:not(.active) {
  color: #666666;
}

.list-tab span {
  line-height: 1.2;
}

/* 筛选器 */
.list-filters {
  display: flex;
  gap: 8px;
  background: #fff;
  border-bottom: 1px solid #e5e5e5;
}

.filter-item {
  cursor: pointer;
  font-family: PingFangSC-Regular;
  font-size: 16px;
  color: #262626;
  letter-spacing: 0;
  line-height: 24px;
  font-weight: 400;
  padding: 8px 20px;
  border-radius: 4px;
  transition: all 0.3s;
  border: 1px solid rgba(224, 224, 224, 1);
  border-bottom: none;
}

.filter-item:hover {
  color: #333333;
  background: #f0f0f0;
}

.filter-item.active {
  color: #333333;
  font-weight: 600;
  background: #ffffff;
  position: relative;
}

.filter-item.active::after {
  position: absolute;
  content: "";
  left: 0;
  bottom: 0;
  width: 100%;
  height: 1px;
  background-color: #ffffff;
  z-index: 1;
}

/* 列表表格 */
.list-table {
  background: #ffffff;
  border-radius: 0 0 8px 8px;
  padding: 16px 24px 24px 24px;
  overflow: hidden;
  box-shadow: 0px 4px 12px 4px rgba(29, 6, 81, 0.04);
}

.table-header {
  background: #ffffff;
  display: grid;
  gap: 71px;
  padding: 13px 36px;
  border: 1px solid rgba(224, 224, 224, 1);
  border-radius: 8px 8px 0px 0px;
  font-size: 14px;
  font-weight: 600;
  color: #333333;
  align-items: center;
}

.list-table.list-table--data .table-header {
  grid-template-columns: 150px 1fr;
}

.list-table.list-table--strategy .table-header {
  grid-template-columns: 150px 100px 1fr;
}

.table-body {
  max-height: 560px;
  overflow-y: auto;
  border: 1px solid rgba(229, 229, 229, 1);
  border-top: none;
  border-radius: 0px 0px 8px 8px;
}

.table-row {
  display: grid;
  gap: 71px;
  padding: 0px 36px;
  align-items: center;
  transition: background 0.2s;
  height: 56px;
}

.list-table.list-table--data .table-row {
  grid-template-columns: 150px 1fr;
}

.list-table.list-table--strategy .table-row {
  grid-template-columns: 150px 100px 1fr;
}

.table-row:nth-child(odd) {
  background: #fcf9fe;
}

.table-row:hover {
  background: #fafafa;
}

.table-row.flashing {
  animation: flash 0.5s ease-in-out;
}

@keyframes flash {
  0%,
  100% {
    background: transparent;
  }
  50% {
    background: rgba(115, 60, 233, 0.3);
  }
}

.table-row:last-child {
  border-bottom: none;
}

.robot-name {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}

.status-dot.online {
  background: #1ab26d;
  box-shadow: 0 0 4px rgba(26, 178, 109, 0.5);
}

.status-dot.offline {
  background: #bc1717;
  box-shadow: 0 0 4px rgba(188, 23, 23, 0.5);
}

.robot-icon {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.robot-icon img {
  width: 32px;
  height: 32px;
  object-fit: contain;
}

.robot-name-text {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
}

.robot-funds {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
}

.robot-log {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2; /* Added for compatibility */
}

.robot-status {
  padding: 4px 0px;
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
  border-radius: 4px;
  display: inline-block;
  width: fit-content;
}

.robot-control {
  display: flex;
  align-items: center;
}

.toggle-switch {
  position: relative;
  width: 64px;
  height: 24px;
  background: #ffffff;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.3s;
  border: 1px solid #c5c4c5;
  display: flex;
  align-items: center;
  box-sizing: border-box;
  padding: 0 4px;
  box-sizing: border-box;
}

.toggle-switch.active {
  background: #5f44df;
}

.toggle-switch.active::after {
  background: #ffffff;
}

.toggle-switch::after {
  content: "";
  position: absolute;
  top: 2px;
  left: 2px;
  width: 16px;
  height: 16px;
  background: #c4c5c5;
  border-radius: 50%;
  box-sizing: border-box;
  transition: transform 0.3s, background-color 0.3s;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.toggle-switch.active::after {
  transform: translateX(40px);
}

.toggle-switch-label {
  font-size: 12px;
  font-weight: 500;
  color: #666666;
  position: absolute;
  top: 50%;
  left: 8px;
  transform: translateY(-50%);
  transition: color 0.3s;
  pointer-events: none;
}

.toggle-switch.active .toggle-switch-label {
  color: #ffffff;
  left: auto;
  right: 8px;
}

.toggle-switch:not(.active) .toggle-switch-label {
  color: #999999;
}

/* 活动列表模块容器 */
.activity-container {
  width: 100%;
  max-width: 1500px;
  margin: 40px auto 0;
  /*padding: 0 210px;*/
  box-sizing: border-box;
}

.activity-content {
  box-shadow: 0px 0px 12px 0px rgba(0, 0, 0, 0.06);
  border-radius: 4px;
  background: #ffffff;
  display: flex;
  flex-direction: column;
}

/* 活动列表标题 */
.activity-header {
  background: #ffffff;
  border-radius: 8px 8px 0 0;
  box-shadow: 0px 4px 12px 4px rgba(29, 6, 81, 0.04);
  padding: 24px 24px 0;
  margin-bottom: 0;
}

.activity-title {
  font-family: PingFangSC-Medium;
  font-size: 16px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
  margin-left: 6px;
  position: relative;
}

.activity-title::before {
  content: "";
  position: absolute;
  left: -6px;
  top: 50%;
  width: 2px;
  height: 12px;
  background: #262626;
  transform: translateY(-50%);
}

/* 活动列表表格 */
.activity-table {
  background: #ffffff;
  border-radius: 0 0 8px 8px;
  overflow: hidden;
  padding: 16px 24px 24px 24px;
  box-shadow: 0px 4px 12px 4px rgba(29, 6, 81, 0.04);
}

.activity-table-header {
  display: grid;
  grid-template-columns: 152px 224px 152px 152px 152px 172px 172px 162px;
  gap: 16px;
  padding: 16px 24px;
  background: #ffffff;
  border: 1px solid rgba(224, 224, 224, 1);
  border-radius: 8px 8px 0px 0px;
  font-size: 14px;
  font-weight: 600;
  color: #333333;
  align-items: center;
}

.activity-table-body {
  max-height: 560px;
  overflow-y: auto;
  border: 1px solid rgba(229, 229, 229, 1);
  border-top: none;
}

.activity-row {
  display: grid;
  grid-template-columns: 152px 224px 152px 152px 152px 172px 172px 162px;
  gap: 16px;
  padding: 0px 24px;
  align-items: center;
  transition: background 0.2s;
  height: 56px;
}

.activity-row:nth-child(odd) {
  background: #fcf9fe;
}

.activity-row:hover {
  background: #fafafa;
}

.activity-row:last-child {
  border-bottom: none;
}

.activity-time {
  font-family: PingFangSC-Regular;
  font-size: 14px;
  color: #999999;
  letter-spacing: 0;
  font-weight: 400;
}

.activity-name {
  display: flex;
  gap: 20px;
  align-items: center;
}

.activity-icon {
  width: 32px;
  height: 32px;
  object-fit: contain;
}

.active-name-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.activity-name-main {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
}

.activity-name-type {
  font-family: PingFangSC-Regular;
  font-size: 14px;
  color: #999999;
  letter-spacing: 0;
  font-weight: 400;
}

.activity-order-type {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
}

.activity-status {
  padding: 4px 0px;
  border-radius: 4px;
  display: inline-block;
  width: fit-content;
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
}

.activity-direction {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  letter-spacing: 0;
  font-weight: 500;
}

.activity-direction.buy {
  color: #1ab26d;
}

.activity-direction.sell {
  color: #bc1717;
}

.activity-price {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
}

.activity-quantity {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  color: #262626;
  letter-spacing: 0;
  font-weight: 500;
}

.activity-expand {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 64px;
  height: 32px;
  border: 1px solid #e5e5e5;
  border-radius: 4px;
  background: #ffffff;
  cursor: pointer;
  transition: all 0.2s;
}

.activity-expand:hover {
  background: #fafafa;
  border-color: #d0d0d0;
}

.activity-expand > img {
  width: 16px;
  height: 16px;
  object-fit: contain;
}

.activity-expand-icon {
  width: 16px;
  height: 16px;
  stroke: #666666;
}

/* 响应式设计 */
@media (max-width: 1920px) {
  .navbar-links {
    left: 234px;
    transform: none;
  }
}

@media (max-width: 1440px) {
  .banner {
    padding: 27px 20%;
  }

  .list-container {
    margin: 30px auto 0;
    /*padding: 0 110px;*/
  }

  .activity-container {
    margin: 30px auto 0;
    /*padding: 0 110px;*/
  }
}

@media (max-width: 1024px) {
  .navbar {
    padding: 0 20px;
  }

  .navbar-links {
    left: 50%;
    transform: translateX(-50%);
    margin-left: 0;
  }

  .banner-wrapper {
    padding: 0 10%;
  }

  .banner-content {
    width: 100%;
    max-width: 395px;
  }

  .list-container {
    /*padding: 0 20px;*/
  }

  .activity-container {
    /*padding: 0 20px;*/
  }

  .activity-table-header,
  .activity-row {
    grid-template-columns: 80px 150px 80px 80px 80px 100px 100px 60px;
    gap: 12px;
    font-size: 13px;
  }
}

@media (max-width: 768px) {
  .navbar-logo-text {
    font-size: 18px;
  }

  .nav-link {
    padding: 19px 20px;
  }

  .nav-link-text {
    font-size: 16px;
  }

  .banner-amount {
    font-size: 32px;
  }

  .banner-label {
    font-size: 16px;
  }
}
</style>
