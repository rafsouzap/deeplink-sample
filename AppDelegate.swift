// Sample

func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    return DeepLinkManager.shared.parseURL(url: URL(string: uniqueIdentififer)!)
}