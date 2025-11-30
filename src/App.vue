<template>
  <div id="app">
    <RobotStatusPanel></RobotStatusPanel>
  </div>
</template>

<script>
import RobotStatusPanel from './components/RobotStatusPanel.vue'

export default {
  name: 'App',
  components: {
    RobotStatusPanel
  },
}
</script>

<style>
.html,body{
  margin:0;
  padding:0;
}
#app {
  height:100%;
  margin:0;
  padding:0;
}
</style>
