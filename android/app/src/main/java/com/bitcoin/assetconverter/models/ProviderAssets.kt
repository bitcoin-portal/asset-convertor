package com.bitcoin.assetconverter.models

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonNames

@Serializable
data class ProviderAssets(val assets: List<Assets>) {

    @OptIn(ExperimentalSerializationApi::class)
    @Serializable
    data class Assets(
        @JsonNames("compound_key", "currency_code") val providerKey: String,
        @JsonNames("asset_id") val assetId: String,
        @JsonNames("android_blockchain") val blockchain: String,
        @JsonNames("android_asset_protocol") val assetProtocol: String
    )
}
