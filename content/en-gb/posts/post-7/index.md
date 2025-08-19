---
title: How to Scroll to a Percentage in a ScrollView
slug: scroll-to-percentage-in-scrollview
date: 2024-07-30
topics:
  - SwiftUI
images:
  - image.jpg
decription: Learn how to programmatically move a SwiftUI ScrollView to a precise numeric position.
tags:
  - SwiftUI
---
SwiftUI can make many tasks extremely easy, yet SwiftUi struggles to do other seemingly simple tasks. Today we will learn how to accomplish one of those tasks. We will create a ScrollView that can programmatically scroll to a specific location within the ScrollView. First let's create a new type called `ProgrammaticScrollView`. 


```swift
struct ProgrammaticScrollView<Content: View>: View {
  @Binding private var scrollID: Int?
  let content: () -> Content
  init(scrollID: Binding<Int?>, @ViewBuilder content: @escaping () -> Content) {
    self._scrollID = scrollID
    self.content = content
  }
  
  var body: some View {
    ScrollView {
      ForEach(1..<101) { num in
        VStack {
          Text("\(num)").frame(maxWidth: .infinity, alignment: .leading)
            .id(num)
          Spacer()
        }
      }
    }
    .scrollPosition(id: $scrollID, anchor: .top)
  }
}
```

Here we're using iOS 17's new [scrollPosition(id: anchor:)](https://developer.apple.com/documentation/swiftui/view/scrollposition(id:anchor:)) method. This method receives an `id` of type `Binding<(some Hashable)?>` and then scrolls to a child view with that id. As you can see there are 100 child views numbered 1 to 100, each with a corresponding id. Programmatically scrolling is now as simple as changing the value of our scrollID Binding!

Notice how the numbers are evenly spaced vertically. Now why don't we hide those numbers from the user? 

```swift 
// ...
 ScrollView {
      content()
        .padding(.horizontal)
        .background {
          VStack {
            ForEach(1..<101) { num in
              VStack {
                Text("\(num)").frame(maxWidth: .infinity, alignment: .leading)
                  .id(num)
                  .opacity(0.0)
                Spacer()
              }
            }
          }
        }
    }
    .scrollPosition(id: $scrollID, anchor: .top)
// ...
```

You might be thinking, why don't we just use ScrollViewReader. Well, the techniques in this tutorial should be just as easy to implement using iOS 14's `ScrollViewReader`. It would just be slightly more complex since you would need to wrap your `ScrollView` in a `ScrollViewReader` and then give commands to a `ScrollViewProxy`. 

## Some Quirks
`scrollPosition(id: anchor:)` has some other benefits over `ScrollViewReader`. The docs promise that the ScrollView will automatically update the Binding, thus giving you the freshest position of the ScrollView. The docs say:

>As the scroll view scrolls, the binding will be updated with the identity of the leading-most / top-most view.

Unfortunately, seemingly due to bugs, it just doesn't do that at all. In my testing, the Binding is just never updated by the ScrollView. But at least you can scroll programmatically. 

Also, the docs say that you must use `scrollTargetLayout()`. I don't see why. I have found no difference in behavior with or without that method, so I'm just leaving it out of my view. 

## iOS 18's New API
Now apparently, iOS 18 added yet another new method called [scrollPosition(_: anchor:)](https://developer.apple.com/documentation/swiftui/view/scrollposition(_:anchor:)) which receives a new `ScrollPosition` type. (I haven't tried the new iOS 18 beta yet, so I don't know if this actually works yet.)

## In Practice
Now that have something workable, let's take it for a spin.

```swift
struct ExampleView: View {
  @State private var scrollPercentage: Int? = 1
  @State private var picker = 34
  var body: some View {
    ProgrammaticScrollView(scrollID: $scrollPercentage)
      .safeAreaInset(edge: .bottom) {
        bottomBar
      }
  }
  
  @ViewBuilder var bottomBar: some View {
    VStack {
      HStack {
        Picker("Select a number", selection: $picker) {
          ForEach(0..<100) { num in
            Text("\(num)").id(num)
          }
        }
        Button("Scroll to \(picker)%") { scrollPercentage }
      }
      LabeledContent("scrollPercentage", value: "\(scrollPercentage)") // useful for debugging
    }
    .padding(.horizontal)
    .background(.thinMaterial, ignoresSafeAreaEdges: .bottom)
  }
}
struct CircleButton<Background: ShapeStyle>: ButtonStyle {
  let background: Background
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding()
      .background(background, in: .circle)
  }
}
```

Now we have a View where we can test programmatically scrolling our scroll view to any arbitrary position on our screen. This type of behavior would be extremely helpful for situations such as scrolling the transcript of a podcast, to current position of the audio while listening. 

Today we learned how, with a little bit of ingenuity we can add powerful features to our UI. If you'd like to see a full code example, you can have a look at this [gist](https://gist.github.com/DandyLyons/e95af09ad40a8a7e9ee9bb04931fca3e).

If you like this work, please share it with others. Check back every week on Wednesdays for new posts.


