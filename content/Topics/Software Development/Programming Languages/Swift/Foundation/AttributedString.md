---
docs: https://developer.apple.com/documentation/foundation/attributedstring
publish: true
---

## Usage
- [AttributedString in iOS 15 | Sarunw](https://sarunw.com/posts/attributed-string/) 


## Limitations
- Be aware that while `AttributedString` is effectively a 1:1 mapping of `NSAttributedString`, it is up to the renderer which attributes it wants to render. In other words, not every attribute that is in an `AttributedString` will be rendered by SwiftUI. 
	- Source: [SwiftUI AttributedString is not there yet | Medium](https://dimillian.medium.com/swiftui-attributedstring-is-not-there-yet-63d49e9f9c16) by Thomas Ricouard
