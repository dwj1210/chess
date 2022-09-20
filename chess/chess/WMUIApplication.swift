//
//  WMUIApplication.swift
//  chess
//
//  Created by dwj1210 on 2022/7/20.
//

import Foundation
import SwiftUI

class WMUIApplication: NSObject {
    static let shared = WMUIApplication()

    override private init() {}

    override func copy() -> Any {
        return self
    }

    override func mutableCopy() -> Any {
        return self
    }

    func showExternalURL(url: WMUIURL) {
        AntiDebug();
        if shouldUseLegacyURLHandlingForExternalURL(url: url) {
            _legacyResolveExternalURL(url: url)
        } else {
            _resumeWithUrl(url: url)
        }
    }
    
    func shouldUseLegacyURLHandlingForExternalURL(url: WMUIURL) -> Bool {
        let action = url.actionString()

        if action == "search" {
            return true
        } else if action == "web" {
            return true
        } else if action == "exit" {
            return true
        }
        return false
    }

    func _legacyResolveExternalURL(url: WMUIURL) {
        WMUIURLResolver.shared.resolveURL(url: url)
    }

    func _resumeWithUrl(url: WMUIURL) {
        let host = url.url.host
        let hostArray = [".apps.apple.com",
                         ".books.apple.com",
                         ".music.apple.com",
                         ".itunes.apple.com",
                         ".itunes.com",
                         ".icloud.com",
                         "www.apple.com"]
        if host == "" || host == nil {
            return
        }
        chess://www.apple.com
        for _host in hostArray {
            if host!.hasSuffix(_host) {
                launchWebViewWithUrl(url: url)
            }
        }
    }

    // chess://www.apple.com
    func launchWebViewWithUrl(url: WMUIURL) {
        let hostingController = UIHostingController(rootView: ContentWebView(url: url.url))
        UIApplication.shared.keyWindow?.rootViewController?.present(hostingController, animated: true, completion: nil)
    }
}
