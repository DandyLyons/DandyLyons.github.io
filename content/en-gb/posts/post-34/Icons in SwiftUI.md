---
title: Icons in SwiftUI
date: 2025-04-29
topics:
  - SwiftUI
  - Icons
  - SF Symbols
  - Lucide Icons
  - SVG
series: SwiftUI
description: Exploring the world of icons in SwiftUI, from SF Symbols to custom SVGs.
slug: icons-in-swiftui
tags:
  - SwiftUI
---

# Icons in SwiftUI

Icons are an incredibly powerful technique in modern UI design. They can convey meaning, add visual interest, and enhance the overall user experience. They can also take a lot of time to create and implement. Thankfully, SwiftUI comes with a built-in library of icons that you can use in your apps called SF Symbols. While SF Symbols are a fantastic resource, they still have a limited selection of icons (and very strict Apple guidelines). In this article, we’ll explore how to use SF Symbols in SwiftUI, we'll learn about another open-source icon library, and finally we'll learn how to create custom icons that fit your app’s design language.

## Using SF Symbols in SwiftUI
SF Symbols are a set of over 6,000 icons designed to work seamlessly with Apple’s system fonts. They are vector-based, which means they can be resized without losing quality. This makes them perfect for use in SwiftUI, where you can easily adjust their size and color to fit your design. 

But even better, each SF Symbol is designed to work with the system font. This means that Apple not only designed thousands of icons, they also designed several iterations of each icon for each system font weight. This means that you can use SF Symbols in your app and they will automatically match the system font weight of the text around them. This is a huge advantage over other icon libraries, which often require you to manually adjust the size and color of each icon to match your design.

Using an SF Symbol is astonishingly simple. You can simply pass a string to load the icon you want. 

```swift
Image(systemName: "star.fill")
// You can also inline the icon in a Text view
Text("Star \(Image(systemName: "star.fill"))")
// You can also use the icon as a button
Button("Favorite this item", systemImage: "star.fill") {
    // implement your action here
}
// You can also use an image in a label
Label("Favorites", systemImage: "star.fill")
```

SF Symbols even have multi-color rendering modes: 

```swift
Image(systemName: "star.fill")
    .symbolRenderingMode(.multicolor)
```

And SF Symbols even have an expressive, simple animation system. You can use the `.symbolEffect` modifier to add a simple animation to your SF Symbols. 

```swift
Image(systemName: "star.fill")
    .symbolEffect(.pulse)
```

Be sure to check out Paul Hudson’s article [How to Animate SF Symbols](https://www.hackingwithswift.com/quick-start/swiftui/how-to-animate-sf-symbols).

So what more is there to want? Well, even though SF Symbols have an ever-growing library of icons, there are still many icons that are missing. In particular, I often find that I want an icon that is a logo for a specific service, e.g. Youtube, or Mastodon. But SF Symbols don’t have these icons. Also, I often find that I want to combine multiple icons together to create a new more expressive icon. Sure, I could simply place one icon on top of another, but this is not a very elegant solution. I lose all the built-in benefits of accessibility, font weight adjustment, animation etc. So what can we do? Let's look at some alternatives. 

## Using Lucide Icons in SwiftUI
Lucide Icons is an open-source icon library that contains over 1,000 icons. Lucide Icons are also vector-based, which means they can be resized without losing quality, and it's easy to edit them or change their color to match the look of your UI. This makes them perfect for use in SwiftUI, where you can easily adjust their size and color to fit your design. You can find the full list of icons on the [Lucide Icons website](https://lucide.dev/).

Perhaps the easiest way to use Lucide Icons in SwiftUI is to use the [LucideIcons](https://swiftpackageindex.com/JakubMazur/lucide-icons-swift) Swift Package. This package contains all of the icons in the Lucide Icons library, and it’s easy to use in your SwiftUI projects.

```swift 
if let uiImage = UIImage(lucideId: "tada") {
    Image(uiImage: uiImage)
}
```

While this is a very convenient way to use Lucide Icons in your Swift project, depending on this package does increase the size of your project. In practice this probably doesn't matter much at all. Lucide Icons are SVG files, which are incredibly small. Also, I believe only the icons that you use in your project are included in the final build. But if you'd like to avoid a dependency, you can also use the SVG files directly.
## Using SVG files in SwiftUI
SVG files can be stored in your project and used directly in SwiftUI. But using them isn't quite as simple as loading an SF Symbol in a SwiftUI view. Thankfully Exyte's library [SVGView](https://swiftpackageindex.com/exyte/SVGView) makes this much easier. 

```swift
if let url = Bundle.main.url(forResource: "example", withExtension: "svg") {
    SVGView(contentsOf: url)
}
```

## Converting SVG Files to SwiftUI `Path` Views
If you ever read an svg file, you'll learn that they are just directions for drawing a path. If you look inside a web page's HTML, you might see something like this:

```html
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-smile-icon lucide-smile">
    <circle cx="12" cy="12" r="10"/>
    <path d="M8 14s1.5 2 4 2 4-2 4-2"/>
    <line x1="9" x2="9.01" y1="9" y2="9"/>
    <line x1="15" x2="15.01" y1="9" y2="9"/>
</svg>
```

That's the [Lucide Icon for a smiley face](https://lucide.dev/icons/smile). While this is definitely not the most readable format, it's really just a set of instructions for drawing a path. Say, doesn't SwiftUI also have an API for drawing paths? Yes, it does! You can use the `Path` view to draw a path in SwiftUI. You can find [Apple's official tutorial here](https://developer.apple.com/tutorials/swiftui/drawing-paths-and-shapes). This API is much more human-readable than SVG, and it's also deeply tied into the animation system in SwiftUI. So if you want to create a custom icon, you can use the `Path` view to draw it. 

If only there were a way to easily convert SVG paths into SwiftUI `Path` views, allowing for seamless integration of custom icons into your projects. Well apparently there is! Quassum made an incredibly helpful, simple web tool called [SVG to SwiftUI](https://svg-to-swiftui.quassum.com/) that allows you to convert SVG paths into SwiftUI `Path` views. You can simply paste the SVG path into the tool, and it will generate the SwiftUI code for you. So for example, we can go to Lucide, copy the SVG path for the smiley face icon, and paste it into the tool. The tool will generate the following SwiftUI code:
```swift
struct MyIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.14583*width, y: 0.54167*height))
        path.addLine(to: CGPoint(x: 0.39583*width, y: 0.54167*height))
        path.move(to: CGPoint(x: 0.08333*width, y: 0.66667*height))
        path.addLine(to: CGPoint(x: 0.27083*width, y: 0.29167*height))
        path.addLine(to: CGPoint(x: 0.45833*width, y: 0.66667*height))
        path.move(to: CGPoint(x: 0.75*width, y: 0.29167*height))
        path.addLine(to: CGPoint(x: 0.75*width, y: 0.66667*height))
        path.move(to: CGPoint(x: 0.58333*width, y: 0.5*height))
        path.addLine(to: CGPoint(x: 0.75*width, y: 0.66667*height))
        path.addLine(to: CGPoint(x: 0.91667*width, y: 0.5*height))
        return path
    }
}
```

While this code is much longer, it's also much easier to read and it can be used in your SwiftUI project to create a custom icon. You can also use the `fill` and `stroke` modifiers to change the color of the icon, and you can use the `animation` modifier to add animations to the icon!

## Creating Custom SF Symbols
SVG symbols bring so much of the power of SF Symbols. They're scalable, we can easily change their color, and by converting them into a SwiftUI `Path` view, it's easy to animate them and change their line width. But they are still not deeply integrated into the font system like SF Symbols are. So what if we could create our own SF Symbols? Well, it turns out that you can! 

Check out this article by [_David Smith](https://david-smith.org/blog/2023/01/23/design-notes-18/) on how to create custom SF Symbols. 

## Conclusion
So to recap our journey, we started with SF Symbols, which are a great resource for icons in SwiftUI. But they have a limited selection of icons. Then we looked at Lucide Icons, which is one of many open-source icon libraries that contains over 1,000 icons in many common formats including SVG files. Then, we looked at how to convert SVG files into SwiftUI `Path` views, allowing us to create custom icons that fit our app’s design language. Finally, we looked at how to create our own SF Symbols, which allows us to create custom icons that are deeply integrated into the font system.