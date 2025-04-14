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
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                Text("home page")
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)
                
                Text("list of categories")
                    .tabItem {
                        Image(systemName: "doc.on.doc")
                        Text("Categories")
                    }.tag(1)
                
                Spacer()
                
                Text("Stats")
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis.ascending")
                        Text("Stats")
                    }.tag(2)
                
<<<<<<< Updated upstream
                Profile()
=======
                Profile(userId: .constant("E5076426-D308-4CD1-9385-1DA8C928068F"), auth: auth)
>>>>>>> Stashed changes
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
                    .offset(y: 0)
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $showAddTransactionView) {
            EditAccountInformation()
        }
    }
}

#Preview {
    MainTabView()
}
