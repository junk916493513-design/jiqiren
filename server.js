const express = require('express')
const path = require('path')
const fs = require('fs')

const app = express()
const PORT = process.env.PORT || 8080

// 数据文件路径
const DATA_DIR = path.join(__dirname, 'data')
const ACTIVITIES_FILE = path.join(DATA_DIR, 'activities.json')

// 确保数据目录存在
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true })
}

// 存储机器人心跳数据 (内存存储)
const robots = new Map()
// 存储活动记录 (最近100条)
let activities = []
const MAX_ACTIVITIES = 100
// 心跳超时时间 (60秒)
const HEARTBEAT_TIMEOUT = 60 * 1000

// SSE 客户端连接池
const sseClients = new Set()

// 广播数据给所有 SSE 客户端
function broadcast(event, data) {
  const message = `event: ${event}\ndata: ${JSON.stringify(data)}\n\n`
  sseClients.forEach(client => {
    client.write(message)
  })
}

// 获取当前机器人数据
function getRobotsData() {
  const now = Date.now()
  const result = []
  robots.forEach((robot) => {
    const isOnline = (now - robot.lastHeartbeat) < HEARTBEAT_TIMEOUT
    result.push({ ...robot, online: isOnline })
  })
  return {
    collectors: result.filter(r => r.type === 'Collector'),
    strategies: result.filter(r => r.type === 'Strategy'),
    all: result
  }
}

// 获取排序后的活动数据
function getActivitiesData(limit = 50) {
  return [...activities].sort((a, b) => b.timestamp - a.timestamp).slice(0, limit)
}

// 从文件加载活动记录
function loadActivities() {
  try {
    if (fs.existsSync(ACTIVITIES_FILE)) {
      const data = fs.readFileSync(ACTIVITIES_FILE, 'utf8')
      activities = JSON.parse(data)
      console.log(`已加载 ${activities.length} 条活动记录`)
    }
  } catch (e) {
    console.error('加载活动记录失败:', e.message)
    activities = []
  }
}

// 保存活动记录到文件
function saveActivities() {
  try {
    fs.writeFileSync(ACTIVITIES_FILE, JSON.stringify(activities, null, 2))
  } catch (e) {
    console.error('保存活动记录失败:', e.message)
  }
}

// 启动时加载数据
loadActivities()

app.use(express.json())

// 静态文件服务 (Vue 打包后的文件)
app.use(express.static(path.join(__dirname, 'dist')))

// 接收心跳
app.post('/api/heartbeat', (req, res) => {
  const { type, botId, status, lastLog, timestamp, extra } = req.body

  if (!botId || !type) {
    return res.status(400).json({ error: 'botId and type are required' })
  }

  robots.set(botId, {
    type,
    botId,
    status: status || 'running',
    lastLog: lastLog || '',
    timestamp: timestamp || Date.now(),
    extra: extra || {},
    lastHeartbeat: Date.now()
  })

  // 广播机器人更新
  broadcast('robots', getRobotsData())

  res.json({ success: true })
})

// 接收活动记录
app.post('/api/activity', (req, res) => {
  const { botId, botName, action, details, tx, timestamp } = req.body

  if (!botId || !action) {
    return res.status(400).json({ error: 'botId and action are required' })
  }

  const activity = {
    botId,
    botName: botName || botId,
    action,
    details: details || {},
    tx: tx || '',
    timestamp: timestamp || Date.now()
  }

  // 插入到数组开头，保持最新在前
  activities.unshift(activity)

  // 限制数组大小
  if (activities.length > MAX_ACTIVITIES) {
    activities.pop()
  }

  // 保存到文件
  saveActivities()

  // 广播活动更新
  broadcast('activities', getActivitiesData())

  res.json({ success: true })
})

// SSE 端点 - 实时推送
app.get('/api/events', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream')
  res.setHeader('Cache-Control', 'no-cache')
  res.setHeader('Connection', 'keep-alive')

  // 发送初始数据
  res.write(`event: robots\ndata: ${JSON.stringify(getRobotsData())}\n\n`)
  res.write(`event: activities\ndata: ${JSON.stringify(getActivitiesData())}\n\n`)

  // 添加到连接池
  sseClients.add(res)

  // 客户端断开时清理
  req.on('close', () => {
    sseClients.delete(res)
  })
})

// 获取机器人列表
app.get('/api/robots', (req, res) => {
  const now = Date.now()
  const result = []

  robots.forEach((robot, botId) => {
    // 检查是否超时
    const isOnline = (now - robot.lastHeartbeat) < HEARTBEAT_TIMEOUT
    result.push({
      ...robot,
      online: isOnline
    })
  })

  // 按类型分组
  const collectors = result.filter(r => r.type === 'Collector')
  const strategies = result.filter(r => r.type === 'Strategy')

  res.json({
    collectors,
    strategies,
    all: result
  })
})

// 获取活动列表
app.get('/api/activities', (req, res) => {
  const limit = parseInt(req.query.limit) || 50
  // 按 timestamp 降序排序，最新的在前
  const sorted = [...activities].sort((a, b) => b.timestamp - a.timestamp)
  res.json(sorted.slice(0, limit))
})

// 清理离线机器人 (可选接口)
app.delete('/api/robots/:botId', (req, res) => {
  const { botId } = req.params
  if (robots.has(botId)) {
    robots.delete(botId)
    res.json({ success: true })
  } else {
    res.status(404).json({ error: 'Robot not found' })
  }
})

// 所有其他请求返回 index.html (SPA 支持)
app.get('/{*path}', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'))
})

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`)
  console.log(`API endpoints:`)
  console.log(`  POST /api/heartbeat - 接收机器人心跳`)
  console.log(`  POST /api/activity  - 接收活动记录`)
  console.log(`  GET  /api/robots    - 获取机器人列表`)
  console.log(`  GET  /api/activities - 获取活动列表`)
})
