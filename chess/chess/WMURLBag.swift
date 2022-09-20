//
//  WMURLBag.swift
//  chess
//
//  Created by dwj1210 on 2022/7/20.
//

import Foundation

class WMURLBag: NSObject {
    class func urlIsTrusted(url: URL) -> Bool {
        if url.scheme == "data" {
            return true
        } else {
            let host = url.host
            let hostArray = [".apps.apple.com",
                             ".books.apple.com",
                             ".music.apple.com",
                             ".itunes.apple.com",
                             ".itunes.com",
                             ".icloud.com",
                             "www.apple.com"]

            if host == "" || host == nil {
                return false
            }
            for _host in hostArray {
                if host!.hasSuffix(_host) {
                    return true
                }
            }
            return false
        }
    }
}
