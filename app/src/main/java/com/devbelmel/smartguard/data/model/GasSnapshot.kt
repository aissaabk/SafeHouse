package com.devbelmel.smartguard.data.model

data class GasSnapshot(
    val gasValue: Int = 0,
    val isConnected: Boolean = false,
    val lastSeen: Long = 0,
    val ip_address: String = "",
    val ip_address_public: String = ""
)
