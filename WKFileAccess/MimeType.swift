//
//  MimeType.swift
//  WKFileAccess
//
//  Created by Noah Green on 5/12/17.
//
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    import MobileCoreServices
#endif


extension URL {
    
    var mimeType: String? {
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() else {
            return nil
        }
        
        return UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as String?
    }
    
}
