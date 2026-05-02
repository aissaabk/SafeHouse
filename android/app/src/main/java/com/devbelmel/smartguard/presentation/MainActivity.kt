package com.devbelmel.smartguard.presentation

import android.content.Intent
import android.os.Bundle
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import com.devbelmel.smartguard.R
import com.devbelmel.smartguard.data.datasource.FirebaseDataSource
import com.devbelmel.smartguard.data.repository.GasRepository
import com.devbelmel.smartguard.databinding.ActivityMainBinding
import com.devbelmel.smartguard.notification.NotificationHelper
import com.devbelmel.smartguard.ui.SensorAdapter
import com.devbelmel.smartguard.ui.toSensorItems
import kotlinx.coroutines.launch

class MainActivity : BaseActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var viewModel: MainViewModel
    private lateinit var adapter: SensorAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val userId = intent.getStringExtra("USER_ID") ?: run {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
            return
        }

        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayShowTitleEnabled(true)

        val dataSource = FirebaseDataSource(userId)
        val repo = GasRepository(dataSource)
        val notificationHelper = NotificationHelper(this)
        viewModel = MainViewModel(repo, notificationHelper)

        setupRecyclerView()
        observeData()

        binding.btnLogout.setOnClickListener {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
        }
    }

    private fun setupRecyclerView() {
        adapter = SensorAdapter(emptyList())
        binding.rvSensors.layoutManager = GridLayoutManager(this, 2)
        binding.rvSensors.adapter = adapter
    }

    private fun observeData() {
        lifecycleScope.launch {
            viewModel.homeData.collect { data ->
                val items = data.toSensorItems(this@MainActivity)
                adapter = SensorAdapter(items)
                binding.rvSensors.adapter = adapter
                supportActionBar?.subtitle = if (data.isConnected) getString(R.string.connected) else getString(R.string.disconnected)
            }
        }
    }
}