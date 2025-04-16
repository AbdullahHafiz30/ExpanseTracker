//
//  AlertState.swift
//  ExpanseTracker
//
//  Created by Rawan on 17/10/1446 AH.
//

import SwiftUI
//MARK: - alert state structure
struct AlertState {
    var isPresented: Bool = false
    var title: String = ""
    var message: String = ""
}
//MARK: - alert manager class
class AlertManager: ObservableObject {
    static let shared = AlertManager()
    private init() {}
    
    @Published var alertState = AlertState()
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertState = AlertState(isPresented: true, title: title, message: message)
        }
    }
}
