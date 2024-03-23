import UIKit

extension String {
    var uiImageFromBase64: UIImage? {
        guard let data = Data(base64Encoded: self),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
