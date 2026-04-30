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
