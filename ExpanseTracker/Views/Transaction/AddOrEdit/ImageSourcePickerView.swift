//
//  ImageSourcePickerView.swift
//  ExpanseTracker
//
//  Created by Rawan on 19/10/1446 AH.
//

import SwiftUI

/// Picker displayed in a sheet to choose between camera or gallery
struct ImageSourcePickerView: View {
    //MARK: - Variables
    
    let onCameraTap: () -> Void
    let onGalleryTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    //MARK: - View
    
    var body: some View {
        HStack(spacing: 20) {
            // MARK: - Camera
            Button(action: onCameraTap) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(themeManager.backgroundColor)
                        .frame(width: 130, height: 130)
                        .shadow(radius: 5)
                    VStack {
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
            
            // MARK: - Gallery
            Button(action: onGalleryTap) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(themeManager.backgroundColor)
                        .frame(width: 130, height: 130)
                        .shadow(radius: 5)
                    VStack {
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
}
