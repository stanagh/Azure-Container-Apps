//
// API routes, that return JSON
// ---------------------------------------------
// Ben C, Jan 2020
//

import express from 'express'
const router = express.Router()
import os from 'os'
import fs from 'fs'
import axios from 'axios'
import appInsights from 'applicationinsights'
import process from 'process'


// =======================================================================
// Get weather data as JSON
// =======================================================================
router.get('/api/weather/:lat/:long', async function (req, res, next) {
  const WEATHER_API_KEY = process.env.WEATHER_API_KEY || '123456'
  const long = req.params.long
  const lat = req.params.lat

  try {
    // Call external OpenWeather API
    const weatherResp = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?units=metric&lat=${lat}&lon=${long}&appid=${WEATHER_API_KEY}`,
    )

    if (weatherResp.data) {
      // Send custom metric over to App Insights - 'weatherTemp' with the temperature
      if (appInsights.defaultClient && weatherResp.data.main) {
        console.log(`----- ${weatherResp.data.main.temp}`)
        appInsights.defaultClient.trackMetric({
          name: 'weatherTemp',
          value: weatherResp.data.main.temp,
          // Extra meta data
          properties: { city: weatherResp.data.name, country: weatherResp.data.sys.country },
        })
      }

      // Proxy the OpenWeather response through to the caller
      res.status(200).send(weatherResp.data)
    } else {
      throw new Error(`Current weather not available for: ${long},${lat}`)
    }
  } catch (e) {
    return res.status(500).send(`API error fetching weather: ${e.toString()}`)
  }
})

// =======================================================================
// API for live monitoring (CPU and memory) data
// =======================================================================
router.get('/api/monitoringdata', async function (req, res, next) {
  const data = {
    container: false,
    memUsedBytes: 0,
    memTotalBytes: 0,
    memAppUsedBytes: 0,
    cpuAppPercentage: 0,
  }

  try {
    // MEMORY
    if (fs.existsSync('/.dockerenv')) {
      data.container = true

      const memUsagePath = '/sys/fs/cgroup/memory/memory.usage_in_bytes'
      const memLimitPath = '/sys/fs/cgroup/memory/memory.limit_in_bytes'

      if (fs.existsSync(memUsagePath) && fs.existsSync(memLimitPath)) {
        data.memUsedBytes = parseInt(fs.readFileSync(memUsagePath, 'utf8'))
        data.memTotalBytes = parseInt(fs.readFileSync(memLimitPath, 'utf8'))

        // limit_in_bytes might be unrealistically huge; fallback to total system memory
        if (data.memTotalBytes > 90000000000000) {
          data.memTotalBytes = os.totalmem()
        }
      } else {
        // Fallback if cgroup files are missing
        data.memUsedBytes = os.totalmem() - os.freemem()
        data.memTotalBytes = os.totalmem()
      }
    } else {
      // Non-container system
      data.memUsedBytes = os.totalmem() - os.freemem()
      data.memTotalBytes = os.totalmem()
    }

    // App memory
    data.memAppUsedBytes = process.memoryUsage().rss

    // CPU usage (approx)
    const startUsage = process.cpuUsage()
    const D_TIME = 1000
    const timeout = (ms) => new Promise((res) => setTimeout(res, ms))
    await timeout(D_TIME)
    const cpuResult = process.cpuUsage(startUsage)
    data.cpuAppPercentage = (cpuResult.user / 1000 / D_TIME) * 100

    return res.status(200).send(data)
  } catch (e) {
    console.error('Monitoring API error:', e)
    return res.status(500).send({
      error: true,
      title: 'Monitoring API error',
      message: e.toString(),
    })
  }
})


export default router
