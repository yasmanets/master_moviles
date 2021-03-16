
import UIKit

final class NewsItem: NSObject {
  let title: String
  let date: Date

  init(title: String, date: Date) {
    self.title = title
    self.date = date
  }
}

extension NewsItem: NSCoding {
  struct CodingKeys {
    static let Title = "title"
    static let Date = "date"
  }

  convenience init?(coder aDecoder: NSCoder) {
    if let title = aDecoder.decodeObject(forKey: CodingKeys.Title) as? String,
      let date = aDecoder.decodeObject(forKey: CodingKeys.Date) as? Date {
        self.init(title: title, date: date)
    } else {
      return nil
    }
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(title, forKey: CodingKeys.Title)
    aCoder.encode(date, forKey: CodingKeys.Date)
  }
}
