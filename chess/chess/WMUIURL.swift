//
//  WMUIURL.swift
//  chess
//
//  Created by dwj1210 on 2022/7/19.
//

import Foundation

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}

class WMUIURL {
    var url: URL

    init(url: URL) {
        let scheme = url.scheme
//        chess://www.apple.com => https://www.apple.com
        if scheme == "https" {
            self.url = url

        } else {
            let len = scheme!.count

            let urlStr = url.absoluteString
            
            let httpUrl = (urlStr as NSString).replacingCharacters(in: NSMakeRange(0, len), with: "https")
            
            self.url = URL(string: httpUrl)!
        }
    }

    func actionString() -> String {
        let action = valueForQueryParameter(str: "urlType")

        if action == "search" {
            return "search"
        } else if action == "web" {
            return "web"
        } else if action == "exit" {
            return "exit"
        }
        return ""
    }

    func valueForQueryParameter(str: String) -> String {
        return url.queryParameters?[str] ?? ""
    }
}
