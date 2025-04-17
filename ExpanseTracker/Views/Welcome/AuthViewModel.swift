//
//  AuthViewModel.swift
//  ExpanseTracker
//
//  Created by Rawan on 14/10/1446 AH.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

/// A view model responsible for handling user authentication logic,
/// including sign-up, login, logout, and session management.
class AuthViewModel:ObservableObject {
    
    //MARK: - Variables
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    private let coreDataService = CoreDataHelper()
    
    // MARK: - Initialization
    /// Checks user authentication status when the view model is initialized
    init() {
        checkUserLoggedIn()
    }
    
    // MARK: - Check Login State
    /// Determines if a user is already logged in using Firebase
    func checkUserLoggedIn(){
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    // MARK: - Log In Function
    /// Attempts to log the user in with Firebase Auth
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - completion: Closure returning success status and optional error message
    func logIn(email: String, password: String, completion: @escaping (Bool,String?) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            AlertManager.shared.showAlert(title: "Error", message: "Please fill in all fields")
            completion(false, "Empty fields")
            return
        }
        
        guard isValidEmail(email) else {
            AlertManager.shared.showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            completion(false, "Invalid email")
            return
        }
        
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    if let rootVC = UIApplication.shared.windows.first?.rootViewController { //  This will get the root view controller of the app
                        let alert = UIAlertController(title: "Login Failed", message:self.mapFirebaseError(error), preferredStyle: .alert) // This will make an alert controller that has the title i chose with the message i chose
                        alert.addAction(UIAlertAction(title: "OK", style: .default)) // Adding the ok button to dismiss the alert
                        rootVC.present(alert, animated: true) // Present it the screen
                    }
                    
                    completion(false, self.mapFirebaseError(error))
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
    
    // MARK: - Log Out Function
    /// Signs out the user and clears session info from storage
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
    
    // MARK: - Sign Up Function
    /// Registers a new user with Firebase Authentication and stores user data in Firestore
    /// - Parameters:
    ///   - name: User's full name
    ///   - email: Email address
    ///   - password: Password
    ///   - confirmPassword: Password confirmation
    ///   - completion: Closure returning success status and optional error message
    func signUp(name: String, email: String, password: String, confirmPassword: String, completion: @escaping (Bool,String?) -> Void) {
        // Check password match first
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            AlertManager.shared.showAlert(title: "Error", message: "Please fill in all fields")
            completion(false, "Empty fields")
            return
        }
        
        guard isValidEmail(email) else {
            AlertManager.shared.showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            completion(false, "Invalid email")
            return
        }
        
        guard password == confirmPassword else {
            AlertManager.shared.showAlert(title: "Password Mismatch", message: "Passwords don't match")
            completion(false, "Password mismatch")
            return
        }
        
        guard isValidPassword(password) else {
            AlertManager.shared.showAlert(title: "Weak Password", message: "Password must be at least 8 characters with 1 uppercase, 1 lowercase, and 1 number")
            completion(false, "Weak password")
            return
        }
        
        isLoading = true
        // Create user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    if let rootVC = UIApplication.shared.windows.first?.rootViewController { //  This will get the root view controller of the app
                        let alert = UIAlertController(title: "Signup Failed", message:self.mapFirebaseError(error), preferredStyle: .alert)// This will make an alert controller that has the title i chose with the message i chose
                        alert.addAction(UIAlertAction(title: "OK", style: .default))// Adding the ok button to dismiss the alert
                        rootVC.present(alert, animated: true) // Present it on the screen
                    }
                    
                    completion(false, self.mapFirebaseError(error))
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
    
    // MARK: - Successful Login Handling
    
    /// Handles logic after a successful login.
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
    
    // MARK: - Firestore - Save and Fetch
    
    /// Saves user data to Firestore after signup.
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
    
    /// Fetches user data from Firestore to store locally in Core Data.
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
    
    // MARK: - Delete User
    
    /// Deletes a user's account from Firebase Auth and Firestore after reauthentication.
    func deleteUserAccount(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No logged-in user found."])))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        // Re-authenticate - firebase wont allow user to delete until it reauthenticated
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let uid = user.uid
            let db = Firestore.firestore()
            
            // Delete user from Firestore
            db.collection("users").document(uid).delete { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Delete from Firebase Auth
                user.delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(" User successfully deleted from Firebase and Firestore."))
                    }
                }
            }
        }
    }
    
    // MARK: - Validation Helpers
    
    /// Validates if an email string matches proper format.
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /// Validates password strength (min 8 chars, at least 1 uppercase, 1 lowercase, 1 number).
    func isValidPassword(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    // MARK: - Firebase Error Mapping
    
    /// Converts Firebase error codes to user-friendly messages.
    private func mapFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError
        
        guard nsError.domain == AuthErrorDomain else {
            return error.localizedDescription
        }
        
        guard let authErrorCode = AuthErrorCode(rawValue: nsError.code) else {
            return "An unknown error occurred. Please try again."
        }
        
        switch authErrorCode {
        case .invalidCredential:
            return "The login credentials are incorrect or the account does not exist. Please check your email and password, then try again."
            
        case .emailAlreadyInUse:
            return "This email address is already associated with another account."
            
        case .invalidEmail:
            return "The email address entered is invalid."
            
        case .weakPassword:
            return "The password is too weak. Please choose a stronger one."
            
        case .networkError:
            return "A network error occurred. Please check your connection and try again."
            
        case .tooManyRequests:
            return "Too many attempts. Please wait and try again later."
            
        case .internalError:
            return "An internal error occurred. Please try again later."
            
        default:
            return "An unexpected error occurred. Please try again."
        }
    }
    
}
