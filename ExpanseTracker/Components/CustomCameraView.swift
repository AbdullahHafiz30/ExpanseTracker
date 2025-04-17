//
//  CustomCameraView.swift
//  ExpanseTracker
//
//  Created by Rawan on 19/10/1446 AH.
//
import SwiftUI
import UIKit // Need this because `UIImagePickerController` the system’s camera/photo picker is part of UIKit

/// UIViewControllerRepresentable to open the system camera
struct CustomCameraView: UIViewControllerRepresentable {
    
    //MARK: - Variables
    
    @Binding var imageData: Data?
    var errorHandler: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    // Cmaera controller
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        picker.showsCameraControls = true
        picker.modalPresentationStyle = .fullScreen
        picker.view.backgroundColor = .black
        
        // Force camera aspect ratio to better fit screen
        let screenSize = UIScreen.main.bounds.size
        let cameraAspectRatio: CGFloat = 4.0 / 3.0
        let screenAspectRatio = screenSize.height / screenSize.width
        let scale = screenAspectRatio / cameraAspectRatio
        picker.cameraViewTransform = CGAffineTransform(scaleX: scale, y: scale)
        
        return picker
    }
    // UIViewControllerRepresentable requires two methods: updateUIViewController and makeUIViewController so here we dont need to update anything after the camera is opened
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // The coordinator is used to communicate between UIKit and SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, errorHandler: errorHandler)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CustomCameraView
        let errorHandler: (String) -> Void
        
        init(parent: CustomCameraView, errorHandler: @escaping (String) -> Void) {
            self.parent = parent
            self.errorHandler = errorHandler
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Check if the captured media is an image
            if let image = info[.originalImage] as? UIImage {
                // Converts it to jpeg
                parent.imageData = image.jpegData(compressionQuality: 0.8)
            }
            parent.dismiss()
        }
        // If the user cancel just dismiss 
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
