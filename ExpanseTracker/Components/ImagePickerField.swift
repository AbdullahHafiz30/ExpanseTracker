//
//  ImagePickerField.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//
import SwiftUI
import PhotosUI // Need this to use PhotosPicker
import AVFoundation // Need this to use camera

/// Custom field that allows the user to pick an image from gallery or take one with the camera.
struct ImagePickerField: View {
    
    // MARK: - Variables
    
    @Binding var imageData: Data?
    @State private var showImageSourcePicker = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var cameraError: String?
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showCustomPicker = false
    var image: String
    var currentLanguage: String
    
    // MARK: - View
    var body: some View {
        VStack {
            // Image Display Button
            Button(action: {
                showCustomPicker = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(themeManager.textColor, lineWidth: 1)
                        .frame(height: (imageData == nil) && (image == "") ? 48 : 350)
                    
                    // Case 1: Image picked as Data
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                        
                        // Case 2: Static Image string
                    } else if image != "" {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                        
                        // Case 3: Empty
                    } else {
                        HStack {
                            Text("ReceiptImage".localized(using: currentLanguage))
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
            
            // MARK: - Sheet: Choose Image Source
            .sheet(isPresented: $showCustomPicker) {
                ImageSourcePickerView(
                    onCameraTap: {
                        checkCameraPermission()
                        showCustomPicker = false
                    },
                    onGalleryTap: {
                        showPhotoLibrary = true
                        showCustomPicker = false
                    }
                )
            }
            
            // MARK: - Alert for Camera Error
            .alert("Camera Error", isPresented: .constant(cameraError != nil), actions: {
                Button("OK", role: .cancel) { cameraError = nil }
            }, message: {
                Text(cameraError ?? "")
            })
            
            // MARK: - Photos Picker (Gallery)
            .photosPicker(
                isPresented: $showPhotoLibrary,
                selection: .init(
                    get: { nil }, // We dont get anything back from it
                    set: { newItem in
                        if let newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            }
                        }
                    } // We set an image in it and get the data of this image saved to imageData
                ),
                matching: .images, // Only present images
                photoLibrary: .shared() //User the default system library
            )
            
            // MARK: - Full Screen Camera
            .fullScreenCover(isPresented: $showCamera) {
                CustomCameraView(imageData: $imageData, errorHandler: { error in
                    cameraError = error
                    showCamera = false
                })
            }
        }
    }
    
    // MARK: - Permission Logic
    private func checkCameraPermission() {
        // Access the camera hardware AVCaptureDevice
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            // If the app is authorized to access the camera then show camera if not then show error message
        case .authorized:
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                showCamera = true
            } else {
                cameraError = "Camera not available on this device"
            }
            // If there the app is not authorized yet then it will ask for access if it is allowed then it will show camera otherwise it will show error message
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
            // Permission has been denied or restricted
        default:
            cameraError = "Please enable camera access in Settings"
        }
    }
}
