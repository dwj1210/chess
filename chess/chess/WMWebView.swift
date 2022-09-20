//
//  WMWebView.swift
//  chess
//
//  Created by dwj1210 on 2022/7/19.
//

import Foundation
import SwiftUI
import UIKit
import WebKit

struct ContentWebView: View {
    var url: URL

    var body: some View {
        WMWebView(url: url)
    }
}

struct WMWebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> UIWebView {
        let view = UIWebView()
//        chess://x?urlType=web&url=http://www/apple/com
        let result = _URLByRemovingBlacklistedParametersWithURL(url: url!)
        if WMURLBag.urlIsTrusted(url: result) {
            injectScriptInterface(webView: view, url: result)
            let request = URLRequest(url: result)
            view.loadRequest(request)
        }
        return view
    }

    func updateUIView(_ uiView: UIWebView, context: Context) {
    }

    func _URLByRemovingBlacklistedParametersWithURL(url: URL) -> URL {
        var urlstr = url.absoluteString
        if urlstr.contains("@") {
            urlstr = urlstr.replacingOccurrences(of: "@", with: "")
        }

        if urlstr.hasSuffix("?") {
            urlstr = urlstr + "?"
        }

        return URL(string: urlstr) ?? URL(string: "https://www.apple.com")!
    }

    func injectScriptInterface(webView: UIWebView, url: URL) {
        if webView.subviews.count > 0 {
            let scrollView = webView.subviews[0]
            for childView in scrollView.subviews {
                if childView is UIWebDocumentView {
                    let documentView = childView as! UIWebDocumentView
                    let script: WebScriptObject = documentView.webView().windowScriptObject()
                    WMScriptInterface.shared.url = url
                    script.setValue(WMScriptInterface.shared, forKey: "wmctf")
                }
            }
        }
    }
}
