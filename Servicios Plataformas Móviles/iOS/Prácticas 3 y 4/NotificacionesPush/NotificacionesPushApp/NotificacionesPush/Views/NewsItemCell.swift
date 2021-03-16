

import UIKit

class NewsItemCell: UITableViewCell {
  func updateWithNewsItem(_ item:NewsItem) {
    self.textLabel?.text = item.title
    self.detailTextLabel?.text = DateParser.displayString(fordate:item.date)
  }
}
