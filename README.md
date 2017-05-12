# WKFileAccess

WKFileAccess extends `WKWebView` to provide an easy way for web views to access local files. JavaScript running in an extended `WKWebView` has access to a global `WKFileAccess` object through which it requests local resources. The file is loaded on the Swift end and passed to the JavaScript end as a `File` object, which can then be handled using the native JS `FileReader` object.

## Installation

### Carthage

Add the following line to your Cartfile:

```
github "noahcgreen/WKFileAccess" "development"
```

## Usage

After importing `WKFileAccess`, simply declare that a `WKWebView` allows file access as follows:

```
webView.allowFileAccess { $0.pathExtension == "png" }
```

`allowFileAccess` accepts a single function argument, which it uses as a whitelist to determine which URLs may be accessed by the view's JavaScript. (The example above allows access to any URL with an extension of "png".) Since this framework would otherwise allow foreign JavaScript to read any file's on a user's device, it is **strongly** recommended that you use a secure whitelisting function.

Once the above has been done, JavaScript running within the web view can access files as follows:

```
WKFileAccess.requestFile('/path/to/local/image.png')
    .then(file => {
        // do something with file
    })
    .catch(error => {
        // do something with error
    })
```

`WKFileAccess.requestFile` returns a [`Promise`](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) for a JS [`File`](https://developer.mozilla.org/en-US/docs/Web/API/File) object, which can then be passed to a [`FileReader`](https://developer.mozilla.org/en-US/docs/Web/API/FileReader) to do something with the file's contents.

For sample usage, see the example application.
