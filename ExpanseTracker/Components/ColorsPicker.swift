//
//  ColorsPicker.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI
/// A custom color picker that allows users to select a color using a conic gradient color wheel
struct ColorsPicker: View {
    // Store the initial color that is by defualt selected
    @State var currentColor: Color = .gray.opacity(0.4)
    // Store the current position of the drag gesture
    @State var dragPosition: CGPoint = CGPoint(x: 150, y: 150)
    // Store the selected color from the user using Binding to update it in the parent view
    @Binding var selectedColor: Color
    // dismiss the view when the user click on close button
    @Environment(\.dismiss) var dismiss
    
    // size of the color Canvas
    var circleSize: CGFloat = 300
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    // Using Canvas to draw the conic gradient color wheel
                    Canvas { context, size in
                        //creating a rectangle that starts at the top-left corner of the Canvas and goes all the way to the bottom-right, based on the size of the Canvas
                        // orign zero the same as CGPoint(x: 0 , y: 0)
                        let rect = CGRect(origin: .zero, size: size)
                        // Create a circular path within the rectangle
                        let path = Path(ellipseIn: rect)
                        context.fill( // fill the Canvas
                            path,
                            with: .conicGradient(// Define the sequence of colors in the gradient
                                Gradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .pink]),
                                center: CGPoint(x: size.width / 2, y: size.height / 2) // Set gradient center to canvas center
                            )
                        )
                    }
                    .frame(width: circleSize, height: circleSize)
                    
                    Circle() // Dragging circle
                        .stroke(.white, lineWidth: 2)
                        .background(Circle().fill(currentColor))
                        .frame(width: 40, height: 40)
                        .position(dragPosition) // Position the Circle based on the drag position
                        .gesture( // drag gesture to move the circle
                            DragGesture()
                                .onChanged { value in
                                    let center = CGPoint(x: circleSize / 2, y: circleSize / 2) // Calculate the center of the wheel
                                    let adjustedRadius = (circleSize / 2) - 20 // Adjusted radius to stay within bounds
                                    let offsetX = value.location.x - center.x // Get horizontal distance from center
                                    let offsetY = value.location.y - center.y // Get vertical distance from center
                                    let distance = sqrt(offsetX * offsetX + offsetY * offsetY) // Calculate distance from center
                                    
                                    if distance > adjustedRadius { // Check if the drag is outside the circle
                                        let scale = adjustedRadius / distance  // Scale back to the edge
                                        let constrainedOffsetX = center.x + offsetX * scale // Scale x offset
                                        let constrainedOffsetY = center.y + offsetY * scale // Scale y offset
                                        dragPosition = CGPoint(x: constrainedOffsetX, y: constrainedOffsetY) // Constrain drag position
                                    } else {
                                        dragPosition = value.location // Otherwise, accept drag location
                                    }
                                    
                                    currentColor = getColor(at: dragPosition, center: center, radius: adjustedRadius) // Get the color at new position
                                    selectedColor = currentColor // Update selected color
                                }
                        )
                }
                .frame(width: circleSize, height: circleSize)
                .padding()
                
                HStack(spacing: 5) {
                    ForEach(0..<11) { index in // Loop through 11 steps of brightness
                        let brightness = Double(index) / 9.0 // Calculate brightness level
                        Rectangle()
                            .fill(selectedColor.opacity(brightness)) // Fill it with current color and specific brightness
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                selectedColor = currentColor.opacity(brightness) // Set selected color with new opacity
                            }
                    }
                }
                .padding([.trailing, .top], 30)
                
                Rectangle() // Preview box to show the final selected color
                    .foregroundStyle(selectedColor)
                    .frame(height: 100)
                    .cornerRadius(10)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Pick a Color")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                currentColor = selectedColor // Set current color to the one passed in
                
                var hue: CGFloat = 0
                var saturation: CGFloat = 0
                var brightness: CGFloat = 0
                var alpha: CGFloat = 0
                
                // Conver selcted color into its HSB (Hue, Saturation, Brightness) values
                UIColor(selectedColor).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
                
                let angle = hue * 2 * .pi
                let r = saturation * ((circleSize / 2) - 20)
                let center = CGPoint(x: circleSize / 2, y: circleSize / 2)
                
                let x = center.x + cos(angle) * r
                let y = center.y + sin(angle) * r
                
                dragPosition = CGPoint(x: x, y: y) // Set drag position to match selected color
            }
        }
        .environment(\.layoutDirection, .leftToRight) // Force layout to be left-to-right for consistency when changing the languages
    }
    // Function to calculate color at a given point on the color wheel
    private func getColor(at position: CGPoint, center: CGPoint, radius: CGFloat) -> Color {
        let dx = position.x - center.x // Get horizontal distance from center
        let dy = position.y - center.y // Get vertical distance from center
        
        var angle = atan2(dy, dx)
        if angle < 0 {
            angle += 2 * .pi
        }
        
        let hue = angle / (2 * .pi)
        let distance = sqrt(dx * dx + dy * dy)
        let saturation = min(distance / radius, 1.0)
        
        return Color(hue: hue, saturation: saturation, brightness: 1) // Return selected Color
    }
}

#Preview {
    ColorsPicker(selectedColor: .constant(.gray.opacity(0.4)))
}

