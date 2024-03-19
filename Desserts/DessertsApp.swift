//
//  DessertsApp.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Configure URLCache
        let memoryCapacity = 50 * 1024 * 1024  // 50 MB
        let diskCapacity = 150 * 1024 * 1024  // 150 MB
        let cacheDirectory = "DessertsCache"
        let urlCache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: cacheDirectory
        )
        URLCache.shared = urlCache
        return true
    }
}

@main
struct DessertsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            DessertsView()
        }
    }
}
