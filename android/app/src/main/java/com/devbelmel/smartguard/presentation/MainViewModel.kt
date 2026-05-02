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
