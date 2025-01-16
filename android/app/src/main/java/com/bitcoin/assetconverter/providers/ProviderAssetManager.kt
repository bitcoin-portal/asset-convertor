package com.bitcoin.assetconverter.providers

import android.content.Context
import com.bitcoin.assetconverter.models.ProviderAssets
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.decodeFromStream

class ProviderAssetManager(private val context: Context){

    private val assets: MutableMap<ProviderType, List<ProviderAssets.Assets>> = mutableMapOf()
    private val json = Json { ignoreUnknownKeys = true }

    suspend fun preloadAssets() = withContext(Dispatchers.IO) {
        ProviderType.values().forEach { provider ->
            assets[provider] = loadAssets(provider)
        }
    }

    @OptIn(ExperimentalSerializationApi::class)
    private fun loadAssets(provider: ProviderType): List<ProviderAssets.Assets> {
        return try {
            context.assets.open(provider.resource).use { inputStream ->
                val assetMapping: ProviderAssets = json.decodeFromStream(inputStream)
                assetMapping.assets
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    fun getAssets(provider: ProviderType): List<ProviderAssets.Assets> {
        return assets[provider] ?: emptyList()
    }
}
