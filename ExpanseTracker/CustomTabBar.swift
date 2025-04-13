//
//  CustomTabBar.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var index: Int  // Binding to track selected tab index
    
    var body: some View {
        NavigationStack{
        HStack {
            // Home Tab
            Button(action: {
                self.index = 0  // Set selected index to 0
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "house") // Home icon
                        .font(.system(size: 24))
                    Text("Home") // Tab label
                        .font(.caption)
                }
            }
            // Highlight the selected tab, dim others
            .foregroundStyle(.black.opacity(self.index == 0 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            // Categories Tab
            Button(action: {
                self.index = 1 // Set selected index to 1
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "doc.on.doc") // Categories icon
                        .font(.system(size: 24))
                    Text("Categories")
                        .font(.caption)
                }
            }
            .foregroundStyle(.black.opacity(self.index == 1 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            // Add Button (Floating Center)
            ZStack {
                // Background Circle to elevate the button (for floating effect)
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                
                NavigationLink(destination: AddTransaction()) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black)
                }
            }
            .offset(x: -10, y: -25) // Lift and center the floating button
            
            Spacer(minLength: 0)
            
            // Graph Tab
            Button(action: {
                self.index = 2 // Set selected index to 2
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "chart.bar.xaxis.ascending") // Graph icon
                        .font(.system(size: 24))
                    Text("Stats")
                        .font(.caption)
                }
            }
            .foregroundStyle(.black.opacity(self.index == 2 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            // Profile Tab
            Button(action: {
                self.index = 3 // Set selected index to 3
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "person.crop.circle") // Profile icon
                        .font(.system(size: 24))
                    Text("Profile")
                        .font(.caption)
                }
            }
            .foregroundStyle(.black.opacity(self.index == 3 ? 1 : 0.2))
        }
    }
        .padding(.horizontal, 20)
        .background(Color.white)
        
    }
}
