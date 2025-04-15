//
//  AuthViewModel.swift
//  ExpanseTracker
//
//  Created by Rawan on 14/10/1446 AH.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore
class AuthViewModel:ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    private let coreDataService = CoreDataHelper()
//    //if user logged in and left the app without logging out and they came back they will go to home page insted tp be asked to log in again
    init() {
        checkUserLoggedIn()
    }
    
    //check if user is logged in
    func checkUserLoggedIn(){
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    //log in
    func logIn(email: String, password: String, completion: @escaping (Bool,String?) -> Void) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                            self.isLoading = false
                            
                            if let error = error {
                                let message = self.mapFirebaseError(error)
                                AlertManager.shared.showAlert(title: "Login Failed", message: message)
                                completion(false, message)
                                return
                            }
                            
                            guard let uid = result?.user.uid else {
                                let message = "User ID not found"
                                AlertManager.shared.showAlert(title: "Error", message: message)
                                completion(false, message)
                                return
                            }
                            
                            self.handleSuccessfulLogin(uid: uid, completion: completion)
                        }
                    }
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                if let error = error as NSError? {
//                    print("Error Code: \(error.code), Description: \(error.localizedDescription)")
//                    let userFriendlyMessage = self.mapFirebaseError(error)
//                    self.showError(title: "Login Failed", message: userFriendlyMessage)
//                    self.isAuthenticated = false
//                    completion(false)
//                } else {
//                    self.isAuthenticated = true
//                    print("✅ Firebase login successful.")
//                    
//                    guard let uid = result?.user.uid else {
//                        print("❌ UID not found after login.")
//                        completion(false)
//                        return
//                    }
//                    print("🔥 Logged in Firebase UID: \(uid)")
//                    
//                    
//                    self.userVM.fetchUID(uidFromFirestore: uid) { success in
//                        if success {
//                            print("✅ Core Data sync successful")
//                        } else {
//                            print("⚠️ Core Data sync failed, you may want to sync from Firestore")
//                        }
//                    }
//                    self.fetchUserFromFirestore(uid: uid)
//                    
//                    completion(true)
//                }
//            }
//        }
    }
    
    //log out
    func logOut() {
        do {
             try Auth.auth().signOut()
             UIDManager.clearUID()
             isAuthenticated = false
             print("User logged out successfully")
         } catch {
             print("Logout error: \(error.localizedDescription)")
         }
    }
    
    //sign up
    func signUp(name: String, email: String, password: String, confirmPassword: String, completion: @escaping (Bool,String?) -> Void) {
        // Check password match first
        guard password == confirmPassword else {
                    let message = "Passwords don't match"
                    AlertManager.shared.showAlert(title: "Password Mismatch", message: message)
                    completion(false, message)
                    return
                }
                
                isLoading = true
                
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        
                        if let error = error {
                            let message = self.mapFirebaseError(error)
                            completion(false, message)
                            return
                        }
                        
                        guard let uid = result?.user.uid else {
                            completion(false, "User ID not found")
                            return
                        }
                        
                        self.saveUserData(uid: uid, name: name, email: email,password: password)
                        UIDManager.saveUID(uid)
                        self.isAuthenticated = true
                        completion(true, nil)
                    }
                }
        // Create user
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                
//                if let error = error as NSError? {
//                    print("Error Code: \(error.code), Description: \(error.localizedDescription)")
//                    let userFriendlyMessage = self.mapFirebaseError(error)
//                    self.showError(title: "Sign Up Failed", message: userFriendlyMessage)
//                    self.isAuthenticated = false
//                    completion(false)
//                } else if let uid = result?.user.uid {
//                    
//                    // Sync to Core Data
//                    self.userVM.fetchUID(uidFromFirestore: uid) { success in
//                        if success {
//                            print("✅ Core Data sync successful for new user")
//                        } else {
//                            print("⚠️ Core Data sync failed, you may want to sync from Firestore")
//                        }
//                    }
//
//                    // Save user data to Firestore
//                    self.saveUserData(uid: uid, name: name, email: email)
//
//                    // Successfully authenticated
//                    self.isAuthenticated = true
//                    print("✅ Firebase sign-up successful.")
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//            }
//        }
    }
    
    private func handleSuccessfulLogin(uid: String, completion: @escaping (Bool, String?) -> Void) {
        UIDManager.saveUID(uid)
        
        fetchUserFromFirestore(uid: uid) { success in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    completion(true, nil)
                } else {
                    let message = "Failed to fetch user data"
                    AlertManager.shared.showAlert(title: "Error", message: message)
                    completion(false, message)
                }
            }
        }
    }
    
    //save data to firestore
    private func saveUserData(uid: String, name: String, email: String, password:String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "uid": uid,
            "name": name,
            "email": email,
            "password": password
        ])  { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved to Firestore. Fetching to save in Core Data...")
                self.fetchUserFromFirestore(uid: uid, completion: { _ in })
            }
        }
    }
    //fetch user from fire store to be able to save it in core data
    func fetchUserFromFirestore(uid: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
                   if let error = error {
                       print("Error fetching user: \(error.localizedDescription)")
                       completion(false)
                       return
                   }
                   
                   guard let document = document, document.exists,
                         let data = document.data() else {
                       print("User document not found")
                       completion(false)
                       return
                   }
            
            let name = data["name"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let password = data["password"] as? String ?? ""
            let user = User(
                       name: name,
                       email: email,
                       password: password,
                       image: nil,
                       transactions: [],
                       budgets: [],
                       categories: []
                   )
                   
                   self.coreDataService.saveUserToCoreData(user: user, uid: uid)
                   completion(true)
               }
//        db.collection("users").document(uid).getDocument { document, error in
//            if let document = document, document.exists {
//                let data = document.data()
//                let name = data?["name"] as? String ?? ""
//                let email = data?["email"] as? String ?? ""
//                let uidFromData = data?["uid"] as? String ?? uid
//
//                let user = User(name: name, email: email, password: nil, image: nil,transactions: [nil],budgets: [nil],categories: [nil])
//                //save to core data
//                self.userVM.saveUserToCoreData(user: user, uid: uidFromData)
//                print("saved to the core data successfully .\(user)")
//
//            } else {
//                print("User document not found or error: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
    }
    
    

    //show error function
    private func showError(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
    //show success function
    //    private func showSuccess(title: String, message: String) {
    //        DispatchQueue.main.async {
    //            self.alertTitle = title
    //            self.alertMessage = message
    //            self.showAlert = true
    //        }
    //    }
    //valid email format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    //valid pssword should be more than 8 char and contain at least 1 number and 1 uppercase letter and 1 lowercase
    func isValidPassword(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    //error formatter to be readable by users
    private func mapFirebaseError(_ error: Error) -> String {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.userNotFound.rawValue:
            return "No account found for this email. Did you sign up already?"
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password. Try again."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "This email is already in use."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Please enter a valid email address."
        case AuthErrorCode.weakPassword.rawValue:
            return "Your password is too weak. Try making it stronger."
        case AuthErrorCode.networkError.rawValue:
            return "Network error. Check your connection and try again."
        case AuthErrorCode.internalError.rawValue:
            return "Something went wrong. Please try again later."
        default:
            return "Unexpected error occurred. Try again."
        }
    }
    
}
