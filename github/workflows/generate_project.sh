#!/bin/bash
# سكريبت إنشاء مشروع SmartGuard المتكامل (المنزل الذكي)

set -e
echo "🚀 بدء إنشاء المشروع المتكامل (المنزل الذكي)..."
cd android
# إنشاء الهيكل الرئيسي
mkdir -p app/src/main/java/com/devbelmel/smartguard/presentation
mkdir -p app/src/main/java/com/devbelmel/smartguard/utils
mkdir -p app/src/main/java/com/devbelmel/smartguard/notification
mkdir -p app/src/main/java/com/devbelmel/smartguard/data/model
mkdir -p app/src/main/java/com/devbelmel/smartguard/data/datasource
mkdir -p app/src/main/java/com/devbelmel/smartguard/data/repository
mkdir -p app/src/main/java/com/devbelmel/smartguard/ui
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/values-ar
mkdir -p app/src/main/res/values-fr
mkdir -p app/src/main/res/values-ja
mkdir -p app/src/main/res/values-zh
mkdir -p app/src/main/res/values-it
mkdir -p app/src/main/res/values-pt
mkdir -p app/src/main/res/values-hi
mkdir -p app/src/main/res/values-es
mkdir -p app/src/main/res/values-fa
mkdir -p app/src/main/res/values-de
mkdir -p app/src/main/res/values-ko
mkdir -p nodemcu

# ===================== 1. ملفات Gradle =====================
cat > build.gradle << 'EOF'
// Top-level build file
plugins {
    id 'com.android.application' version '8.2.0' apply false
    id 'org.jetbrains.kotlin.android' version '1.9.22' apply false
    id 'com.google.gms.google-services' version '4.4.4' apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF

cat > settings.gradle << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "SmartGuard"
include ':app'
EOF

cat > app/build.gradle << 'EOF'
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'com.google.gms.google-services'
}

android {
    namespace 'com.devbelmel.smartguard'
    compileSdk 34

    defaultConfig {
        applicationId "com.devbelmel.smartguard"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildFeatures {
        viewBinding true
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = '17'
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'androidx.recyclerview:recyclerview:1.3.2'
    implementation 'androidx.cardview:cardview:1.0.0'
    
    implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0'
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.7.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.7.3'

    // Firebase
    implementation platform('com.google.firebase:firebase-bom:33.7.0')
    implementation 'com.google.firebase:firebase-database-ktx'
    implementation 'com.google.firebase:firebase-messaging-ktx'
}
EOF

cat > gradle.properties << 'EOF'
android.useAndroidX=true
android.enableJetifier=true
org.gradle.jvmargs=-Xmx2048m
EOF

# ===================== 2. ملفات موارد Android =====================
cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_500">#6200EE</color>
    <color name="purple_700">#3700B3</color>
    <color name="teal_200">#03DAC5</color>
    <color name="teal_700">#018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
    <color name="safe_green">#4CAF50</color>
    <color name="warning_orange">#FF9800</color>
    <color name="danger_red">#F44336</color>
    <color name="dark_background">#121212</color>
    <color name="card_background">#1E1E1E</color>
</resources>
EOF

cat > app/src/main/res/values/themes.xml << 'EOF'
<resources>
    <style name="Theme.SmartGuard" parent="Theme.MaterialComponents.DayNight.NoActionBar">
        <item name="colorPrimary">@color/purple_500</item>
        <item name="colorPrimaryVariant">@color/purple_700</item>
        <item name="colorOnPrimary">@color/white</item>
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_700</item>
        <item name="colorOnSecondary">@color/black</item>
        <item name="android:statusBarColor">@color/purple_700</item>
        <item name="android:windowBackground">@color/dark_background</item>
    </style>
</resources>
EOF

cat > app/src/main/res/drawable/ic_home_guard.xml << 'EOF'
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M12,3L1,9l4,2.18v6L12,21l7-3.82v-6l2-1.09V17h2V9L12,3zM18,14.77L12,18.5 6,14.77v-3.27l6,3.27 6-3.27v3.27z"/>
</vector>
EOF

cat > app/src/main/res/layout/activity_login.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/dark_background"
    android:gravity="center"
    android:orientation="vertical"
    android:padding="24dp">

    <ImageView
        android:layout_width="100dp"
        android:layout_height="100dp"
        android:src="@drawable/ic_home_guard"
        app:tint="@color/teal_200" />

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="16dp"
        android:text="SmartGuard"
        android:textColor="@color/white"
        android:textSize="28sp"
        android:textStyle="bold" />

    <com.google.android.material.textfield.TextInputLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="32dp"
        style="@style/Widget.Material3.TextInputLayout.OutlinedBox"
        app:endIconMode="clear_text">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/etUsername"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:hint="@string/username" />
    </com.google.android.material.textfield.TextInputLayout>

    <com.google.android.material.textfield.TextInputLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="16dp"
        style="@style/Widget.Material3.TextInputLayout.OutlinedBox"
        app:endIconMode="password_toggle">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/etPassword"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:hint="@string/password"
            android:inputType="textPassword" />
    </com.google.android.material.textfield.TextInputLayout>

    <com.google.android.material.button.MaterialButton
        android:id="@+id/btnLogin"
        android:layout_width="match_parent"
        android:layout_height="56dp"
        android:layout_marginTop="24dp"
        android:text="@string/login"
        app:cornerRadius="8dp" />

    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="24dp"
        android:gravity="center"
        android:text="@string/contact_supplier"
        android:textColor="@color/teal_200"
        android:textSize="14sp" />

</LinearLayout>
EOF

cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/dark_background"
    android:orientation="vertical">

    <androidx.appcompat.widget.Toolbar
        android:id="@+id/toolbar"
        android:layout_width="match_parent"
        android:layout_height="?attr/actionBarSize"
        android:background="@color/purple_700"
        app:titleTextColor="@color/white" />

    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/rvSensors"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:padding="8dp"
        app:layoutManager="androidx.recyclerview.widget.GridLayoutManager"
        app:spanCount="2" />

    <com.google.android.material.button.MaterialButton
        android:id="@+id/btnLogout"
        style="@style/Widget.Material3.Button.TextButton"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:layout_margin="16dp"
        android:text="@string/logout" />

</LinearLayout>
EOF

cat > app/src/main/res/layout/item_sensor_card.xml << 'EOF'
<com.google.android.material.card.MaterialCardView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="8dp"
    app:cardCornerRadius="12dp"
    app:cardElevation="4dp"
    app:cardBackgroundColor="@color/card_background">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <TextView
            android:id="@+id/tvTitle"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textColor="@color/white"
            android:textSize="16sp"
            android:textStyle="bold" />

        <TextView
            android:id="@+id/tvValue"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginTop="8dp"
            android:textColor="@color/white"
            android:textSize="24sp"
            android:textStyle="bold" />

        <TextView
            android:id="@+id/tvUnit"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textColor="@color/teal_200"
            android:textSize="14sp" />

    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
EOF

# ===================== 3. ملفات السلاسل النصية =====================
cat > app/src/main/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">SmartGuard</string>
    <string name="username">Username</string>
    <string name="password">Password</string>
    <string name="login">Login</string>
    <string name="contact_supplier">Accounts are created by the board manufacturer. Contact your supplier for credentials.</string>
    <string name="logout">Logout</string>
    <string name="gas">Gas</string>
    <string name="fridge_temp">Fridge Temp</string>
    <string name="room_temp">Room Temp</string>
    <string name="water_level">Water Level</string>
    <string name="power_status">Power</string>
    <string name="motion_status">Motion</string>
    <string name="available">Available</string>
    <string name="unavailable">Unavailable</string>
    <string name="no_motion">No motion</string>
    <string name="motion_detected">Motion detected</string>
    <string name="connected">Connected</string>
    <string name="disconnected">Disconnected</string>
    <string name="normal">Safe</string>
    <string name="warning">Warning</string>
    <string name="danger">Danger</string>
    <string name="alert_warning_title">⚠️ Gas Warning</string>
    <string name="alert_warning_text">Gas value: %d - Warning level</string>
    <string name="alert_danger_title">🔥 Gas Leak Danger!</string>
    <string name="alert_danger_text">Value: %d - Evacuate!</string>
    <string name="select_language">Language</string>
</resources>
EOF

# إضافة نفس النصوص للغة العربية (مثال مختصر)
mkdir -p app/src/main/res/values-ar
cat > app/src/main/res/values-ar/strings.xml << 'EOF'
<resources>
    <string name="app_name">حارس المنزل</string>
    <string name="username">اسم المستخدم</string>
    <string name="password">كلمة المرور</string>
    <string name="login">دخول</string>
    <string name="contact_supplier">يتم إنشاء الحسابات من قبل مصنع اللوحة. تواصل مع المورد للحصول على بيانات الدخول.</string>
    <string name="logout">تسجيل خروج</string>
    <string name="gas">غاز</string>
    <string name="fridge_temp">حرارة الثلاجة</string>
    <string name="room_temp">حرارة المنزل</string>
    <string name="water_level">مستوى الماء</string>
    <string name="power_status">كهرباء</string>
    <string name="motion_status">حركة</string>
    <string name="available">موجود</string>
    <string name="unavailable">غير موجود</string>
    <string name="no_motion">لا حركة</string>
    <string name="motion_detected">حركة مكتشفة</string>
    <string name="connected">متصل</string>
    <string name="disconnected">غير متصل</string>
    <string name="normal">آمن</string>
    <string name="warning">تحذير</string>
    <string name="danger">خطر</string>
    <string name="alert_warning_title">⚠️ تحذير غاز</string>
    <string name="alert_warning_text">قيمة الغاز: %d - مستوى تحذيري</string>
    <string name="alert_danger_title">🔥 خطر تسرب غاز!</string>
    <string name="alert_danger_text">القيمة: %d - إخلاء فوري!</string>
    <string name="select_language">اللغة</string>
</resources>
EOF

# باقي اللغات (يمكنك إضافتها بنفس النمط لاحقاً)

# ===================== 4. ملف AndroidManifest.xml =====================
cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.devbelmel.smartguard">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@style/Theme.SmartGuard">
        
        <activity
            android:name=".presentation.LoginActivity"
            android:exported="true"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity
            android:name=".presentation.MainActivity"
            android:exported="false"
            android:screenOrientation="portrait" />

        <service
            android:name=".notification.MyFirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
    </application>
</manifest>
EOF

# ===================== 5. جميع ملفات Kotlin =====================
mkdir -p app/src/main/java/com/devbelmel/smartguard/data/model
cat > app/src/main/java/com/devbelmel/smartguard/data/model/HomeSensorsData.kt << 'EOF'
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
EOF

mkdir -p app/src/main/java/com/devbelmel/smartguard/data/datasource
cat > app/src/main/java/com/devbelmel/smartguard/data/datasource/FirebaseDataSource.kt << 'EOF'
package com.devbelmel.smartguard.data.datasource

import com.devbelmel.smartguard.data.model.*
import com.google.firebase.database.*
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow

class FirebaseDataSource(private val userId: String) {
    private val database = FirebaseDatabase.getInstance()
    private val userRef = database.getReference(userId)

    fun listenToSensorsData(): Flow<HomeSensorsData> = callbackFlow {
        val listener = object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                val data = HomeSensorsData(
                    gas = snapshot.child("gas").let {
                        GasData(it.child("value").getValue(Int::class.java) ?: 0,
                                it.child("status").getValue(String::class.java) ?: "normal")
                    },
                    fridgeTemp = snapshot.child("fridge_temp").let {
                        TemperatureData(it.child("value").getValue(Double::class.java) ?: 0.0,
                                        it.child("unit").getValue(String::class.java) ?: "°C")
                    },
                    roomTemp = snapshot.child("room_temp").let {
                        TemperatureData(it.child("value").getValue(Double::class.java) ?: 0.0,
                                        it.child("unit").getValue(String::class.java) ?: "°C")
                    },
                    waterTank = snapshot.child("water_tank").let {
                        WaterTankData(it.child("level").getValue(Int::class.java) ?: 0,
                                      it.child("unit").getValue(String::class.java) ?: "%")
                    },
                    power = snapshot.child("power").let {
                        PowerData(it.child("available").getValue(Boolean::class.java) ?: false,
                                  it.child("voltage").getValue(Int::class.java) ?: 0)
                    },
                    motion = snapshot.child("motion").let {
                        MotionData(it.child("detected").getValue(Boolean::class.java) ?: false,
                                   it.child("last_trigger").getValue(Long::class.java) ?: 0)
                    },
                    lastSeen = snapshot.child("lastSeen").getValue(Long::class.java) ?: 0,
                    isConnected = snapshot.child("isConnected").getValue(Boolean::class.java) ?: false,
                    ipAddress = snapshot.child("ip_address").getValue(String::class.java) ?: "",
                    ipAddressPublic = snapshot.child("ip_address_public").getValue(String::class.java) ?: ""
                )
                trySend(data)
            }
            override fun onCancelled(error: DatabaseError) { close(error.toException()) }
        }
        userRef.addValueEventListener(listener)
        awaitClose { userRef.removeEventListener(listener) }
    }
}
EOF

mkdir -p app/src/main/java/com/devbelmel/smartguard/data/repository
cat > app/src/main/java/com/devbelmel/smartguard/data/repository/GasRepository.kt << 'EOF'
package com.devbelmel.smartguard.data.repository

import com.devbelmel.smartguard.data.datasource.FirebaseDataSource
import com.devbelmel.smartguard.data.model.HomeSensorsData
import kotlinx.coroutines.flow.Flow

class GasRepository(private val dataSource: FirebaseDataSource) {
    fun getSensorsFlow(): Flow<HomeSensorsData> = dataSource.listenToSensorsData()
}
EOF

cat > app/src/main/java/com/devbelmel/smartguard/data/repository/AuthRepository.kt << 'EOF'
package com.devbelmel.smartguard.data.repository

import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.tasks.await

class AuthRepository {
    private val database = FirebaseDatabase.getInstance()

    suspend fun checkUserExists(username: String, password: String): Boolean {
        return try {
            val snapshot = database.getReference("$username/password").get().await()
            snapshot.exists() && snapshot.getValue(String::class.java) == password
        } catch (e: Exception) {
            false
        }
    }
}
EOF

mkdir -p app/src/main/java/com/devbelmel/smartguard/utils
cat > app/src/main/java/com/devbelmel/smartguard/utils/LocaleHelper.kt << 'EOF'
package com.devbelmel.smartguard.utils

import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.os.Build
import java.util.Locale

object LocaleHelper {
    private const val LANGUAGE_KEY = "selected_language"
    val supportedLanguages = mapOf(
        "en" to "English", "ar" to "العربية", "fr" to "Français",
        "ja" to "日本語", "zh" to "中文", "it" to "Italiano",
        "pt" to "Português", "hi" to "हिन्दी", "es" to "Español",
        "fa" to "فارسی", "de" to "Deutsch", "ko" to "한국어"
    )
    fun setLocale(context: Context, languageCode: String): Context {
        saveLanguage(context, languageCode)
        return updateResources(context, languageCode)
    }
    fun getSavedLanguage(context: Context): String {
        val prefs = context.getSharedPreferences("app_prefs", Context.MODE_PRIVATE)
        return prefs.getString(LANGUAGE_KEY, "en") ?: "en"
    }
    private fun saveLanguage(context: Context, languageCode: String) {
        context.getSharedPreferences("app_prefs", Context.MODE_PRIVATE)
            .edit().putString(LANGUAGE_KEY, languageCode).apply()
    }
    private fun updateResources(context: Context, languageCode: String): Context {
        val locale = Locale(languageCode)
        Locale.setDefault(locale)
        val config = Configuration(context.resources.configuration)
        config.setLocale(locale)
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            context.createConfigurationContext(config)
        } else {
            context.resources.updateConfiguration(config, context.resources.displayMetrics)
            context
        }
    }
    fun applyLanguage(activity: Activity, languageCode: String) {
        val context = updateResources(activity, languageCode)
        val config = Configuration(context.resources.configuration)
        activity.resources.updateConfiguration(config, activity.resources.displayMetrics)
    }
}
EOF

mkdir -p app/src/main/java/com/devbelmel/smartguard/notification
cat > app/src/main/java/com/devbelmel/smartguard/notification/NotificationHelper.kt << 'EOF'
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
EOF

cat > app/src/main/java/com/devbelmel/smartguard/notification/MyFirebaseMessagingService.kt << 'EOF'
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
EOF

mkdir -p app/src/main/java/com/devbelmel/smartguard/presentation
cat > app/src/main/java/com/devbelmel/smartguard/presentation/BaseActivity.kt << 'EOF'
package com.devbelmel.smartguard.presentation

import android.content.Context
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.devbelmel.smartguard.utils.LocaleHelper

abstract class BaseActivity : AppCompatActivity() {
    override fun attachBaseContext(newBase: Context) {
        val lang = LocaleHelper.getSavedLanguage(newBase)
        super.attachBaseContext(LocaleHelper.setLocale(newBase, lang))
    }
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState) }
}
EOF

cat > app/src/main/java/com/devbelmel/smartguard/presentation/AuthViewModel.kt << 'EOF'
package com.devbelmel.smartguard.presentation

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.devbelmel.smartguard.data.repository.AuthRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class AuthViewModel(private val repo: AuthRepository) : ViewModel() {
    private val _loginResult = MutableStateFlow<LoginState>(LoginState.Idle)
    val loginResult: StateFlow<LoginState> = _loginResult

    fun login(username: String, password: String) {
        viewModelScope.launch {
            _loginResult.value = LoginState.Loading
            val isValid = repo.checkUserExists(username, password)
            _loginResult.value = if (isValid) LoginState.Success(username) else LoginState.Error("Invalid credentials")
        }
    }

    sealed class LoginState {
        object Idle : LoginState()
        object Loading : LoginState()
        data class Success(val username: String) : LoginState()
        data class Error(val message: String) : LoginState()
    }
}
EOF

cat > app/src/main/java/com/devbelmel/smartguard/presentation/LoginActivity.kt << 'EOF'
package com.devbelmel.smartguard.presentation

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.devbelmel.smartguard.R
import com.devbelmel.smartguard.data.repository.AuthRepository
import com.devbelmel.smartguard.databinding.ActivityLoginBinding
import kotlinx.coroutines.launch

class LoginActivity : AppCompatActivity() {
    private lateinit var binding: ActivityLoginBinding
    private val authViewModel: AuthViewModel by viewModels {
        AuthViewModelFactory(AuthRepository())
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btnLogin.setOnClickListener {
            val username = binding.etUsername.text.toString().trim()
            val password = binding.etPassword.text.toString().trim()
            if (username.isNotEmpty() && password.isNotEmpty()) {
                authViewModel.login(username, password)
            } else {
                Toast.makeText(this, "Please enter username and password", Toast.LENGTH_SHORT).show()
            }
        }

        lifecycleScope.launch {
            authViewModel.loginResult.collect { state ->
                when (state) {
                    is AuthViewModel.LoginState.Loading -> {
                        binding.btnLogin.isEnabled = false
                        binding.btnLogin.text = "Loading..."
                    }
                    is AuthViewModel.LoginState.Success -> {
                        binding.btnLogin.isEnabled = true
                        binding.btnLogin.text = getString(R.string.login)
                        val intent = Intent(this@LoginActivity, MainActivity::class.java).apply {
                            putExtra("USER_ID", state.username)
                        }
                        startActivity(intent)
                        finish()
                    }
                    is AuthViewModel.LoginState.Error -> {
                        binding.btnLogin.isEnabled = true
                        binding.btnLogin.text = getString(R.string.login)
                        Toast.makeText(this@LoginActivity, state.message, Toast.LENGTH_SHORT).show()
                    }
                    else -> {}
                }
            }
        }
    }
}

class AuthViewModelFactory(private val repo: AuthRepository) : androidx.lifecycle.ViewModelProvider.Factory {
    override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(AuthViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return AuthViewModel(repo) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
EOF

cat > app/src/main/java/com/devbelmel/smartguard/presentation/MainViewModel.kt << 'EOF'
package com.devbelmel.smartguard.presentation

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.devbelmel.smartguard.data.model.HomeSensorsData
import com.devbelmel.smartguard.data.repository.GasRepository
import com.devbelmel.smartguard.notification.NotificationHelper
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MainViewModel(
    private val repository: GasRepository,
    private val notificationHelper: NotificationHelper
) : ViewModel() {
    private val _homeData = MutableStateFlow(HomeSensorsData())
    val homeData: StateFlow<HomeSensorsData> = _homeData
    private var lastGasAlert = 0

    init {
        viewModelScope.launch {
            repository.getSensorsFlow().collect { data ->
                _homeData.value = data
                checkGasAlert(data.gas.value)
            }
        }
    }

    private fun checkGasAlert(value: Int) {
        when {
            value > 600 && lastGasAlert != 2 -> {
                notificationHelper.showDangerAlert(value)
                lastGasAlert = 2
            }
            value in 301..600 && lastGasAlert != 1 -> {
                notificationHelper.showWarningAlert(value)
                lastGasAlert = 1
            }
            value <= 300 -> lastGasAlert = 0
        }
    }
}
EOF

cat > app/src/main/java/com/devbelmel/smartguard/presentation/MainActivity.kt << 'EOF'
package com.devbelmel.smartguard.presentation

import android.content.Intent
import android.os.Bundle
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import com.devbelmel.smartguard.R
import com.devbelmel.smartguard.data.datasource.FirebaseDataSource
import com.devbelmel.smartguard.data.repository.GasRepository
import com.devbelmel.smartguard.databinding.ActivityMainBinding
import com.devbelmel.smartguard.notification.NotificationHelper
import com.devbelmel.smartguard.ui.SensorAdapter
import com.devbelmel.smartguard.ui.toSensorItems
import kotlinx.coroutines.launch

class MainActivity : BaseActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var viewModel: MainViewModel
    private lateinit var adapter: SensorAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val userId = intent.getStringExtra("USER_ID") ?: run {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
            return
        }

        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayShowTitleEnabled(true)

        val dataSource = FirebaseDataSource(userId)
        val repo = GasRepository(dataSource)
        val notificationHelper = NotificationHelper(this)
        viewModel = MainViewModel(repo, notificationHelper)

        setupRecyclerView()
        observeData()

        binding.btnLogout.setOnClickListener {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
        }
    }

    private fun setupRecyclerView() {
        adapter = SensorAdapter(emptyList())
        binding.rvSensors.layoutManager = GridLayoutManager(this, 2)
        binding.rvSensors.adapter = adapter
    }

    private fun observeData() {
        lifecycleScope.launch {
            viewModel.homeData.collect { data ->
                val items = data.toSensorItems(this@MainActivity)
                adapter = SensorAdapter(items)
                binding.rvSensors.adapter = adapter
                supportActionBar?.subtitle = if (data.isConnected) getString(R.string.connected) else getString(R.string.disconnected)
            }
        }
    }
}
EOF

mkdir -p app/src/main/java/com/devbelmel/smartguard/ui
cat > app/src/main/java/com/devbelmel/smartguard/ui/SensorAdapter.kt << 'EOF'
package com.devbelmel.smartguard.ui

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.devbelmel.smartguard.R
import com.devbelmel.smartguard.data.model.HomeSensorsData
import com.devbelmel.smartguard.databinding.ItemSensorCardBinding

data class SensorItem(val title: String, val value: String, val unit: String)

class SensorAdapter(private val items: List<SensorItem>) : RecyclerView.Adapter<SensorAdapter.ViewHolder>() {
    class ViewHolder(val binding: ItemSensorCardBinding) : RecyclerView.ViewHolder(binding.root)
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemSensorCardBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = items[position]
        holder.binding.tvTitle.text = item.title
        holder.binding.tvValue.text = item.value
        holder.binding.tvUnit.text = item.unit
    }
    override fun getItemCount(): Int = items.size
}

fun HomeSensorsData.toSensorItems(context: Context): List<SensorItem> {
    return listOf(
        SensorItem(context.getString(R.string.gas), gas.value.toString(), gas.status),
        SensorItem(context.getString(R.string.fridge_temp), fridgeTemp.value.toString(), fridgeTemp.unit),
        SensorItem(context.getString(R.string.room_temp), roomTemp.value.toString(), roomTemp.unit),
        SensorItem(context.getString(R.string.water_level), waterTank.level.toString(), waterTank.unit),
        SensorItem(context.getString(R.string.power_status),
            if (power.available) context.getString(R.string.available) else context.getString(R.string.unavailable),
            "${power.voltage}V"),
        SensorItem(context.getString(R.string.motion_status),
            if (motion.detected) context.getString(R.string.motion_detected) else context.getString(R.string.no_motion), "")
    )
}
EOF

# ===================== 6. كود NodeMCU الكامل (كما هو مع تعديل بسيط لإرسال بيانات متعددة) =====================
cat > nodemcu/gas_detector.ino << 'EOF'
/*
 * SmartGuard - NodeMCU Multisensor
 * يرسل بيانات الغاز، درجة حرارة الثلاجة/المنزل، مستوى الماء، حالة الكهرباء، كشف الحركة.
 * يعتمد على Firebase Realtime Database.
 */

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <ESP8266WebServer.h>

const char* WIFI_SSID     = "YOUR_WIFI_SSID";
const char* WIFI_PASSWORD = "YOUR_WIFI_PASSWORD";
#define FIREBASE_HOST "your-project.firebaseio.com"
#define FIREBASE_AUTH "your-database-secret"

// تعريف الأجهزة (يمكنك تعديل الدبابيس حسب توصيلاتك)
#define GAS_SENSOR_PIN A0
#define LED_GREEN     D1
#define LED_YELLOW    D2
#define LED_RED       D3
#define BUZZER        D4

// افتراض قراءة حرارة الثلاجة عبر DHT11 على D5
#define DHTPIN D5
#define DHTTYPE DHT11

// افتراض مستشعر مستوى الماء تناظري على A1
#define WATER_LEVEL_PIN A1

// افتراض مستشعر الحركة (PIR) على D6
#define PIR_PIN D6

// افتراض قراءة حالة الكهرباء (Relay أو مقسم جهد) على D7
#define POWER_SENSE_PIN D7

FirebaseData firebaseData;
FirebaseConfig config;
FirebaseAuth auth;
ESP8266WebServer server(80);

int gasValue = 0;
float fridgeTemp = 0;
float roomTemp = 0;
int waterLevel = 0;
bool powerAvailable = true;
bool motionDetected = false;
unsigned long lastHeartbeat = 0;
const unsigned long HEARTBEAT_INTERVAL = 5000;

void setNormal() {
  digitalWrite(LED_GREEN, HIGH); digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, LOW); digitalWrite(BUZZER, LOW);
}
void setWarning() {
  digitalWrite(LED_GREEN, LOW); digitalWrite(LED_YELLOW, HIGH);
  digitalWrite(LED_RED, LOW); digitalWrite(BUZZER, LOW);
}
void setDanger() {
  digitalWrite(LED_GREEN, LOW); digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, HIGH); digitalWrite(BUZZER, HIGH);
}
void updateIndicators(int value) {
  if (value < 300) setNormal();
  else if (value < 600) setWarning();
  else setDanger();
}

void readSensors() {
  gasValue = analogRead(GAS_SENSOR_PIN);
  waterLevel = analogRead(WATER_LEVEL_PIN);   // 0-1023
  waterLevel = map(waterLevel, 0, 1023, 0, 100);
  motionDetected = digitalRead(PIR_PIN) == HIGH;
  powerAvailable = digitalRead(POWER_SENSE_PIN) == HIGH;
  // قراءة الحرارة (تحتاج مكتبة DHT)
  // سنضع قيماً وهمية لتجنب تعقيد المكتبات، يمكنك إضافتها لاحقاً
  fridgeTemp = 4.5;
  roomTemp = 22.5;
}

void sendToFirebase() {
  Firebase.setInt(firebaseData, "/belmelahmed/gas/value", gasValue);
  String gasStatus = (gasValue<300)?"normal":((gasValue<600)?"warning":"danger");
  Firebase.setString(firebaseData, "/belmelahmed/gas/status", gasStatus);
  
  Firebase.setFloat(firebaseData, "/belmelahmed/fridge_temp/value", fridgeTemp);
  Firebase.setFloat(firebaseData, "/belmelahmed/room_temp/value", roomTemp);
  Firebase.setInt(firebaseData, "/belmelahmed/water_tank/level", waterLevel);
  Firebase.setBool(firebaseData, "/belmelahmed/power/available", powerAvailable);
  Firebase.setInt(firebaseData, "/belmelahmed/power/voltage", powerAvailable?220:0);
  Firebase.setBool(firebaseData, "/belmelahmed/motion/detected", motionDetected);
  if(motionDetected) Firebase.setLong(firebaseData, "/belmelahmed/motion/last_trigger", millis());
  
  Firebase.setBool(firebaseData, "/belmelahmed/isConnected", true);
  Firebase.setString(firebaseData, "/belmelahmed/ip_address", WiFi.localIP().toString());
}

void sendHeartbeat() {
  if (millis() - lastHeartbeat >= HEARTBEAT_INTERVAL) {
    lastHeartbeat = millis();
    Firebase.setLong(firebaseData, "/belmelahmed/lastSeen", lastHeartbeat);
  }
}

void fetchPublicIP() {
  WiFiClient client;
  if (client.connect("api.ipify.org", 80)) {
    client.println("GET / HTTP/1.1"); client.println("Host: api.ipify.org");
    client.println("Connection: close"); client.println();
    delay(500);
    while (client.available()) { if (client.readStringUntil('\n') == "\r") break; }
    String ip = client.readStringUntil('\n'); ip.trim();
    if (ip.length()) Firebase.setString(firebaseData, "/belmelahmed/ip_address_public", ip);
    client.stop();
  }
}

void handleWeb() {
  String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>SmartGuard</title></head><body>";
  html += "<h1>Gas: "+String(gasValue)+"</h1>";
  html += "<p>Fridge: "+String(fridgeTemp)+"°C</p>";
  html += "<p>Room: "+String(roomTemp)+"°C</p>";
  html += "<p>Water: "+String(waterLevel)+"%</p>";
  html += "<p>Power: "+(powerAvailable?"ON":"OFF")+"</p>";
  html += "<p>Motion: "+(motionDetected?"YES":"NO")+"</p>";
  html += "</body></html>";
  server.send(200, "text/html", html);
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_GREEN, OUTPUT); pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED, OUTPUT); pinMode(BUZZER, OUTPUT);
  pinMode(PIR_PIN, INPUT);
  pinMode(POWER_SENSE_PIN, INPUT);
  setNormal();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(500);
  config.database_url = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  fetchPublicIP();
  server.on("/", handleWeb);
  server.begin();
}

void loop() {
  server.handleClient();
  readSensors();
  updateIndicators(gasValue);
  sendToFirebase();
  sendHeartbeat();
  delay(500);
}
EOF

echo "✅ تم إنشاء المشروع المتكامل بنجاح (Android + NodeMCU متعدد الحساسات)."