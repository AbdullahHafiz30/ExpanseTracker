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
    //MARK: - Variables
    @Published var isAuthenticated: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    private let coreDataService = CoreDataHelper()
    
    // If user logged in and left the app without logging out and they came back they will go to home page insted tp be asked to log in again
    init() {
        checkUserLoggedIn()
    }
    
    // Check if user is logged in
    func checkUserLoggedIn(){
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    // Log in
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
    }
    
    // Log out
    func logOut() {
        do {
            try Auth.auth().signOut()
            // Clear uid from user default
            UIDManager.clearUID()
            isAuthenticated = false
            print("User logged out successfully")
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
    
    // Sign up
    func signUp(name: String, email: String, password: String, confirmPassword: String, completion: @escaping (Bool,String?) -> Void) {
        // Check password match first
        guard password == confirmPassword else {
            let message = "Passwords don't match"
            AlertManager.shared.showAlert(title: "Password Mismatch", message: message)
            completion(false, message)
            return
        }
        
        isLoading = true
        // Create user
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
                // Save data to fire store
                self.saveUserData(uid: uid, name: name, email: email,password: password)
                // Save it in userdefault
                UIDManager.saveUID(uid)
                self.isAuthenticated = true
                completion(true, nil)
            }
        }
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
    
    // Save data to firestore
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
    
    // Fetch user from fire store to be able to save it in core data
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
            // Save to core data
            self.coreDataService.saveUserToCoreData(user: user, uid: uid)
            print("saved to the core data successfully .\(user)")
            completion(true)
        }
    }
    
    
    
    // Show error function
    private func showError(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
    
    // Valid email format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Valid pssword should be more than 8 char and contain at least 1 number and 1 uppercase letter and 1 lowercase
    func isValidPassword(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    // Error formatter to be readable by users
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
