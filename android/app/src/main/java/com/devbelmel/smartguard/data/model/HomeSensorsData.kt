package com.devbelmel.smartguard.data.model

data class HomeSensorsData(
    val gas: GasData = GasData(),
    val fridgeTemp: TemperatureData = TemperatureData(),
    val roomTemp: TemperatureData = TemperatureData(),
    val waterTank: WaterTankData = WaterTankData(),
    val power: PowerData = PowerData(),
    val motion: MotionData = MotionData(),
    val lastSeen: Long = 0,
    val isConnected: Boolean = false,
    val ipAddress: String = "",
    val ipAddressPublic: String = ""
)

data class GasData(val value: Int = 0, val status: String = "normal")
data class TemperatureData(val value: Double = 0.0, val unit: String = "°C")
data class WaterTankData(val level: Int = 0, val unit: String = "%")
data class PowerData(val available: Boolean = false, val voltage: Int = 0)
data class MotionData(val detected: Boolean = false, val lastTrigger: Long = 0)
