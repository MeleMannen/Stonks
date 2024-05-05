//
//  TextAnimations.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 17/01/2024.
//

import SwiftUI

struct TextAnimations1: View, Animatable {
    var number: Float
    
    var animatableData: Float {
        get { number }
        set { number = newValue }
    }
    
    var body: some View {
        Text(String(format: "%.2f", number))
    }
}

struct TextAnimations2: View, Animatable {
    var number: Float
    var isUp: Bool
    
    var animatableData: Float {
        get { number }
        set { number = newValue }
    }
    
    var body: some View {
        Text("\(isUp ? "+" : "-")" + String(format: "%.2f", abs(number)))
    }
}

