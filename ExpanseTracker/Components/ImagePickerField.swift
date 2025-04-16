//
//  ImagePickerField.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//
import SwiftUI
import PhotosUI
import AVFoundation

struct ImagePickerField: View {
    //MARK: - Variables
    @Binding var imageData: Data?
    @State private var showImageSourcePicker = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var cameraError: String?
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showCustomPicker = false
    var image: String
    
    var body: some View {
        //MARK: - View
        VStack {
            // Photo field
            Button(action: {
                showCustomPicker = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(themeManager.textColor, lineWidth: 1)
                        .frame(height: (imageData == nil) && (image == "") ? 48 : 350)
                    
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                        
                    } else if image != "" {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                    else {
                        HStack {
                            Text("Receipt image")
                                .foregroundColor(themeManager.textColor.opacity(0.5))
                                .padding(.leading)
                            Spacer()
                            Image(systemName: "photo")
                                .foregroundColor(themeManager.textColor)
                                .padding(.trailing)
                        }
                    }
                }
            }
            // Sheet to pick image or use the camera
            .sheet(isPresented: $showCustomPicker) {
                
                HStack(spacing: 20) {
                    // Camera Button
                    Button(action: {
                        checkCameraPermission()
                        showCustomPicker = false
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.backgroundColor)
                                .frame(width: 130, height: 130)
                                .shadow(radius: 5)
                            VStack{
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(themeManager.textColor)
                                Text("Camera")
                                    .foregroundColor(themeManager.textColor)
                            }
                        }
                    }
                    
                    // Photo Library Button
                    Button(action: {
                        showPhotoLibrary = true
                        showCustomPicker = false
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(themeManager.backgroundColor)
                                .frame(width: 130, height: 130)
                                .shadow(radius: 5)
                            VStack{
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(themeManager.textColor)
                                Text("Gallery")
                                    .foregroundColor(themeManager.textColor)
                            }
                        }
                    }
                }
                
                .padding()
                .presentationDetents([.height(200)])
                .cornerRadius(16)
            }
            
            
            .alert("Camera Error", isPresented: .constant(cameraError != nil), actions: {
                Button("OK", role: .cancel) { cameraError = nil }
            }, message: {
                Text(cameraError ?? "")
            })
            
            .photosPicker(
                isPresented: $showPhotoLibrary,
                selection: .init(
                    get: { nil },
                    set: { newItem in
                        if let newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            }
                        }
                    }
                ),
                matching: .images,
                photoLibrary: .shared()
            )
            
            .fullScreenCover(isPresented: $showCamera) {
                CustomCameraView(imageData: $imageData, errorHandler: { error in
                    cameraError = error
                    showCamera = false
                })
            }
        }
    }
    
    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                showCamera = true
            } else {
                cameraError = "Camera not available on this device"
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted && UIImagePickerController.isCameraDeviceAvailable(.rear) {
                        showCamera = true
                    } else {
                        cameraError = granted ? "Camera not available" : "Camera access denied"
                    }
                }
            }
        default:
            cameraError = "Please enable camera access in Settings"
        }
    }
}

struct CustomCameraView: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    var errorHandler: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        picker.showsCameraControls = true
        picker.modalPresentationStyle = .fullScreen
        picker.view.backgroundColor = .black
        // Fix the size of the camera
        let screenSize = UIScreen.main.bounds.size
        let cameraAspectRatio: CGFloat = 4.0 / 3.0
        let screenAspectRatio = screenSize.height / screenSize.width
        let scale = screenAspectRatio / cameraAspectRatio
        
        picker.cameraViewTransform = CGAffineTransform(scaleX: scale, y: scale)
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, errorHandler: errorHandler)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CustomCameraView
        let errorHandler: (String) -> Void// Closure to handle error reporting
        
        init(parent: CustomCameraView, errorHandler: @escaping (String) -> Void) {
            self.parent = parent
            self.errorHandler = errorHandler
        }
        // Called when the user successfully picks a photo using the camera
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.8)
            }
            // Dismiss the camera view
            parent.dismiss()
        }
        // Called when the user cancels the image picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

