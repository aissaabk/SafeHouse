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
