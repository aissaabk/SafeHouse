package com.devbelmel.smartguard.data.repository

import com.devbelmel.smartguard.data.datasource.FirebaseDataSource
import com.devbelmel.smartguard.data.model.HomeSensorsData
import kotlinx.coroutines.flow.Flow

class GasRepository(private val dataSource: FirebaseDataSource) {
    fun getSensorsFlow(): Flow<HomeSensorsData> = dataSource.listenToSensorsData()
}
