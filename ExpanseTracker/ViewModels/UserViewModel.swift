//
//  UserViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 16/10/1446 AH.
//

import SwiftUI
import CoreData
import Combine
<<<<<<< Updated upstream

class   UserViewModel: ObservableObject {
    
=======
import FirebaseAuth
import FirebaseFirestore
class UserViewModel {
>>>>>>> Stashed changes
    @Published var category: [Category] = []
    private let context = PersistanceController.shared.context
    //@Published var uid: String?
    
<<<<<<< Updated upstream
    func saveUserToCoreData(user: User) {
        print("save user to core data")
=======
//    init() {
//          print("UserViewModel initialized.")
//      }
//
//      // fetch the UID first thing
//      func initializeUser() {
//          if let firebaseUID = Auth.auth().currentUser?.uid {
//              fetchUID(uidFromFirestore: firebaseUID) { success in
//                  if success {
//                      print("✅ Successfully fetched UID: \(self.uid ?? "nil")")
//                  } else {
//                      print("⚠️ Failed to fetch UID from CoreData or Firestore.")
//                  }
//              }
//          } else {
//              print("⚠️ No current Firebase user found.")
//          }
//      }
//    
//    func fetchUID(uidFromFirestore: String, completion: @escaping (Bool) -> Void) {
//        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
//        request.predicate = NSPredicate(format: "id == %@", uidFromFirestore)
//        request.fetchLimit = 1
//        do {
//            if let user = try context.fetch(request).first {
//                self.uid = user.id
//                print("✅ CoreData UID matched: \(user.id ?? "nil")")
//                completion(true)
//            } else {
//                print("⚠️ No matching UID found in CoreData, syncing from Firestore.")
//                auth.fetchUserFromFirestore(uid: uidFromFirestore)
//                completion(true)
//            }
//        } catch {
//            print("❌ Error fetching user by UID: \(error.localizedDescription)")
//            completion(false)
//        }
//    }
    func saveUserToCoreData(user: User, uid: String) {
        print("save")
>>>>>>> Stashed changes

        let newUser = UserEntity(context: context)
        newUser.id = uid
        newUser.name = user.name
        newUser.email = user.email
        newUser.password = user.password
        newUser.imageURL = user.image
        
        PersistanceController.shared.saveContext()
        
        print(newUser.id ?? "")
        var myuser = fetchUserFromCoreDataWithId(id: newUser.id ?? "")
        //print("my user is \(String(describing: myuser))")
    }
    
//    func syncUserFromFirestore(_ uid: String, completion: @escaping () -> Void) {
//        let db = Firestore.firestore()
//        db.collection("users").document(uid).getDocument { document, error in
//            if let document = document, document.exists {
//                let data = document.data()
//                let name = data?["name"] as? String ?? ""
//                let email = data?["email"] as? String ?? ""
//                let user = User(name: name, email: email, password: nil, image: nil, transactions: [nil], budgets: [nil], categories: [nil])
//
//                // Now save the user to Core Data
//                self.saveUserToCoreData(user: user, uid: uid)
//                print("🔥 User synced from Firestore and saved to CoreData: \(name)")
//                completion()
//            } else {
//                print("⚠️ User document not found in Firestore: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
//    }
    func fetchUserFromCoreDataWithId(id: String) -> User? {
       // print("Fetching user with id: \(id)")
        
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", id)
        userRequest.fetchLimit = 1

        do {
            if let result = try context.fetch(userRequest).first {
                let user = User(
                    id: result.id ?? "",
                    name: result.name ?? "",
                    email: result.email ?? "",
                    password: result.password ?? "",
                    image: result.imageURL ?? "",
                    transactions: [],
                    budgets: [],
                    categories: []
                )
                print("Fetched: \(user)")
                return user
            } else {
                print("No user found with id: \(id)")
                return nil
            }
        } catch {
<<<<<<< Updated upstream
            print("❌ Error fetching user: \(error)")
=======
            print("Error fetching user: \(error)")
>>>>>>> Stashed changes
            return nil
        }
    }

    func saveEditedUser(user: User) {
        // Fetch the Core Data object directly
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", user.id ?? "")

        do {
            if let existingUserEntity = try context.fetch(userRequest).first {
                // Update the Core Data object
                existingUserEntity.name = user.name
                existingUserEntity.email = user.email
                existingUserEntity.password = user.password
                existingUserEntity.imageURL = user.image
                
                // Save the context
                PersistanceController.shared.saveContext()
                print("User updated successfully.")
            } else {
                print("No User found with id: \(user.id ?? "")")
            }
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }
    
    
    func deleteAll() {
        let newsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: newsRequest)
        
        do {
            // Execute the delete request
            try context.execute(deleteRequest)
            // Save the context after deletion
            PersistanceController.shared.saveContext()
            print("All users deleted successfully.")
        } catch {
            print("Delete Error \(error)")
        }
    }

    func saveImageToDocuments(_ image: UIImage) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)

        if let imageData = image.jpegData(compressionQuality: 0.9) {
            do {
                try imageData.write(to: fileURL)
                return filename 
            } catch {
                print("❌ Error saving image:", error)
            }
        }
        return nil
    }
}


