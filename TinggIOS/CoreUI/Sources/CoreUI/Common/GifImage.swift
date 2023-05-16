//
//  GifImage.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 24/06/2022.
//

import Foundation
import SwiftUI
import WebKit
/// A struct to hold gif image
public struct GifImage: UIViewRepresentable {
    private let url: URL
    public init(_ url: URL) {
        self.url = url
    }
    public func makeUIView(context: Context) -> some WKWebView {
        let webView = WKWebView()
        do {
            let data = try Data(contentsOf: url)
            webView.load(
                data, mimeType: "image/gif",
                characterEncodingName: "UTF-8",
                baseURL: url.deletingLastPathComponent()
            )
            webView.scrollView.isScrollEnabled = false
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.contentMode = .scaleAspectFill
        } catch {
            print(error.localizedDescription)
        }
        return webView
    }
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.reload()
    }
}
