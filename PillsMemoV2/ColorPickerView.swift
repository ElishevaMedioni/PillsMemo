//
//  ColorPickerView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 16/03/2025.
//


import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @Binding var rgbaColor: RGBAColor
    
    var body: some View {
        
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                ForEach(ColorOptions.all, id: \.self) { colorOption in
                    ZStack {
                        Circle()
                            .fill(colorOption)
                            .frame(width: 36, height: 36)
                            .onTapGesture {
                                // When a color is tapped, update both the selectedColor and the rgbaColor
                                self.selectedColor = colorOption
                                self.rgbaColor = colorOption.rgbaColor
                            }
                        // Checkmark for the selected color
                        if isColorSelected(colorOption) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        
    }
    
    // Helper Function to check if colors are approximately equal
        private func isColorSelected(_ color: Color) -> Bool {
            // Compare the RGBA components directly
            let colorRGBA = color.rgbaColor
            
            // Use a small threshold for floating point comparison
            let threshold: CGFloat = 0.1
            
            return abs(colorRGBA.r - rgbaColor.r) < threshold &&
                   abs(colorRGBA.g - rgbaColor.g) < threshold &&
                   abs(colorRGBA.b - rgbaColor.b) < threshold
        }
}
