//
//  AksjerApp.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 23/12/2023.
//

import SwiftUI


enum AppTheme: String {
    case system, dark, light
}

@main
struct AksjerApp: App {
    @AppStorage("appTheme") private var appTheme: AppTheme = .dark
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appTheme == .system ? nil : (appTheme == .light ? .light : .dark))
//                .tint(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
}
