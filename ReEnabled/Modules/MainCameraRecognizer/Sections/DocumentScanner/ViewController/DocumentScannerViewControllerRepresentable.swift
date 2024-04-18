import SwiftUI
import VisionKit

@MainActor
struct DocumentScannerViewControllerRepresentable: UIViewControllerRepresentable {
    private var documentScannerViewModel: DocumentScannerViewModel
    
    init(documentScannerViewModel: DocumentScannerViewModel) {
        self.documentScannerViewModel = documentScannerViewModel
    }
    
    static let textDataType: DataScannerViewController.RecognizedDataType = .text(
        languages: [
            SupportedLanguage.english.identifier,
            SupportedLanguage.polish.identifier
        ]
    )
    
    private var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [textDataType, .barcode()],
        qualityLevel: .accurate,
        recognizesMultipleItems: true,
        isHighFrameRateTrackingEnabled: true,
        isPinchToZoomEnabled: false,
        isGuidanceEnabled: true,
        isHighlightingEnabled: true
    )
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        scannerViewController.delegate = context.coordinator
        
        try? scannerViewController.startScanning()
        
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self,
                           documentScannerViewModel: documentScannerViewModel)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        private var documentScannerViewModel: DocumentScannerViewModel
        var parent: DocumentScannerViewControllerRepresentable
        var roundBoxMappings: [UUID: UIView] = [:]
        
        init(_ parent: DocumentScannerViewControllerRepresentable,
             documentScannerViewModel: DocumentScannerViewModel) {
            self.parent = parent
            self.documentScannerViewModel = documentScannerViewModel
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processAddedItems(items: addedItems)
            removeExpiredObservations()
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processRemovedItems(items: removedItems)
            removeExpiredObservations()
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processUpdatedItems(items: updatedItems)
            removeExpiredObservations()
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            processItem(item: item)
        }
        
        func processAddedItems(items: [RecognizedItem]) {
            for item in items {
                processItem(item: item)
            }
        }
        
        func removeExpiredObservations() {
            let observationsCount: Int = documentScannerViewModel.detectedTexts.count + documentScannerViewModel.detectedBarCodesStringValues.count
            if roundBoxMappings.keys.count < observationsCount {
                documentScannerViewModel.detectedTexts.removeAll()
                documentScannerViewModel.detectedBarCodesStringValues.removeAll()
            }
        }
        
        func processRemovedItems(items: [RecognizedItem]) {
            for item in items {
                removeRoundBoxFromItem(item: item)
                
                switch item {
                case .text(let text):
                    documentScannerViewModel.detectedTexts.remove(text.transcript)
                case .barcode(let code):
                    guard let codeStringValue = code.payloadStringValue else {
                        return
                    }
                    
                    documentScannerViewModel.detectedBarCodesStringValues.remove(codeStringValue)
                @unknown default:
                    break
                }
            }
        }
        
        func processUpdatedItems(items: [RecognizedItem]) {
            for item in items {
                updateRoundBoxToItem(item: item)
            }
        }
        
        func addRoundBoxToItem(frame: CGRect, text: String, item: RecognizedItem) {
            let roundedRectView = RoundedRectLabel(frame: frame)
            roundedRectView.setText(text: text)
            parent.scannerViewController.overlayContainerView.addSubview(roundedRectView)
            roundBoxMappings[item.id] = roundedRectView
        }
        
        func removeRoundBoxFromItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
                    roundBoxView.removeFromSuperview()
                    roundBoxMappings.removeValue(forKey: item.id)
                }
            }
        }
        
        func updateRoundBoxToItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
                    let frame = getRoundBoxFrame(item: item)
                    roundBoxView.frame = frame
                }
            }
        }
        
        func getRoundBoxFrame(item: RecognizedItem) -> CGRect {
            let frame = CGRect(
                x: item.bounds.topLeft.x,
                y: item.bounds.topLeft.y,
                width: abs(item.bounds.topRight.x - item.bounds.topLeft.x) + 15,
                height: abs(item.bounds.topLeft.y - item.bounds.bottomLeft.y) + 15
            )
            return frame
        }
        
        func processItem(item: RecognizedItem) {
            switch item {
            case .text(let text):
                let frame = getRoundBoxFrame(item: item)
                addRoundBoxToItem(frame: frame, text: text.transcript, item: item)
                documentScannerViewModel.detectedTexts.insert(text.transcript)
            case .barcode(let code):
                guard let codeStringValue = code.payloadStringValue else {
                    return
                }
                
                documentScannerViewModel.detectedBarCodesStringValues.insert(codeStringValue)
            @unknown default:
                break
            }
        }
    }
}
