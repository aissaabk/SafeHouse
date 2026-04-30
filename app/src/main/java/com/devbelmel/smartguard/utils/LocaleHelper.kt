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
