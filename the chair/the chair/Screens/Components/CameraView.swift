//
//  CameraView.swift
//  the chair
//
//  Created by Aulia Nadhirah Yasmin Badrulkamal on 21/08/26.
//

import SwiftUI
import UIKit

extension UIImage {
    var squared: UIImage? {
        guard let cgImage = cgImage else { return nil }
        let length = min(cgImage.width, cgImage.height)
        let x = cgImage.width / 2 - length / 2
        let y = cgImage.height / 2 - length / 2
        let cropRect = CGRect(x: x, y: y, width: length, height: length)
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else {  return nil }
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        
        let overlay = SquareGuideOverlayView(frame: picker.view.bounds)
        overlay.backgroundColor = .clear
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        picker.cameraOverlayView = overlay
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // NO UPDATES NEEDED
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        init(_ parent: CameraView) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image.squared
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
