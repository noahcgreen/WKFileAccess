//
//  ViewController.swift
//  Example
//
//  Created by Noah Green on 5/10/17.
//
//

import WebKit
import WKFileAccess


extension URL {
    
    var isInDesktop: Bool {
        var relationship: FileManager.URLRelationship = .other
        try? FileManager.default.getRelationship(&relationship, of: .desktopDirectory, in: .userDomainMask, toItemAt: self)
        return relationship == .contains
    }
    
}


class ViewController: NSViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView?.allowFileAccess { $0.isInDesktop }
        
        let htmlURL = Bundle.main.url(forResource: "example", withExtension: "html", subdirectory: "www")!
        webView?.loadFileURL(htmlURL, allowingReadAccessTo: Bundle.main.resourceURL!.absoluteURL)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
        completionHandler()
    }

}
