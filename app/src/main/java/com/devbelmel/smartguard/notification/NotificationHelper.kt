package com.devbelmel.smartguard.notification

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import com.devbelmel.smartguard.R

class NotificationHelper(private val context: Context) {
    private val manager = context.getSystemService(NotificationManager::class.java)
    fun showWarningAlert(gasValue: Int) {
        createChannel()
        val notification = NotificationCompat.Builder(context, "gas_alerts")
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle(context.getString(R.string.alert_warning_title))
            .setContentText(context.getString(R.string.alert_warning_text, gasValue))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .build()
        manager.notify(1001, notification)
    }
    fun showDangerAlert(gasValue: Int) {
        createChannel()
        val notification = NotificationCompat.Builder(context, "gas_alerts")
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle(context.getString(R.string.alert_danger_title))
            .setContentText(context.getString(R.string.alert_danger_text, gasValue))
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVibrate(longArrayOf(0, 500, 500, 500))
            .build()
        manager.notify(1002, notification)
    }
    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("gas_alerts", "Gas Alerts", NotificationManager.IMPORTANCE_HIGH)
            channel.enableVibration(true)
            manager.createNotificationChannel(channel)
        }
    }
}
