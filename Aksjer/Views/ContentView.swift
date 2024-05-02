//
//  ContentView.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 23/12/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("appTheme") private var appTheme: AppTheme = .dark
    @State private var selection: Tab = .featured
    
    
    
    enum Tab {
        case featured
        case list
    }
    
    init() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .systemBackground
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }

    
    var body: some View {
        TabView(selection: $selection) {
            
            AksjerView()
                .tabItem {
                    Label("Aksjer", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.featured)
                
            
            
            
            
            InstillingerView()
                .tabItem {
                    Label("Innstillinger", systemImage: "gear")
                }
                .tag(Tab.list)
                .preferredColorScheme(appTheme == .system ? nil : (appTheme == .light ? .light : .dark))
        }
        
        
        
    }
    
}

#Preview {
    ContentView()
}


extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
