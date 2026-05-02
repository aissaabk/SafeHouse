package com.devbelmel.smartguard.presentation

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.devbelmel.smartguard.data.repository.AuthRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class AuthViewModel(private val repo: AuthRepository) : ViewModel() {
    private val _loginResult = MutableStateFlow<LoginState>(LoginState.Idle)
    val loginResult: StateFlow<LoginState> = _loginResult

    fun login(username: String, password: String) {
        viewModelScope.launch {
            _loginResult.value = LoginState.Loading
            val isValid = repo.checkUserExists(username, password)
            _loginResult.value = if (isValid) LoginState.Success(username) else LoginState.Error("Invalid credentials")
        }
    }

    sealed class LoginState {
        object Idle : LoginState()
        object Loading : LoginState()
        data class Success(val username: String) : LoginState()
        data class Error(val message: String) : LoginState()
    }
}
