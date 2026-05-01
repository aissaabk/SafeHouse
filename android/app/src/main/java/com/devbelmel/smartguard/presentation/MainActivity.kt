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
