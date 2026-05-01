package com.devbelmel.smartguard.notification

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        val gasValue = remoteMessage.data["gasValue"]?.toIntOrNull() ?: return
        val helper = NotificationHelper(baseContext)
        if (gasValue > 600) helper.showDangerAlert(gasValue)
        else if (gasValue > 300) helper.showWarningAlert(gasValue)
    }
}
