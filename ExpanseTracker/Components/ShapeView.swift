//
//  ShapeView.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//


//
//  shape.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct ShapeView: View {
    @State private var usedWaterAmount: CGFloat = 2000 // Current value
    private let maxWaterAmount: CGFloat = 5500        // Max value

    var body: some View {
        VStack (alignment: .leading){
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let fillPercentage = usedWaterAmount / maxWaterAmount
                
                ZStack {
                    // Background Circle with shadow
                    Circle()
                        .fill(Color.white)
                        .frame(width: width, height: height)
                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 4)

                    // Outer Stroke to give border effect
                    Circle()
                        .fill(Color.white)
                        .frame(width: width, height: height)

                    // Water Fill (WaveShape)
                    Circle()
                        .clipShape(
                            WaveShape(
                                waveHeight: 20,
                                waveWidth: width / 3,
                                fillPercentage: 1 - fillPercentage, // Invert to fill from bottom
                                width: width,
                                height: height
                            )
                        )
                        .foregroundColor(fillPercentage > 0.5 ? .green.opacity(0.4) : fillPercentage > 0.2 ? .yellow.opacity(0.4) : .red.opacity(0.4))
                        .frame(width: width, height: height)
                        .animation(.easeInOut(duration: 0.5), value: fillPercentage)

                    // Percentage Text
                    Text("\(Int(fillPercentage * 100))%")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .shadow(color: .white.opacity(0.8), radius: 4) // Text shadow to add depth
                }

            }
            .frame(width: 170, height: 170)
        }
        .padding()
    }
}


struct WaveShape: Shape {
    var waveHeight: CGFloat
    var waveWidth: CGFloat
    var fillPercentage: CGFloat
    var width: CGFloat
    var height: CGFloat
    
    var animatableData: CGFloat {
        get { fillPercentage }
        set { fillPercentage = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waterHeight = fillPercentage * height
        
        path.move(to: CGPoint(x:0 , y: waterHeight))
        for x in stride(from: 0, to: width, by: waveWidth) {
            let x1 = x + waveWidth / 2
            let y1 = waterHeight - waveHeight
            let x2 = x + waveWidth / 2
            let y2 = waterHeight + waveHeight
            let x3 = x + waveWidth
            
            path.addCurve(
                to: CGPoint(x: x3, y: waterHeight),
                control1: CGPoint(x: x1, y: y1),
                control2: CGPoint(x: x2, y: y2)
            )
        }
            
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
        
        return path
    }
}

#Preview {
    ShapeView()
}
