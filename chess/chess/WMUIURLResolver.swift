//
//  WMUIURLResolver.swift
//  chess
//
//  Created by dwj1210 on 2022/7/20.
//

import Foundation
import SwiftUI

class WMUIURLResolver: NSObject {
    static let shared = WMUIURLResolver()

    override private init() {}

    override func copy() -> Any {
        return self
    }

    override func mutableCopy() -> Any {
        return self
    }

    func resolveURL(url: WMUIURL) {
        if url.actionString() == "exit" {
            _exitApp()
        } else if url.actionString() == "web" {
            _showAccountViewControllerWithURL(url: url)
        } else if url.actionString() == "search" {
            _showSearchViewControllerWithURL(url: url)
        }
    }
    chess://x?urlType=web&url=http%3A%2F%2Fwww.apple.com
    func _showAccountViewControllerWithURL(url: WMUIURL) {
        if let result_url = URL(string: (url.url.queryParameters?["url"]) ?? "") {
            let hostingController = UIHostingController(rootView: ContentWebView(url: result_url))
            UIApplication.shared.keyWindow?.rootViewController?.present(hostingController, animated: true, completion: nil)

        } else {
        }
    }

    func _showSearchViewControllerWithURL(url: WMUIURL) {
    }

    func _exitApp() {
        exit(0)
    }
}
