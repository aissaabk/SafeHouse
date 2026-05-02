package com.devbelmel.smartguard.data.repository

import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.tasks.await

class AuthRepository {
    private val database = FirebaseDatabase.getInstance()

    suspend fun checkUserExists(username: String, password: String): Boolean {
        return try {
            val snapshot = database.getReference("$username/password").get().await()
            snapshot.exists() && snapshot.getValue(String::class.java) == password
        } catch (e: Exception) {
            false
        }
    }
}
