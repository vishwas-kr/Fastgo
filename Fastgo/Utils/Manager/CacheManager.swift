import UIKit

@MainActor
final class CacheManager {
    
    static let shared = CacheManager()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    private init() {
        memoryCache.countLimit = 50
    }
    
    func save(image: UIImage, forKey key: String) {
        let cacheKey = NSString(string: key)
        memoryCache.setObject(image, forKey: cacheKey)
        saveToDisk(image: image, key: cacheKey)
    }
    
    func image(forKey key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        
        // 1️⃣ Memory
        if let image = memoryCache.object(forKey: cacheKey) {
            return image
        }
        
        // 2️⃣ Disk
        if let image = loadFromDisk(key: cacheKey) {
            memoryCache.setObject(image, forKey: cacheKey)
            return image
        }
        
        return nil
    }
    
    func remove(forKey key: String) {
        let cacheKey = NSString(string: key)
        memoryCache.removeObject(forKey: cacheKey)
        removeFromDisk(key: cacheKey)
    }
    
    func removeAll() {
        memoryCache.removeAllObjects()
        clearDiskCache()
    }
    
    
    private func diskURL(for key: NSString) -> URL {
        fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(key as String)
    }
    
    private func saveToDisk(image: UIImage, key: NSString) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        try? data.write(to: diskURL(for: key))
    }
    
    private func loadFromDisk(key: NSString) -> UIImage? {
        let url = diskURL(for: key)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    private func removeFromDisk(key: NSString) {
        try? fileManager.removeItem(at: diskURL(for: key))
    }
    
    private func clearDiskCache() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        try? fileManager.removeItem(at: cacheDir)
    }
}

