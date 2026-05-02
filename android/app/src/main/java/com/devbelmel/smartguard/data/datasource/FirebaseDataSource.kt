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
