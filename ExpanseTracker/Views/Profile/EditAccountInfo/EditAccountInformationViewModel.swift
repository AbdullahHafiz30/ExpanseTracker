//
//  EditAccountInformationViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 20/10/1446 AH.
//

import SwiftUI
import CoreData
import Combine

class EditAccountInformationViewModel: ObservableObject {
    
    /// Loads the user data from Core Data and retrieves the associated profile image.
    ///
    /// This method fetches a user's name, email, password, and profile image data based on the provided user ID.
    /// It attempts to load the user's profile image from the app document directory if an image filename is stored.
    ///
    /// - Parameter userId: The unique identifier of the user whose data is to be loaded from Core Data.
    ///
    /// - Returns: A tuple containing:
    ///   - `userName`: The name of the user, or an empty string if not found.
    ///   - `userEmail`: The email of the user, or an empty string if not found.
    ///   - `userPassword`: The password of the user, or an empty string if not found.
    ///   - `imageData`: The profile image data, or an empty `Data` object if no image is found.
    ///   - `imageURL`: The URL of the saved profile image, or `nil` if no image is found.
    func loadUserData(userId: String) -> (String, String, String, Data, URL?){
        // Fetch the user from Core Date using user id
        let userInfo = CoreDataHelper().fetchUserFromCoreData(uid: userId)
        
        // Assign its properties to local state variables
        let userName = userInfo?.name ?? ""
        let userEmail = userInfo?.email ?? ""
        let userPassword = userInfo?.password ?? ""
        var imageData: Data = Data()
        var imageURL: URL?
        
        if let imageFilename = userInfo?.image {
            print("Saved image filename: \(imageFilename)")
            
            // Retrieves the URL for the app document directory using FileManager
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // Append the file name to the documentsDirectory
            let fileURL = documentsDirectory.appendingPathComponent(imageFilename)
            
            print("Full file path: \(fileURL.path)")

            // Check if the file exists
            if FileManager.default.fileExists(atPath: fileURL.path),
               let data = try? Data(contentsOf: fileURL) {
                imageData = data
                imageURL = fileURL
                print("Image data loaded from documents")
            } else {
                print("File not found in documents")
            }
        }
        
        return (userName, userEmail, userPassword, imageData,imageURL)
    }
}
