//
//  AuthViewModel.swift
//  ExpanseTracker
//
//  Created by Rawan on 14/10/1446 AH.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    //if user logged in and left the app without logging out and they came back they will go to home page insted tp be asked to log in again
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
    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error as NSError? {
                    print("Error Code: \(error.code), Description: \(error.localizedDescription)")
                    let userFriendlyMessage = self.mapFirebaseError(error)
                    self.showError(title: "Login Failed", message: userFriendlyMessage)
                    self.isAuthenticated = false
                    completion(false)
                } else {
                   // self.showSuccess(title: "Login Successful", message: "Welcome back!")
                    self.isAuthenticated = true
                    completion(true)
                }
            }
        }
    }
    
    //log out
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
        } catch {
            print("Log out error: \(error.localizedDescription)")
        }
    }
    
    //sign up
    func signUp(name: String, email: String, password: String, confirmPassword: String, completion: @escaping (Bool) -> Void) {
        // Check password match first
        guard password == confirmPassword else {
            showError(title: "Password Mismatch", message: "Passwords don't match.")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        //create user
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error as NSError?{
                    print("Error Code: \(error.code), Description: \(error.localizedDescription)")
                    let userFriendlyMessage = self.mapFirebaseError(error)
                    self.showError(title: "Sign Up Failed", message: userFriendlyMessage)
                    self.isAuthenticated = false
                    completion(false)
                } else if let uid = result?.user.uid {
                    self.saveUserData(uid: uid, name: name, email: email)
                   // self.showSuccess(title: "Sign Up Successful", message: "Welcome to Spend Smartly!")
                    self.isAuthenticated = true
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    //save data to firestore
    private func saveUserData(uid: String, name: String, email: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "name": name,
            "email": email,
            "createdAt": Timestamp()
        ]) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            }
        }
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
