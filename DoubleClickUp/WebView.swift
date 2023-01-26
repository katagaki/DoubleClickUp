//
//  WebView.swift
//  DoubleClickUp
//
//  Created by Justin Xin on 2023/01/26.
//

import SwiftUI
import WebKit
 
struct WebView: NSViewRepresentable {
 
    var url: String
 
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateNSView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
    }
}
