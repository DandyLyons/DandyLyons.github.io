---
related:
  - "[[Metal]]"
  - "[[Inferno]]"
tags:
  - AppleSDK/Metal
  - open-source/Inferno
publish: true
---
As an indie dev, with a small team, it can feel impossible to create apps that standout with powerful visual effects. In 2014, Apple released [[Metal]], a powerful library and [shading language](https://en.wikipedia.org/wiki/Shading_language) for GPU-accelerated visuals. In 2019, Apple released SwiftUI, making it dramatically simpler to make UI's. And in 2023, Apple made it much easier to use Metal within SwiftUI. 

But it is no easy task to learn Metal. It is a language that is quite different from Swift, and is much more similar to C. Thankfully, [[Paul Hudson]] from [Hacking with Swift](https://www.hackingwithswift.com), has made an invaluable resource for learning and using Metal shaders and it's called Inferno. It comes with a whole host of dazzling metal shaders which you can immediately use in your project for free, extensive documentation, extremely helpful videos (below) and even a Sandbox mac app to try out the shaders interactively. 


> [!NOTE]- What is a shader?
> In [computer graphics](https://en.wikipedia.org/wiki/Computer_graphics "Computer graphics"), a **shader** is a [computer program](https://en.wikipedia.org/wiki/Computer_program "Computer program") that calculates the appropriate levels of [light](https://en.wikipedia.org/wiki/Light "Light"), [darkness](https://en.wikipedia.org/wiki/Darkness "Darkness"), and [color](https://en.wikipedia.org/wiki/Color "Color") during the [rendering](https://en.wikipedia.org/wiki/Rendering_(computer_graphics) "Rendering (computer graphics)") of a [3D scene](https://en.wikipedia.org/wiki/3D_scene "3D scene")—a process known as _[shading](https://en.wikipedia.org/wiki/Shading "Shading")_. Shaders have evolved to perform a variety of specialized functions in computer graphics [special effects](https://en.wikipedia.org/wiki/Special_effects "Special effects") and [video post-processing](https://en.wikipedia.org/wiki/Video_post-processing "Video post-processing"), as well as [general-purpose computing on graphics processing units](https://en.wikipedia.org/wiki/General-purpose_computing_on_graphics_processing_units "General-purpose computing on graphics processing units").
> - [Shader - Wikipedia](https://en.wikipedia.org/wiki/Shader)

## Intro Video
![Introducing Inferno: Metal shaders for SwiftUI - YouTube](https://www.youtube.com/watch?v=jriUylwcnmU) 

## In-Depth Video
![SwiftUI + Metal – Create special effects by building your own shaders - YouTube](https://www.youtube.com/watch?v=EgzWwgRpUuw)
## Getting Started 

First let's download the repo from [GitHub](https://github.com/twostraws/Inferno/tree/main?tab=readme-ov-file#inferno-sandbox). I recommend cloning the whole repository because it includes an extremely helpful sandbox app where you can see all of the included shaders visually. That said, Paul also says you can just copy the shader you want to use directly into your project. 

> To use a shader from here, copy the appropriate .metal file into your project, then start with sample code for that shader shown below. If you're using an Inferno transition, you should also copy Transitions.swift to your project.
> - [GitHub - twostraws/Inferno: Metal shaders for SwiftUI.](https://github.com/twostraws/Inferno/tree/main?tab=readme-ov-file#how-to-use-inferno-in-your-project) 

### Using the Sandbox
After you've cloned the repo, in the `Sandbox` directory you should find `InfernoSandbox.xcodeproj`. Open it. Set your build to "My Mac" and voila! Now you have a mac app with dozens of Metal shaders to test out! More importantly, you have all of the source code, so you can see exactly how it works and customize it to your hearts content! Wow, look at all of these amazing shaders!

![[Screen Recording 2024-03-23 at 10.02.20 AM.mov]]

## Understanding How It Works
In the InfernoSandbox app we have a few categories of shaders: 
- Simple Transformation
- Animated
- Touchable: These are interactive and will change how they look based on clicks, taps, and drags.
- Transitions: These are shaders that will animate as one SwiftUI View replaces another. 
- Generation: These shaders generate entirely new content from scratch. 
- Blurs

Let's go to the `Gradient Fill` shader inside the **InfernoSandbox** app. 


> [!tip] Preview types
> As you can see there is a picker to view each shader as a Emoji, Image, Shape, or Symbol. Be sure to try each. Some shaders are difficult to see in certain preview modes. 

Now let's look at the source code. In the Xcode project, go to `Inferno/ShaderPreviews/SimpleTransformationPreview.swift`. This is the code that renders the detail view for all the shaders in the **Simple Transformation** section. 

On line 23 we see: 
```swift 
/// The shader we're rendering.
var shader: SimpleTransformationShader
```

Let's right click `SimpleTransformationShader` and then **Jump to Definition**. It's a simple convenience struct holding all the information necessary to create the correct shader. 

Scroll to line 52 and we see: 
```swift
func createShader(color: Color, value: Double, size: CGSize = .zero) -> Shader {
// ...
}
```

This is the function that creates the actual shader and it returns a `Shader` type. Let's jump to that definition. This is how the magic works! We see here that a `Shader` is: 
```swift
/// A reference to a function in a Metal shader library, along with its
/// bound uniform argument values.
```
### The SwiftUI <-> Metal  pipeline

1. **SwiftUI**: We use SwiftUI just as we normally would. 
2. We use a `Shader` accepting View function such as `colorEffect(_:,isEnabled:)` 
	- These functions pass the `Shader` to Metal.
	- Going back to `SimpleTransformationPreview.swift` we can see this used under `ContentPreview` 
1. The `Shader` type:
	- conforms to [[ShapeStyle]]
	- You can use one of SwiftUI's many built-in `Shader` implementations (via built in functions such as `.blur()`)
	- You can use one of Paul's many `Shader` implementations from Inferno
	- You can customize or create your own `Shader`
2. Metal:
	- Finally, there is Metal, where you can write a shader using a `.metal` file. 

### `Shader` accepting `View` methods
SwiftUI provides the following View methods to accept Metal shaders: 
- [colorEffect](https://developer.apple.com/documentation/swiftui/view/coloreffect(_:isenabled:))
- [distortionEffect](https://developer.apple.com/documentation/swiftui/view/distortioneffect(_:maxsampleoffset:isenabled:))
- [layerEffect](https://developer.apple.com/documentation/swiftui/view/layereffect(_:maxsampleoffset:isenabled:))
- [visualEffect](https://developer.apple.com/documentation/swiftui/view/visualeffect(_:)) 
	- Be sure to also check out the `VisualEffect` [protocol](https://developer.apple.com/documentation/swiftui/visualeffect) 

### How do `Shader`s work?
The `Shader` struct, provided by Apple, is an interface for Metal and SwiftUI to communicate with each other. We don't create a `Shader` struct in Swift. Rather we create our shader in Metal, and if we follow a precise format then SwiftUI will take that `.metal` file and create a `Shader` for us. 

In the Project Navigator in your Xcode sidebar, under Package Dependendencies, open up the Inferno package. Look at `Sources/Inferno/Shaders/Transformation/GradientFill.metal`. This is the same shader that we're looking at in the InfernoSandbox app! 

```C++
#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 gradientFill(float2 position, half4 color) {
    // Send back a new color based on the position of the pixel
    // factoring in the original alpha to get smooth edges.
    return half4(position.x / position.y, 0.0h, position.y / position.x, 1.0h) * color.a;
}
```

> [!NOTE] Sigh, semicolons; I never missed you.

This function, like any metal shader, is simply instructions on how to calculate the color for one pixel. Metal will run this function in parallel for each and every pixel in that SwiftUI View!
Let's break this down:
- `[[ stichable ]]`: This syntax tells metal that it can use this function with SwiftUI. 
- `half4`: this is the return type of the function. It holds 4 numbers, for red, green, blue, and opacity (alpha) respectively. 
- `gradientFill` this is the name of the function. This is important because it is what we will be calling in our SwiftUI code. 
- Then we have the parameter list of our function: 
	- `float2 position`: a number describing the position in the `float2` type
	- `half4 color`: a number for the color in the `half4` type

Paul will do a much better job than me of explaining exactly how this shader works [here](https://www.youtube.com/watch?v=EgzWwgRpUuw&t=1024s) .


> [!tip] You now have the super power of customizing visuals!!
> While this may seem intimidating, the important takeaway is this, Metal allows you the power to deeply customize how your app looks, and does so in a way that won't kill the performance of your app! 🔥 This is the same tech that giant video game companies use to make their blockbusters! 
> 
> 1. Start out learning and understanding how Paul's shader's work. 
> 2. Then try customizing his shaders to deepen your understanding. 
> 3. Finally, when you are ready, then try making one of your own. 

## Creating a Shimmer Shader
Today, I'd like to create a somewhat common shimmer effect. You can see it used in many apps and libraries including [SwiftUI-Shimmer](https://swiftpackageindex.com/markiv/SwiftUI-Shimmer). 

![](https://github.com/markiv/SwiftUI-Shimmer/raw/main/docs/Shimmer-visionOS.gif)

Let's try our best to recreate this effect using a Metal shader.

### Deciding on a Format
First we need to decide what kind of `Shader` we will use. This will determine which SwiftUI method we will call to access our `Shader`, as well as the capabilities/limitations of our `Shader`. To review, the methods that SwiftUI now provides are: 
- [colorEffect](https://developer.apple.com/documentation/swiftui/view/coloreffect(_:isenabled:)): 
	- >Returns a new view that applies `shader` to `self` as a <u>filter effect</u> on the color of each pixel.
	- The Gradient Fill Shader we saw earlier was a colorEffect. It only changed the color information of each pixel. NOT the location. 
> For a shader function to act as a color filter it must have a function signature matching:
> ```C++
> [[ stitchable ]] half4 name(float2 position, half4 color, args...)
>```
> where position is the user-space coordinates of the pixel applied to the shader and color its source color, as a pre-multiplied color in the destination color space. args... should be compatible with the uniform arguments bound to shader. The function should return the modified color value.

- [distortionEffect](https://developer.apple.com/documentation/swiftui/view/distortioneffect(_:maxsampleoffset:isenabled:)): 
	- >Returns a new view that applies `shader` to `self` as a <u>geometric distortion</u> effect on the location of each pixel.
>For a shader function to act as a distortion effect it must have a function signature matching:
> ```C++
> [[ stitchable ]] float2 name(float2 position, args...)
> ```
> where `position` is the user-space coordinates of the destination pixel applied to the shader. `args...` should be compatible with the uniform arguments bound to `shader`. The function should return the user-space coordinates of the corresponding source pixel.

- [layerEffect](https://developer.apple.com/documentation/swiftui/view/layereffect(_:maxsampleoffset:isenabled:)): 
	- >Returns a new view that applies `shader` to `self` as a <u>filter</u> on the raster layer created from `self`.
	- Think of layerEffect like the layers in Photoshop. 

> For a shader function to act as a layer effect it must have a function signature matching:
> ```C++
> [[ stitchable ]] half4 name(float2 position, SwiftUI::Layer layer, args...)
> ```
> where position is the user-space coordinates of the destination pixel applied to the shader, and layer is a subregion of the rasterized contents of self. args... should be compatible with the uniform arguments bound to shader.

- [visualEffect](https://developer.apple.com/documentation/swiftui/view/visualeffect(_:)): 
	- >Applies effects to this view, while providing access to <u>layout information</u> through a geometry proxy.

### The Color Effect
For our shimmer shader, we will be animating a shine that moves from one side of our View to another. Which effect do you think we should use? The question is, what type of transformation do we want to apply to our pixels? Do we want to move a pixel from one position to another? Then we'd want to use `distortionEffect`. Do we want to change the color information? Then we'd want to use `colorEffect`. Do we want to layer multiple effects on top of each other? Then `layerEffect` is appropriate. Do we want to have access to the SwiftUI View geometry proxy to access layout information? Then `visualEffect` is the one to use. 

It seems like the right tool for this job is `colorEffect` since we'll be increasing the brightness of pixels for the shimmer effect, but we won't be moving the pixels. 

### Creating Our First Metal Shader
Now let's "hello world", if you will to implement our first shader. First, open the Inferno package in Xcode. Go to `Sources/Inferno/Shaders/Transformation/`. Here we will create a new file called `Shimmer.metal`. Now, go to `Gradient Fill.metal` and copy the code into our new file. Let's observe what's there already: 

```c++
#include <metal_stdlib> // 1. 
#include <SwiftUI/SwiftUI_Metal.h> // 2. 
using namespace metal; // 3. 

/// A shader that generates a shimmering effect.
///
/// This creates a diagonal shimmering effect which animates from one side to another.
///
/// - Parameter position: The user-space coordinate of the current pixel.
/// - Parameter color: The current color of the pixel, used for alpha calculations.
/// - Returns: The new pixel color.
[[ stitchable ]] half4 gradientFill(float2 position, half4 color) { // 4. 
  // Send back a new color based on the position of the pixel
  return half4(position.x / position.y, 0.0h, position.y / position.x, 1.0h) * color.a;
}
```
1. We import the Metal library. 
2. This line "connects" Metal to SwiftUI. 
3. In Metal shading language, `using namespace metal;` is a directive that allows you to refer to Metal-specific types and functions without explicitly specifying the namespace each time you use them.
4. **<u>This part is very important.</u>** Remember, Metal shaders are very flexible and can be used for all sorts of parallel processing tasks including 2D, 3D, and machine learning. But we want to use this function for SwiftUI, specifically as a `colorEffect`. In order for SwiftUI to use this function as a `colorEffect` it must match this shape exactly, or SwiftUI will ignore it.: 
	1. It must be `[[ stichable ]]`. 
	2. It must return `half4`
	3. `gradientFill` is the name of the function. We can name this whatever we want. In our case we will **rename it to `shimmer`**.
	4. The first parameter must be type `float2` but you can name it whatever you want. 
	5. The first parameter must be type `half4` but you can name it whatever you want. 
	6. Everything between the `{ }` is our implementation. We can make that whatever we want. 

### Previewing Our Shader
Now look back at the Xcode project. Open `Inferno/ShaderPreviews/SimpleTransformationShader.swift` , and scroll down to the `shaders` array. We'll add one more element: `SimpleTransformationShader(name: "Shimmer", usesReplacementColor: false)`. (Don't worry too much about the `SimpleTransformationShader` type. It's internal to InfernoSandbox. We're just using it now to get a usable preview.) 

Now build and run the project. (You can build it as any platform including iOS and mac, but for this tutorial we'll see it as a mac app). Now if you look in the sidebar of your InfernoSandbox app, there should be a new row called `Shimmer`. If you click that row, it should display a view that looks just like the "Gradient Fill" view, because we copied over that shader. 


> [!tip] SwiftUI Previews
> You can also view this in a SwiftUI Preview. Just be aware, that the Preview doesn't seem to notice when you make changes in the `.metal` file, even if you refresh the Preview manually. Instead you must close and reopen the SwiftUI Preview. This is still a much faster feedback cycle than building the entire mac app. 
> 
> So I like to iterate using SwiftUI Preview, but I still like to add it as a row in InfernoSandbox, just so I have an environment to play around with it later. (This will come in especially handy if you choose to make interactive shaders.)



### A Non-Animated Shimmer
Starting simple, let's figure out how to make certain pixels "shine". We can then figure out how to animate this later. 

First let's make a simple passthrough filter with some easier to read variables: 
```c++
[[ stitchable ]] half4 shimmer(float2 pos, half4 color) {
  // Send back a new color based on the position of the pixel
  half r = (color.r);
  half g = (color.g);
  half b = (color.b);
  half a = (color.a);
  
  half4 result = half4(r, g, b, 1.0h) * a;
  
  return result;
}
```

We are returning a half4 which is basically just a tuple of 4 half values. And a half is a 16-bit floating point type. This half4 represents the color for 1 pixel. 

We receive two parameters: 
1. a `float2` representing the x and y position
2. a `half4` representing the color of the pixel that we represented from swiftui. 

So, above we are simply passing along the same pixel information that we received, so the image should look unchanged. 

![[Screenshot 2024-03-23 at 9.38.40 PM.png]]
### Let's Put A Shine On That Image
Now we want to make it shimmer. So we want to make certain pixel's brighter than normal. To do that let's bump up the value of each pixel by about 70%. 

```c++
[[ stitchable ]] half4 shimmer(float2 pos, half4 color) {
  // Send back a new color based on the position of the pixel
  half r = (color.r);
  half g = (color.g);
  half b = (color.b);
  half a = (color.a);
  
  half4 result = half4(r, g, b, 1.0h) * a + (color * 0.7);
  
  return result;
}
```

![[Screenshot 2024-03-23 at 9.43.31 PM.png]]

But we don't want every pixel to be brighter. Just some of them. We want a horizontal line of pixels to be brighter and the rest of the pixels to be unaffected. Let's take some inspiration from that Gradient Fill Shader that we saw earlier. 

```c++
[[ stitchable ]] half4 shimmer(float2 pos, half4 color) {
  half r = (color.r);
  half g = (color.g);
  half b = (color.b);
  half a = (color.a);
  
  // shine percent
  half4 shineP = (color * 0.7);
  if (pos.y > pos.x) {
    shineP = 0;
  }
  
  half4 result = half4(r, g, b, 1.0h) * a + shineP;
  
  return result;
}
```

![[Screenshot 2024-03-23 at 9.51.47 PM.png]]

Here any pixel where the y position is greater than the x position, will receive a brighter shine. 

Now lets remove some more shine: 

```c++
[[ stitchable ]] half4 shimmer(float2 pos, half4 color) {
  half r = (color.r);
  half g = (color.g);
  half b = (color.b);
  half a = (color.a);
  
  // shine percent
  half4 shineP = (color * 0.7);
  if ((pos.y > pos.x) || (pos.y + 150 < pos.x) ) {
    shineP = 0;
  }
  
  half4 result = half4(r, g, b, 1.0h) * a + shineP;
  
  return result;
}
```
![[Screenshot 2024-03-23 at 9.59.51 PM.png]]
## Conclusion
Metal is an extremely powerful API to empower us with fast, low-level, performant graphics. We've barely scratched the surface here. Metal can even be used for 3D graphics, and even machine learning and AI. But now you know how easy it is to start learning it and adding it to your SwiftUI project. 

## Further Reading
- [Metal | Apple Developer Documentation](https://developer.apple.com/documentation/metal)
- [[Jacob Bartlett]] has an incredible deep dive: [Metal in SwiftUI: How to Write Shaders - by Jacob Bartlett](https://jacobbartlett.substack.com/p/metal-in-swiftui-how-to-write-shaders#%C2%A7the-book-of-shaders) 
