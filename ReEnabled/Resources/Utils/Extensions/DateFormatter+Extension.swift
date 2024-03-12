import Foundation

extension DateFormatter {
    static var hoursMinutesDateFormatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
}
