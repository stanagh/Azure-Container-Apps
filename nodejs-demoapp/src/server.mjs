//
// Main Express server for nodejs-demoapp
// ---------------------------------------------
// Ben C, Oct 2017 - Updated: Oct 2024
//

import { readFileSync } from 'fs'
import { config as dotenvConfig } from 'dotenv'
import express from 'express'
import path from 'path'
import logger from 'morgan'
import session from 'express-session'
import { createClient as createRedisClient } from 'redis'
import RedisStore from 'connect-redis'
import appInsights from 'applicationinsights'

// ---------------------------------------------------
// Startup & config
// ---------------------------------------------------

dotenvConfig()

const packageJson = JSON.parse(
  readFileSync(new URL('./package.json', import.meta.url)),
)

console.log(`### 🚀 Node.js demo app v${packageJson.version} starting...`)

// ---------------------------------------------------
// App Insights
// ---------------------------------------------------

if (process.env.APPLICATIONINSIGHTS_CONNECTION_STRING) {
  appInsights
    .setup(process.env.APPLICATIONINSIGHTS_CONNECTION_STRING)
    .setSendLiveMetrics(true)
    .setAutoCollectConsole(true, true)
    .start()

  console.log('### 🩺 Azure App Insights enabled')
}

// ---------------------------------------------------
// Core Express init
// ---------------------------------------------------

const app = new express()

// REQUIRED behind Azure Front Door
app.set('trust proxy', true)

// Resolve dirname once
const __dirname = path.resolve()

// ---------------------------------------------------
// STATIC FILES — MUST COME FIRST
// ---------------------------------------------------

app.use(express.static(path.join(__dirname, 'public')))

// ---------------------------------------------------
// View engine
// ---------------------------------------------------

app.set('views', [
  path.join(__dirname, 'views'),
  path.join(__dirname, 'todo'),
])
app.set('view engine', 'ejs')

// ---------------------------------------------------
// Session config (auth-safe behind Front Door)
// ---------------------------------------------------

const sessionConfig = {
  secret: packageJson.name,
  cookie: {
    secure: 'auto',     // ✅ IMPORTANT for Front Door
    sameSite: 'lax',
  },
  resave: false,
  saveUninitialized: false,
}

// Optional Redis session store
if (process.env.REDIS_SESSION_HOST) {
  const redisClient = createRedisClient({
    url: `redis://${process.env.REDIS_SESSION_HOST}`,
  })

  redisClient.connect().catch((err) => {
    console.error('### 🚨 Redis session store error:', err.message)
    process.exit(1)
  })

  sessionConfig.store = new RedisStore({ client: redisClient })
  console.log('### 📚 Session store configured using Redis')
} else {
  console.log('### 🎈 Session store not configured, sessions will not persist')
}

app.use(session(sessionConfig))

// ---------------------------------------------------
// Logging
// ---------------------------------------------------

if (process.env.NODE_ENV !== 'test') {
  app.use(
    logger('dev', {
      skip: function (req) {
        return req.path.indexOf('/signin') === 0
      },
    }),
  )
}

// ---------------------------------------------------
// Body parsing
// ---------------------------------------------------

app.use(express.json())
app.use(express.urlencoded({ extended: false }))

// ---------------------------------------------------
// Routes
// ---------------------------------------------------

import pageRoutes from './routes/pages.mjs'
import apiRoutes from './routes/api.mjs'
import authRoutes from './routes/auth.mjs'
import todoRoutes from './todo/routes.mjs'
import addMetrics from './routes/metrics.mjs'

// Prometheus metrics
if (process.env.DISABLE_METRICS !== 'true') {
  addMetrics(app)
}

// Core routes
app.use('/', pageRoutes)
app.use('/', apiRoutes)

// Auth routes (only when configured)
if (process.env.ENTRA_APP_ID) {
  app.use('/', authRoutes)
}

// Optional Todo routes
if (process.env.TODO_MONGO_CONNSTR) {
  app.use('/', todoRoutes)
}

// ---------------------------------------------------
// App locals
// ---------------------------------------------------

app.locals.version = packageJson.version

// ---------------------------------------------------
// 404 handler (after everything else)
// ---------------------------------------------------

app.use(function (req, res, next) {
  let err = new Error('Not Found')
  err.status = 404

  if (req.method !== 'GET') {
    err = new Error(`Method ${req.method} not allowed`)
    err.status = 500
  }

  next(err)
})

// ---------------------------------------------------
// Error handler
// ---------------------------------------------------

app.use(function (err, req, res, next) {
  console.error(`### 💥 ERROR: ${err.message}`)

  if (appInsights.defaultClient) {
    appInsights.defaultClient.trackException({ exception: err })
  }

  res.status(err.status || 500)
  res.render('error', {
    title: 'Error',
    message: err.message,
    error: err,
  })
})

// ---------------------------------------------------
// Start server
// ---------------------------------------------------

const port = process.env.PORT || 3000
app.listen(port, '0.0.0.0')
console.log(`### 🌐 Server listening on port ${port}`)

export default app
