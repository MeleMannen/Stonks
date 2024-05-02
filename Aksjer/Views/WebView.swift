//
//  WebView.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 03/02/2024.
//

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let parent: SafariWebView
        
        init(_ parent: SafariWebView) {
            self.parent = parent
        }
        
        
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            // Do your Action here:
            print("Jeg er ferdig nå!!!")
        }
        
        
        
        
        
    }
    
}





