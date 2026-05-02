package com.devbelmel.smartguard.presentation

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.devbelmel.smartguard.R
import com.devbelmel.smartguard.data.repository.AuthRepository
import com.devbelmel.smartguard.databinding.ActivityLoginBinding
import kotlinx.coroutines.launch

class LoginActivity : AppCompatActivity() {
    private lateinit var binding: ActivityLoginBinding
    private val authViewModel: AuthViewModel by viewModels {
        AuthViewModelFactory(AuthRepository())
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btnLogin.setOnClickListener {
            val username = binding.etUsername.text.toString().trim()
            val password = binding.etPassword.text.toString().trim()
            if (username.isNotEmpty() && password.isNotEmpty()) {
                authViewModel.login(username, password)
            } else {
                Toast.makeText(this, "Please enter username and password", Toast.LENGTH_SHORT).show()
            }
        }

        lifecycleScope.launch {
            authViewModel.loginResult.collect { state ->
                when (state) {
                    is AuthViewModel.LoginState.Loading -> {
                        binding.btnLogin.isEnabled = false
                        binding.btnLogin.text = "Loading..."
                    }
                    is AuthViewModel.LoginState.Success -> {
                        binding.btnLogin.isEnabled = true
                        binding.btnLogin.text = getString(R.string.login)
                        val intent = Intent(this@LoginActivity, MainActivity::class.java).apply {
                            putExtra("USER_ID", state.username)
                        }
                        startActivity(intent)
                        finish()
                    }
                    is AuthViewModel.LoginState.Error -> {
                        binding.btnLogin.isEnabled = true
                        binding.btnLogin.text = getString(R.string.login)
                        Toast.makeText(this@LoginActivity, state.message, Toast.LENGTH_SHORT).show()
                    }
                    else -> {}
                }
            }
        }
    }
}

class AuthViewModelFactory(private val repo: AuthRepository) : androidx.lifecycle.ViewModelProvider.Factory {
    override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(AuthViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return AuthViewModel(repo) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
