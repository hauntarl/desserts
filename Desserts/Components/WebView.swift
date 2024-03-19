//
//  WebView.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/18/24.
//
//  How to write a simple SwiftUI WebView SwiftUI component?
//  https://www.swiftyplace.com/blog/loading-a-web-view-in-swiftui-with-wkwebview

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
