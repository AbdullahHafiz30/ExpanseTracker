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
}
