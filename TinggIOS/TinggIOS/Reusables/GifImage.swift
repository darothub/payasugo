//
//  GifImage.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 24/06/2022.
//

import Foundation
import SwiftUI
import WebKit
struct GifImage: UIViewRepresentable {
    private let name: String
    init(_ name: String) {
        self.name = name
    }
    func makeUIView(context: Context) -> some WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
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
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.reload()
    }
}
