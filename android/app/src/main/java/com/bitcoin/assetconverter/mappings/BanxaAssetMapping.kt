package com.bitcoin.assetconverter.mappings

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonNames

@Serializable
data class BanxaAssetMapping(
    val assets: List<Assets>
): AssetMapping() {
    @OptIn(ExperimentalSerializationApi::class)
    @Serializable
    data class Assets (
        @JsonNames("compound_key") val compoundKey: String,
        @JsonNames("asset_id") val assetId: String,
        @JsonNames("android_blockchain") val blockchain: String,
        @JsonNames("android_asset_protocol") val assetProtocol: String
    )
}