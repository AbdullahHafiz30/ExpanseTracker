//
//  ColorExtension.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 17/10/1446 AH.
//

import SwiftUI

extension UIColor {
    // Function to convert a UIColor to a hexadecimal string
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        // Extract the red, green, blue, and alpha components of the color
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // Convert the RGB values (r, g, b) to integers in the range [0, 255]
        // Combine the red, green, and blue values into a single 24-bit integer using | operator
        // Shifts the colors value using << 
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        // Return the combined integer as a hexadecimal string and ensuring the format is always 6 characters long
        return String(format:"#%06x", rgb)
    }
    
    func colorFromHexString(_ hex: String) -> Color {
        // Remove whitespace, newlines, and make the string uppercase
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove the "#" symbol at the beginning if it exists
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        // Check if the cleaned string is not exactly 6 characters
        if hexFormatted.count != 6 {
            return Color.gray // default fallback
        }
        
        // Create a scanner instance that will read from the hexFormatted string and tries to convert the hex string into an integer and store it in rgbValue
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        // Extract the red, green, and blue components from the hex value
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        // Return a SwiftUI Color with the RGB values
        return Color(red: red, green: green, blue: blue)
    }
}
