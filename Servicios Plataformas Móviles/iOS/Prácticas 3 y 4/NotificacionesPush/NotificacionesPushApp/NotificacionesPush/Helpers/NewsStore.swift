

import UIKit

class NewsStore: NSObject {
  static let sharedStore = NewsStore()

  var items: [NewsItem] = []

  override init() {
    super.init()
    self.loadItemsFromCache()
  }

  func addItem(_ newItem: NewsItem) {
    items.insert(newItem, at: 0)
    saveItemsToCache()
  }
}


// MARK: Persistance
extension NewsStore {
  func saveItemsToCache() {
    NSKeyedArchiver.archiveRootObject(items, toFile: itemsCachePath)
  }

  func loadItemsFromCache() {
    if let cachedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemsCachePath) as? [NewsItem] {
      items = cachedItems
    }
  }

  var itemsCachePath: String {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent("news.dat")
    return fileURL.path
  }
}
