//
//  WKFileAccess.swift
//  WKFileAccess
//
//  Created by Noah Green on 5/10/17.
//
//

import WebKit
import XWebView


private let scriptJS: String = {
    let bundle = Bundle(for: FileRequester.self)
    let url = bundle.url(forResource: "WKFileAccess", withExtension: "js")!
    let data = FileManager.default.contents(atPath: url.path)!
    return String(data: data, encoding: .utf8)!
}()


class FileRequester: NSObject {
    
    let allowRequest: (URL) -> Bool
    
    init(allowRequest: @escaping (URL) -> Bool) {
        self.allowRequest = allowRequest
    }
    
    func requestFile_(_ path: String, promiseObject: XWVScriptObject) {
        func resolve(content: String, name: String, type: String) {
            let fileObject = ["content": content, "name": name, "type": type]
            promiseObject.callMethod("resolve", with: [fileObject], completionHandler: nil)
        }
        
        func reject(errorMessage: String) {
            promiseObject.callMethod("reject", with: [errorMessage], completionHandler: nil)
        }
        
        guard
            let escapedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            var url = URL(string: escapedPath)
            else
        {
            reject(errorMessage: "Invalid path: \(path)")
            return
        }
        
        if !url.isFileURL {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.scheme = "file"
            url = urlComponents.url!
        }
        
        guard allowRequest(url) else {
            reject(errorMessage: "Access denied for \(path)")
            return
        }
        
        guard let data = FileManager.default.contents(atPath: url.path) else {
            reject(errorMessage: "Unable to read contents of \(path)")
            return
        }
        
        let content = data.base64EncodedString()
        let name = url.lastPathComponent
        let type = url.mimeType ?? ""
        
        resolve(content: content, name: name, type: type)
    }
    
}


extension WKWebView {
    
    public func allowFileAccess(where allowRequest: @escaping (URL) -> Bool) {
        let fileRequester = FileRequester(allowRequest: allowRequest)
        loadPlugin(fileRequester, namespace: "WKFileAccess")
        let script = WKUserScript(source: scriptJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
    }
    
}
