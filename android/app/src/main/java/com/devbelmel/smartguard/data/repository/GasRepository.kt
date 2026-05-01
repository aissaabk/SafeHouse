package com.devbelmel.smartguard.data.repository

import com.devbelmel.smartguard.data.datasource.FirebaseDataSource
import com.devbelmel.smartguard.data.model.GasSnapshot
import kotlinx.coroutines.flow.Flow

class GasRepository(private val dataSource: FirebaseDataSource) {
    fun getGasFlow(): Flow<GasSnapshot> = dataSource.listenToGasValues()
}
