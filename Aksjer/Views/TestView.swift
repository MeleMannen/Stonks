//
//  TestView.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 13/02/2024.
//

import SwiftUI

struct TestView: View {
    
    @State private var isPresentingWebView = false
    @State private var showCustomPopover = false
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
                    .lineLimit(4)
                
                Text("News")
                    .font(.headline)
                    .padding(5)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Date")
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
            }
            .fixedSize(horizontal: false, vertical: true)
            .onLongPressGesture {
                showCustomPopover = true
            }
            .overlay {
                if showCustomPopover {
                    VStack {
                        SafariWebView(url: URL(string: "https://stackoverflow.com/questions/77974957/how-can-i-expand-my-contextmenu-preview-to-fullscreen-on-tap-of-preview?noredirect=1#comment137490790_77974957")!)
                            .frame(width: isPresentingWebView ? size.width : 300, height: isPresentingWebView ? size.height : 400)
                            .clipShape(.rect(cornerRadius: 20))
                            .overlay(alignment: .topLeading) {
                                HStack {
                                    if isPresentingWebView {
                                        Button("", systemImage: "xmark") {
                                            withAnimation {
                                                showCustomPopover = false
                                                isPresentingWebView = false
                                            }
                                        }
                                    }
                                    Button("", systemImage: "arrow.up.left.and.arrow.down.right") {
                                        withAnimation {
                                            isPresentingWebView.toggle()
                                        }
                                    }
                                }
                                .offset(x: isPresentingWebView ? 15 : -30, y: -30)
                            }
                        
                        
                        if !isPresentingWebView {
                            Button(action: {
                                UIPasteboard.general.string = "Link here"
                            }) {
                                Text("Kopier lenke")
                                Image(systemName: "link")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                if showCustomPopover {
                    Color.gray.opacity(0.000000000000000001)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            withAnimation {
                                showCustomPopover = false
                            }
                        }
                }
            }
            /*.fullScreenCover(isPresented: $isPresentingWebView) {
             SafariWebView(url: URL(string: "https://stackoverflow.com/questions/77974957/how-can-i-expand-my-contextmenu-preview-to-fullscreen-on-tap-of-preview?noredirect=1#comment137490790_77974957")!)
             .ignoresSafeArea()
             }*/
        }
    }
    
}

#Preview {
    TestView()
}
