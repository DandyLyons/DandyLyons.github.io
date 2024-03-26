---
tags:
  - Swift/5_3
related:
  - "[[Swift 5.3]]"
publish: true
---
In Swift, we are used to reading from the App Bundle like this: 

```swift
if let imagePath = Bundle.main.path(forResource: "example", withExtension: "png") {
    // Use imagePath
    let image = UIImage(contentsOfFile: imagePath)
}
```

But what if we want to read a file from a Swift package? Well ever since Swift 5.3, we've been able to [bundle resources with our source code in a Swift package](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package). Simply use `Bundle.module` instead of `Bundle.main`. (A packages Bundle can even be [localized](https://developer.apple.com/documentation/xcode/localizing-package-resources)!) Now we can read it from your package's bundle like this: 

```swift
if let imagePath = Bundle.module.url(forResource: "example", withExtension: "png") {
    // Use imagePath
    let image = UIImage(contentsOfFile: imagePath)
}
```

But what if I want to read from my package's bundle from outside of my package. For example, how can my app read from my package's Bundle? Again the solution is quite simple. Inside of your package add the following file:

```swift
// MyPackageBundle.swift
import Foundation

extension Bundle {
	public static var myPackage = Bundle.module
}
```

Now inside of your app you can read from the Bundle like this: 

```swift
if let imagePath = Bundle.myPackage.url(forResource: "example", withExtension: "png") {
    // Use imagePath
    let image = UIImage(contentsOfFile: imagePath)
}
```
