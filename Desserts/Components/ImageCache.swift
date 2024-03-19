//
//  ImageCache.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/19/24.
//
//  Caching Images:
//  https://grokkingswift.io/caching-strategies-for-ios-applications/

import SwiftUI

/**
 `ImageCache` implements an in-memory image caching strategy using `NSCache`.
 
 `NSCache` primarily stores data in memory, meaning the data in NSCache is not saved to disk. If your app terminates, 
 the cache is cleared.
 */
class ImageCache {
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    static let shared = ImageCache()
    
    private init() {
        cache.countLimit = 100  // Maximum number of objects
        cache.totalCostLimit = 50 * 1024 * 1024  // 50 MB
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
