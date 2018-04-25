//
//  PWebViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/21.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import WebKit

class PWebViewController: PBaseViewController, WKNavigationDelegate {

    var url: String?
    
    private var webView: WKWebView?
    
    deinit {
        Hud.hide()
        self.destroyWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.bounds)
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
        
        if let u = url {
            let request = URLRequest(url: URL(string: u)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
            webView?.load(request)
        } else {
            Hud.show(content: "url未提供")
        }
    }
    
    func destroyWebView() {
        if let _ = webView {
            webView?.stopLoading()
            URLCache.shared.removeAllCachedResponses()
            webView?.navigationDelegate = nil
            webView = nil
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Hud.showHudView(inView: self.view, lock: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Hud.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Hud.show(content: error.localizedDescription)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        Hud.hide()
    }
    
}


