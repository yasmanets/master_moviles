

import UIKit

class DateParser: NSObject {
    static let dateFormatter = { (void) -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }(())

  //Wed, 04 Nov 2015 21:00:14 +0000
  static func dateWithPodcastDateString(_ dateString: String) -> Date? {
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    return dateFormatter.date(from: dateString)
  }

  static func displayString(fordate date: Date) -> String {
    dateFormatter.dateFormat = "HH:mm MMMM dd, yyyy"
    return dateFormatter.string(from: date)
  }
}

