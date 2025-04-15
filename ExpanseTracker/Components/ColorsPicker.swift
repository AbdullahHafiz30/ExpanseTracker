//
//  ColorsPicker.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct ColorsPicker: View {
    @State var currentColor: Color = .gray.opacity(0.4)
    @State var dragPosition: CGPoint = CGPoint(x: 150, y: 150)
    @Binding var selectedColor: Color
    @Environment(\.dismiss) var dismiss
    var circleSize: CGFloat = 300

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Canvas { context, size in
                        let rect = CGRect(origin: .zero, size: size)
                        let path = Path(ellipseIn: rect)
                        context.fill(
                            path,
                            with: .conicGradient(
                                Gradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .pink]),
                                center: CGPoint(x: size.width / 2, y: size.height / 2)
                            )
                        )
                    }
                    .frame(width: circleSize, height: circleSize)

                    Circle()
                        .stroke(.white, lineWidth: 2)
                        .background(Circle().fill(currentColor))
                        .frame(width: 40, height: 40)
                        .position(dragPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let center = CGPoint(x: circleSize / 2, y: circleSize / 2)
                                    let adjustedRadius = (circleSize / 2) - 20
                                    let offsetX = value.location.x - center.x
                                    let offsetY = value.location.y - center.y
                                    let distance = sqrt(offsetX * offsetX + offsetY * offsetY)

                                    if distance > adjustedRadius {
                                        let scale = adjustedRadius / distance
                                        let constrainedOffsetX = center.x + offsetX * scale
                                        let constrainedOffsetY = center.y + offsetY * scale
                                        dragPosition = CGPoint(x: constrainedOffsetX, y: constrainedOffsetY)
                                    } else {
                                        dragPosition = value.location
                                    }

                                    currentColor = getColor(at: dragPosition, center: center, radius: adjustedRadius)
                                    selectedColor = currentColor
                                }
                        )
                }
                .frame(width: circleSize, height: circleSize)
                .padding()

                HStack(spacing: 5) {
                    ForEach(0..<11) { index in
                        let brightness = Double(index) / 9.0
                        Rectangle()
                            .fill(selectedColor.opacity(brightness))
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                selectedColor = currentColor.opacity(brightness)
                            }
                    }
                }
                .padding([.trailing, .top], 30)

                Rectangle()
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
                currentColor = selectedColor

                var hue: CGFloat = 0
                var saturation: CGFloat = 0
                var brightness: CGFloat = 0
                var alpha: CGFloat = 0

                UIColor(selectedColor).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

                let angle = hue * 2 * .pi
                let r = saturation * ((circleSize / 2) - 20)
                let center = CGPoint(x: circleSize / 2, y: circleSize / 2)

                let x = center.x + cos(angle) * r
                let y = center.y + sin(angle) * r

                dragPosition = CGPoint(x: x, y: y)
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }

    private func getColor(at position: CGPoint, center: CGPoint, radius: CGFloat) -> Color {
        let dx = position.x - center.x
        let dy = position.y - center.y

        var angle = atan2(dy, dx)
        if angle < 0 {
            angle += 2 * .pi
        }

        let hue = angle / (2 * .pi)
        let distance = sqrt(dx * dx + dy * dy)
        let saturation = min(distance / radius, 1.0)

        return Color(hue: hue, saturation: saturation, brightness: 1)
    }
}

#Preview {
    ColorsPicker(selectedColor: .constant(.gray.opacity(0.4)))
}

