//
//  MainTabView.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 15/10/1446 AH.
//


import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showAddTransactionView: Bool = false
    @ObservedObject var auth: AuthViewModel
    @State private var userId: String = ""
    
    // Get UID from user default
        var uid: String? {
           UIDManager.loadUID()
       }
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                TransactionListView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)
                
                CategoryView(userId: .constant(uid ?? ""))
                    .tabItem {
                        Image(systemName: "doc.on.doc")
                        Text("Categories")
                    }.tag(1)
                
                Spacer()
                
                GraphsView()
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis.ascending")
                        Text("Stats")
                    }.tag(2)

                Profile(userId: .constant(uid ?? "") ,auth:auth)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }.tag(3)
            }
            .padding(.horizontal,10)
            .tint(.primary)

            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle action
                        selectedTab = 4
                        showAddTransactionView.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(themeManager.isDarkMode ? .white : .black)
                                .frame(width: 80, height: 80)
                            Image(systemName: "plus")
                                .foregroundColor(themeManager.isDarkMode ? .black : .white)
                                .font(.system(size: 30))
                        }
                    }
                    .offset(y: -5)
                    Spacer()
                }
            }.ignoresSafeArea(.keyboard)
        }.navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showAddTransactionView) {
            AddTransaction(userId: .constant(uid ?? ""))
        }
    }
}
