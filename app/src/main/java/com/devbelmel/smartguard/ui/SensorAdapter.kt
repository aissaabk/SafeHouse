package com.devbelmel.smartguard.ui

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.devbelmel.smartguard.R
import com.devbelmel.smartguard.data.model.HomeSensorsData
import com.devbelmel.smartguard.databinding.ItemSensorCardBinding

data class SensorItem(val title: String, val value: String, val unit: String)

class SensorAdapter(private val items: List<SensorItem>) : RecyclerView.Adapter<SensorAdapter.ViewHolder>() {
    class ViewHolder(val binding: ItemSensorCardBinding) : RecyclerView.ViewHolder(binding.root)
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemSensorCardBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = items[position]
        holder.binding.tvTitle.text = item.title
        holder.binding.tvValue.text = item.value
        holder.binding.tvUnit.text = item.unit
    }
    override fun getItemCount(): Int = items.size
}

fun HomeSensorsData.toSensorItems(context: Context): List<SensorItem> {
    return listOf(
        SensorItem(context.getString(R.string.gas), gas.value.toString(), gas.status),
        SensorItem(context.getString(R.string.fridge_temp), fridgeTemp.value.toString(), fridgeTemp.unit),
        SensorItem(context.getString(R.string.room_temp), roomTemp.value.toString(), roomTemp.unit),
        SensorItem(context.getString(R.string.water_level), waterTank.level.toString(), waterTank.unit),
        SensorItem(context.getString(R.string.power_status),
            if (power.available) context.getString(R.string.available) else context.getString(R.string.unavailable),
            "${power.voltage}V"),
        SensorItem(context.getString(R.string.motion_status),
            if (motion.detected) context.getString(R.string.motion_detected) else context.getString(R.string.no_motion), "")
    )
}
