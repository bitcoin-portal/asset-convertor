import Foundation

public protocol AssetConverterInteractorProtocol {
    /// Get list of assetIdV2 compound keys.
    func getAssetList(provider: Provider) -> [String]
    /// Get provider specific compound key from assetIdV2 compound key.
    /// Check unit test for samples.
    func convertProviderAssetToAssetIdV2(asset: String, provider: Provider) -> String?
    /// Get assetIdV2 compound key from provider specific compound key.
    /// Check unit test for samples.
    func convertAssetIdV2ToProviderAsset(assetIdV2: String, provider: Provider) -> String?
}

public final class AssetConverterInteractor: AssetConverterInteractorProtocol {
    /// Dictionary data format Provider:  [ProviderAsset: AssetIdV2].
    private var providerAssetTo: ThreadSafeCache<Provider, [String: String]>
    /// Dictionary data format Provider:  [ AssetIdV2: ProviderAsset].
    private var reverseproviderAssetTo: ThreadSafeCache<Provider, [String: String]>

    public init() {
        providerAssetTo = ThreadSafeCache<Provider, [String: String]>()
        reverseproviderAssetTo = ThreadSafeCache<Provider, [String: String]>()
    }

    public func getAssetList(provider: Provider) -> [String] {
        let cachedAssets = providerAssetTo[provider]
        guard cachedAssets == nil else {
            return cachedAssets?.compactMap({ $0.value }) ?? []
        }
        let fetchedList = loadAssetList(provider: provider)!
        providerAssetTo[provider] = fetchedList
        return fetchedList.map({ $0.value })
    }

    public func convertProviderAssetToAssetIdV2(asset: String, provider: Provider) -> String? {
        let cachedAssets = providerAssetTo[provider]
        guard cachedAssets == nil else {
            return cachedAssets?[asset]
        }
        let fetchedList = loadAssetList(provider: provider)!
        providerAssetTo[provider] = fetchedList
        return fetchedList[asset]
    }

    public func convertAssetIdV2ToProviderAsset(assetIdV2: String, provider: Provider) -> String? {
        let cachedData = reverseproviderAssetTo[provider]
        guard cachedData == nil else {
            return cachedData?[assetIdV2]
        }
        var reverseAssetList = [String: String]()
        var cachedAssets = providerAssetTo[provider]
        if cachedAssets == nil {
            providerAssetTo[provider] = loadAssetList(provider: provider)!
            cachedAssets = providerAssetTo[provider]
        }
        for (key, value) in cachedAssets ?? [:] {
            reverseAssetList[value] = key
        }
        reverseproviderAssetTo[provider] = reverseAssetList
        return reverseAssetList[assetIdV2]
    }

    private func loadAssetList(provider: Provider) -> [String: String]? {
        let fileName = provider.rawValue
        guard let path = Bundle.module.path(forResource: fileName, ofType: "json") else {
            return nil
        }

        var convertList = [String: String]()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return nil
        }
        guard let providerAssetList = try? JSONDecoder().decode(ProviderAssetList.self, from: data) else {
            return nil
        }

        providerAssetList.assets.forEach { providerAsset in
            let assetId = providerAsset.assetId
            let blockchain = providerAsset.blockchain
            let assetProtocol = providerAsset.assetProtocol
            guard let convertKey = providerAsset.compoundKey ?? providerAsset.currencyCode else {
                return
            }
            convertList[convertKey] = "\(blockchain)-\(assetProtocol)-\(assetId)"
        }

        return convertList
    }
}
