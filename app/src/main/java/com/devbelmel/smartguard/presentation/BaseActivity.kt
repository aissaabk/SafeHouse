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
