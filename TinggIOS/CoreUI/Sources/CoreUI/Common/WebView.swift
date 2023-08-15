//
//  HTMLView.swift
//
//
//  Created by Abdulrasaq on 26/01/2023.
//

import SwiftUI
import WebKit

@MainActor
public struct WebView: UIViewRepresentable{
    let url: URL?
    let urlRequest: URLRequest?
    @Binding var webViewUIModel: UIModel
    public init(url: URL? = nil, urlRequest: URLRequest? = nil, webViewUIModel: Binding<UIModel>) {
        self.url = url
        self.urlRequest = urlRequest
        self._webViewUIModel = webViewUIModel
    }
    public func makeUIView(context: Context) ->  WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = context.coordinator
        if let request = urlRequest {
            webView.load(request)
        } else {
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        return webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if let request = urlRequest {
            uiView.load(request)
        } else {
            let request = URLRequest(url: url!)
            uiView.load(request)
        }
    }
    public func makeCoordinator() -> WebViewCordinator {
        .init {
            print("WebView: Start")
        } didHaveError: { e in
            print("WebView: Error")
        } didFinish: { url in
            print("WebView: Finish")
        }
    }
}

public struct HTMLView: UIViewRepresentable {
    var url: String
    @State var webViewUIModel: UIModel
    var didStart: () -> Void
    var didHaveError: (Error) -> Void
    var didFinish: (String) -> Void
    var onTryAgain: () -> Void
    public init(url: String, webViewUIModel: UIModel, didStart: @escaping () -> Void = {
        //TODO
    }, didHaveError: @escaping (Error) -> Void  = {_ in
        //TODO
    }, didFinish: @escaping (String) -> Void = {_ in
        //TODO
    }, onTryAgain: @escaping () -> Void = {
        //TODO
    }) {
        self.url = url
        self._webViewUIModel = State(initialValue: webViewUIModel)
        self.didStart = didStart
        self.didHaveError = didHaveError
        self.didFinish = didFinish
        self.onTryAgain = onTryAgain
    }
    public func makeUIView(context: Context) ->  WKWebView {
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
         // Adding a script message handler
        config.userContentController.add(context.coordinator, name: "tryAgain")
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString(url, baseURL: nil)
        return webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(url, baseURL: nil)
    }
    public func makeCoordinator() -> WebViewCordinator {
        .init {
            print("HTMLView: Start")
        } didHaveError: { e in
            print("HTMLView: Error")
        } didFinish: { url in
            didFinish(url)
        } onTryAgain: {
            onTryAgain()
        }
    }
}
public class WebViewCordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
  
    
    var didStart: () -> Void
    var didHaveError: (Error) -> Void
    var didFinish: (String) -> Void
    var onTryAgain: () -> Void
    public init(didStart: @escaping () -> Void, didHaveError: @escaping (Error) -> Void, didFinish: @escaping (String) -> Void, onTryAgain: @escaping () -> Void = {
        //TODO
    }) {
        self.didStart = didStart
        self.didHaveError = didHaveError
        self.didFinish = didFinish
        self.onTryAgain = onTryAgain
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        logCurrentFunc("\(error)")
        didHaveError(error)
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)  {
        DispatchQueue.main.async {
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                print("HTMLFinishValue \(String(describing: value))")
                print("Errot\(String(describing: error))")
           }
            let tryAgainJsString = """
                           document.getElementsByClassName('btn')[0].addEventListener("click", function test() {
                            webkit.messageHandlers.tryAgain.postMessage("TRY AGAIN CLICKED");
                    })
            """
            webView.evaluateJavaScript(tryAgainJsString) { _, _ in
                //TODO
            }
        }
        if let url = webView.url?.absoluteString {
            logCurrentFunc(url)
            didFinish(url)
        }
    }
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "tryAgain",  ((message.body as? String) != nil) {
            self.onTryAgain()
        }
    }
    
}
func logCurrentFunc(fileStr: String = #file, funcStr: String = #function, _ message: String) {
    var fileName = fileStr.components(separatedBy: "/").last ?? ""
    fileName = fileName.components(separatedBy:".").first ?? ""
    let printFunc = "\(fileName): \(funcStr) -> \(message)"
    print(printFunc)
}
