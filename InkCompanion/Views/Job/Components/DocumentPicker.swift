import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    var callback: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(callback: callback)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var callback: (URL) -> Void

        init(callback: @escaping (URL) -> Void) {
            self.callback = callback
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            callback(url)
        }
    }
}
