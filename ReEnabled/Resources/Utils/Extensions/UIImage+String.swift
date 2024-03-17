import UIKit

extension UIImage {
    var base64: String? {
        guard let data = jpegData(compressionQuality: 1)?.base64EncodedData() else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
