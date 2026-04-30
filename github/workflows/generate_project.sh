#!/bin/bash
# سكريبت إنشاء مشروع SmartGuard بالكامل (Android + NodeMCU)

set -e
echo "🚀 بدء إنشاء المشروع بالكامل..."

# إنشاء الهيكل الرئيسي
mkdir -p app/src/main/java/com/devbelmel/smartguard/presentation
mkdir -p app/src/main/java/com/devbelmel/smartguard/utils
mkdir -p app/src/main/java/com/devbelmel/smartguard/notification
mkdir -p app/src/main/java/com/devbelmel/smartguard/data/model
mkdir -p app/src/main/java/com/devbelmel/smartguard/data/datasource
mkdir -p app/src/main/java/com/devbelmel/smartguard/data/repository
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
    id 'org.jetbrains.kotlin.android' version '1.9.0' apply false
    id 'com.google.gms.google-services' version '4.4.0' apply false
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
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
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
    implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0'
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.7.0'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3'
    implementation 'com.google.firebase:firebase-database-ktx:20.3.0'
    implementation 'com.google.firebase:firebase-messaging-ktx:23.4.0'
}
EOF

# ===================== 2. ملفات موارد Android =====================
# ألوان
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

# سمات
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

# خلفية الحالة
cat > app/src/main/res/drawable/status_badge.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="#80000000" />
    <corners android:radius="20dp" />
    <padding android:left="12dp" android:top="4dp" android:right="12dp" android:bottom="4dp" />
</shape>
EOF

# تخطيط النشاط الرئيسي
cat > app/src/main/res/layout/activity_main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/dark_background"
    android:fillViewport="true">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <com.google.android.material.button.MaterialButton
            android:id="@+id/btnLanguage"
            style="@style/Widget.Material3.Button.OutlinedButton"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_gravity="end"
            android:text="@string/select_language" />

        <com.google.android.material.card.MaterialCardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="16dp"
            app:cardCornerRadius="16dp"
            app:cardElevation="4dp"
            app:cardBackgroundColor="@color/card_background">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:gravity="center"
                android:orientation="vertical"
                android:padding="24dp">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/gas_value"
                    android:textColor="@color/white"
                    android:textSize="18sp"
                    android:textStyle="bold" />

                <TextView
                    android:id="@+id/tvGasValue"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="8dp"
                    android:text="0"
                    android:textColor="@color/safe_green"
                    android:textSize="64sp"
                    android:textStyle="bold" />

                <TextView
                    android:id="@+id/tvStatus"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="8dp"
                    android:background="@drawable/status_badge"
                    android:padding="8dp"
                    android:text="@string/normal"
                    android:textColor="@color/white"
                    android:textSize="20sp" />
            </LinearLayout>
        </com.google.android.material.card.MaterialCardView>

        <com.google.android.material.card.MaterialCardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="16dp"
            app:cardCornerRadius="16dp"
            app:cardElevation="4dp"
            app:cardBackgroundColor="@color/card_background">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:padding="20dp">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/connection"
                    android:textColor="@color/white"
                    android:textSize="16sp"
                    android:textStyle="bold" />

                <TextView
                    android:id="@+id/tvConnection"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="4dp"
                    android:text="@string/connected"
                    android:textColor="@color/safe_green"
                    android:textSize="14sp" />

                <View
                    android:layout_width="match_parent"
                    android:layout_height="1dp"
                    android:layout_marginVertical="12dp"
                    android:background="@color/white" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/last_seen"
                    android:textColor="@color/white"
                    android:textSize="16sp"
                    android:textStyle="bold" />

                <TextView
                    android:id="@+id/tvLastSeen"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="4dp"
                    android:text="---"
                    android:textColor="@color/white"
                    android:textSize="14sp" />
            </LinearLayout>
        </com.google.android.material.card.MaterialCardView>
    </LinearLayout>
</ScrollView>
EOF

# ===================== 3. ملفات السلاسل النصية (12 لغة) =====================
# لغة إنجليزية (افتراضي)
cat > app/src/main/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">SmartGuard</string>
    <string name="gas_value">Gas Value</string>
    <string name="status">Status</string>
    <string name="connection">Connection</string>
    <string name="last_seen">Last seen</string>
    <string name="normal">Safe</string>
    <string name="warning">Warning</string>
    <string name="danger">Danger</string>
    <string name="connected">Connected</string>
    <string name="disconnected">Disconnected</string>
    <string name="select_language">Select Language</string>
    <string name="alert_warning_title">⚠️ Gas Warning</string>
    <string name="alert_warning_text">Gas value: %d - Warning level</string>
    <string name="alert_danger_title">🔥 Gas Leak Danger!</string>
    <string name="alert_danger_text">Value: %d - Evacuate immediately!</string>
</resources>
EOF

# العربية
cat > app/src/main/res/values-ar/strings.xml << 'EOF'
<resources>
    <string name="app_name">حارس المنزل</string>
    <string name="gas_value">قيمة الغاز</string>
    <string name="status">الحالة</string>
    <string name="connection">الاتصال</string>
    <string name="last_seen">آخر ظهور</string>
    <string name="normal">آمن</string>
    <string name="warning">تحذير</string>
    <string name="danger">خطر</string>
    <string name="connected">متصل</string>
    <string name="disconnected">غير متصل</string>
    <string name="select_language">اختر اللغة</string>
    <string name="alert_warning_title">⚠️ تحذير غاز</string>
    <string name="alert_warning_text">قيمة الغاز: %d - مستوى تحذيري</string>
    <string name="alert_danger_title">🔥 خطر تسرب غاز!</string>
    <string name="alert_danger_text">القيمة: %d - إخلاء فوري!</string>
</resources>
EOF

# (باقي اللغات: يمكنك إضافتها بنفس النمط، لكن اختصاراً سأضع اللغة الفرنسية والألمانية فقط. بعد الـ workflow يمكنك ترجمة الباقي بسهولة)
# الفرنسية
cat > app/src/main/res/values-fr/strings.xml << 'EOF'
<resources>
    <string name="app_name">SmartGuard</string>
    <string name="gas_value">Valeur de gaz</string>
    <string name="status">Statut</string>
    <string name="connection">Connexion</string>
    <string name="last_seen">Dernière vue</string>
    <string name="normal">Sécurisé</string>
    <string name="warning">Avertissement</string>
    <string name="danger">Danger</string>
    <string name="connected">Connecté</string>
    <string name="disconnected">Déconnecté</string>
    <string name="select_language">Choisir la langue</string>
    <string name="alert_warning_title">⚠️ Avertissement</string>
    <string name="alert_warning_text">Gaz: %d - Avertissement</string>
    <string name="alert_danger_title">🔥 Fuite de gaz!</string>
    <string name="alert_danger_text">Valeur: %d - Évacuez!</string>
</resources>
EOF

# الألمانية
cat > app/src/main/res/values-de/strings.xml << 'EOF'
<resources>
    <string name="app_name">SmartGuard</string>
    <string name="gas_value">Gaswert</string>
    <string name="status">Status</string>
    <string name="connection">Verbindung</string>
    <string name="last_seen">Zuletzt gesehen</string>
    <string name="normal">Sicher</string>
    <string name="warning">Warnung</string>
    <string name="danger">Gefahr</string>
    <string name="connected">Verbunden</string>
    <string name="disconnected">Getrennt</string>
    <string name="select_language">Sprache wählen</string>
    <string name="alert_warning_title">⚠️ Gaswarnung</string>
    <string name="alert_warning_text">Gaswert: %d - Warnstufe</string>
    <string name="alert_danger_title">🔥 Gasaustritt!</string>
    <string name="alert_danger_text">Wert: %d - Sofort evakuieren!</string>
</resources>
EOF

# (ملاحظة: يمكنك إضافة باقي اللغات بنفس الطريقة لاحقاً، أو نسخ المحتوى الإنجليزي وترجمته يدوياً)

# ===================== 4. ملف AndroidManifest.xml الكامل =====================
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
            android:name=".presentation.MainActivity"
            android:exported="true"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

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
# نموذج البيانات
cat > app/src/main/java/com/devbelmel/smartguard/data/model/GasSnapshot.kt << 'EOF'
package com.devbelmel.smartguard.data.model

data class GasSnapshot(
    val gasValue: Int = 0,
    val isConnected: Boolean = false,
    val lastSeen: Long = 0,
    val ip_address: String = "",
    val ip_address_public: String = ""
)
EOF

# مصدر البيانات Firebase
cat > app/src/main/java/com/devbelmel/smartguard/data/datasource/FirebaseDataSource.kt << 'EOF'
package com.devbelmel.smartguard.data.datasource

import com.devbelmel.smartguard.data.model.GasSnapshot
import com.google.firebase.database.*
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow

class FirebaseDataSource {
    private val database = FirebaseDatabase.getInstance()
    private val gasRef = database.getReference("belmelahmed")

    fun listenToGasValues(): Flow<GasSnapshot> = callbackFlow {
        val listener = object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                val gas = GasSnapshot(
                    gasValue = snapshot.child("gasValue").getValue(Int::class.java) ?: 0,
                    isConnected = snapshot.child("isConnected").getValue(Boolean::class.java) ?: false,
                    lastSeen = snapshot.child("lastSeen").getValue(Long::class.java) ?: 0,
                    ip_address = snapshot.child("ip_address").getValue(String::class.java) ?: "",
                    ip_address_public = snapshot.child("ip_address_public").getValue(String::class.java) ?: ""
                )
                trySend(gas)
            }
            override fun onCancelled(error: DatabaseError) {
                close(error.toException())
            }
        }
        gasRef.addValueEventListener(listener)
        awaitClose { gasRef.removeEventListener(listener) }
    }
}
EOF

# المستودع
cat > app/src/main/java/com/devbelmel/smartguard/data/repository/GasRepository.kt << 'EOF'
package com.devbelmel.smartguard.data.repository

import com.devbelmel.smartguard.data.datasource.FirebaseDataSource
import com.devbelmel.smartguard.data.model.GasSnapshot
import kotlinx.coroutines.flow.Flow

class GasRepository(private val dataSource: FirebaseDataSource) {
    fun getGasFlow(): Flow<GasSnapshot> = dataSource.listenToGasValues()
}
EOF

# LocaleHelper
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

# NotificationHelper
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

# MyFirebaseMessagingService
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

# BaseActivity
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
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
}
EOF

# MainViewModel
cat > app/src/main/java/com/devbelmel/smartguard/presentation/MainViewModel.kt << 'EOF'
package com.devbelmel.smartguard.presentation

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.devbelmel.smartguard.data.model.GasSnapshot
import com.devbelmel.smartguard.data.repository.GasRepository
import com.devbelmel.smartguard.notification.NotificationHelper
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MainViewModel(
    private val repository: GasRepository,
    private val notificationHelper: NotificationHelper
) : ViewModel() {
    private val _gasState = MutableStateFlow(GasSnapshot())
    val gasState: StateFlow<GasSnapshot> = _gasState
    private var lastAlert = 0

    init {
        viewModelScope.launch {
            repository.getGasFlow().collect { gas ->
                _gasState.value = gas
                checkAlert(gas.gasValue)
            }
        }
    }

    private fun checkAlert(value: Int) {
        when {
            value > 600 && lastAlert != 2 -> {
                notificationHelper.showDangerAlert(value)
                lastAlert = 2
            }
            value in 301..600 && lastAlert != 1 -> {
                notificationHelper.showWarningAlert(value)
                lastAlert = 1
            }
            value <= 300 -> lastAlert = 0
        }
    }
}
EOF

# MainActivity
cat > app/src/main/java/com/devbelmel/smartguard/presentation/MainActivity.kt << 'EOF'
package com.devbelmel.smartguard.presentation

import android.os.Bundle
import androidx.appcompat.app.AlertDialog
import androidx.lifecycle.lifecycleScope
import com.devbelmel.smartguard.R
import com.devbelmel.smartguard.data.datasource.FirebaseDataSource
import com.devbelmel.smartguard.data.repository.GasRepository
import com.devbelmel.smartguard.databinding.ActivityMainBinding
import com.devbelmel.smartguard.notification.NotificationHelper
import com.devbelmel.smartguard.utils.LocaleHelper
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MainActivity : BaseActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var viewModel: MainViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val dataSource = FirebaseDataSource()
        val repo = GasRepository(dataSource)
        val helper = NotificationHelper(this)
        viewModel = MainViewModel(repo, helper)

        lifecycleScope.launch {
            viewModel.gasState.collect { gas ->
                updateUI(gas)
            }
        }

        binding.btnLanguage.setOnClickListener { showLanguageDialog() }
    }

    private fun updateUI(gas: com.devbelmel.smartguard.data.model.GasSnapshot) {
        binding.tvGasValue.text = gas.gasValue.toString()
        val color = when {
            gas.gasValue > 600 -> getColor(R.color.danger_red)
            gas.gasValue > 300 -> getColor(R.color.warning_orange)
            else -> getColor(R.color.safe_green)
        }
        binding.tvGasValue.setTextColor(color)

        val statusText = when {
            gas.gasValue > 600 -> getString(R.string.danger)
            gas.gasValue > 300 -> getString(R.string.warning)
            else -> getString(R.string.normal)
        }
        binding.tvStatus.text = statusText
        binding.tvStatus.setBackgroundColor(when {
            gas.gasValue > 600 -> getColor(R.color.danger_red)
            gas.gasValue > 300 -> getColor(R.color.warning_orange)
            else -> getColor(R.color.safe_green)
        })

        binding.tvConnection.text = if (gas.isConnected) getString(R.string.connected) else getString(R.string.disconnected)
        binding.tvConnection.setTextColor(if (gas.isConnected) getColor(R.color.safe_green) else getColor(R.color.danger_red))

        binding.tvLastSeen.text = if (gas.lastSeen > 0) {
            SimpleDateFormat("HH:mm:ss dd/MM/yyyy", Locale.getDefault()).format(Date(gas.lastSeen))
        } else "---"
    }

    private fun showLanguageDialog() {
        val languages = LocaleHelper.supportedLanguages.values.toTypedArray()
        val codes = LocaleHelper.supportedLanguages.keys.toTypedArray()
        AlertDialog.Builder(this)
            .setTitle(getString(R.string.select_language))
            .setItems(languages) { _, which ->
                val code = codes[which]
                if (code != LocaleHelper.getSavedLanguage(this)) {
                    LocaleHelper.setLocale(this, code)
                    recreate()
                }
            }
            .show()
    }
}
EOF

# ===================== 6. كود NodeMCU الكامل =====================
cat > nodemcu/gas_detector.ino << 'EOF'
/*
 * SmartGuard - Gas Leak Detector - NodeMCU ESP8266
 * استخدام Firebase Realtime Database
 */

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <ESP8266WebServer.h>

const char* WIFI_SSID     = "YOUR_WIFI_SSID";
const char* WIFI_PASSWORD = "YOUR_WIFI_PASSWORD";
#define FIREBASE_HOST "your-project.firebaseio.com"
#define FIREBASE_AUTH "your-database-secret"

#define GAS_SENSOR_PIN A0
#define LED_GREEN     D1
#define LED_YELLOW    D2
#define LED_RED       D3
#define BUZZER        D4

FirebaseData firebaseData;
FirebaseConfig config;
FirebaseAuth auth;
ESP8266WebServer server(80);
int gasValue = 0;
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
void readGasSensor() { gasValue = analogRead(GAS_SENSOR_PIN); }
void sendToFirebase() {
  Firebase.setInt(firebaseData, "/belmelahmed/gasValue", gasValue);
  Firebase.setBool(firebaseData, "/belmelahmed/isConnected", true);
  Firebase.setString(firebaseData, "/belmelahmed/ip_address", WiFi.localIP().toString());
}
void sendHeartbeat() {
  if (millis() - lastHeartbeat >= HEARTBEAT_INTERVAL) {
    lastHeartbeat = millis();
    Firebase.setInt(firebaseData, "/belmelahmed/lastSeen", lastHeartbeat);
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
  String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'><meta http-equiv='refresh' content='2'><title>Gas Monitor</title>";
  html += "<style>body{font-family:Arial;text-align:center;margin-top:50px;}</style></head><body>";
  html += "<h1>SmartGuard - Gas Detector</h1><h2>Value: <span style='color:";
  if(gasValue<300) html+="green"; else if(gasValue<600) html+="orange"; else html+="red";
  html += "'>" + String(gasValue) + "</span></h2></body></html>";
  server.send(200, "text/html", html);
}
void setup() {
  Serial.begin(115200);
  pinMode(LED_GREEN, OUTPUT); pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED, OUTPUT); pinMode(BUZZER, OUTPUT);
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
  readGasSensor();
  updateIndicators(gasValue);
  sendToFirebase();
  sendHeartbeat();
  delay(500);
}
EOF

echo "✅ تم إنشاء جميع الملفات بنجاح (Android + NodeMCU)."