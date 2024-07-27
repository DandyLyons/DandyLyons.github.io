---
title: 7 Ways to Organize SwiftUI Code
date: 2021-05-06
topics: ['SwiftUI']
slug: 7-ways-to-organize-swiftui
---

> NOTE:
> I originally posted this blog post to Medium, [here](https://medium.com/@_DandyLyons/7-ways-to-organize-swiftui-code-e786307d3916).


SwiftUI is a complete paradigm shift in how we write apps for Apple platforms. It’s functional and declarative rather than object-oriented and imperative. And there is no need for ViewControllers anymore! While all of this means that we can write code that is more readable, testable, and reusable, it also means that we don’t have decades of tried and true architecture patterns to draw from.

Thankfully SwiftUI makes it easy to break apart your code into reusable components. Today, I’d like to explore all the ways I’ve found to organize SwiftUI code. (Actually, I’m not so much talking about the architecture. Instead, right now I’d like to explore the different techniques we can use to split SwiftUI code into smaller, more manageable piece.)

## A Bad Example

Throughout this blog post, I’ll be looking at an example of “bad” SwiftUI code. This code is bad, not because it’s non-performant. It’s actually just as performant as all of the later, examples. Neither is it bad because it’s verbose. It’s actually quite short. Only 27 lines of code. No, this code is bad because it’s really confusing to read:

```swift
struct NestedListExample: View {  
    @State var notificationsOn: Bool = false  
    @State var soundOn: Bool = true  
    @State var hapticsOn: Bool = true  
      
    var body: some View {  
        NavigationView {  
            List {  
                NavigationLink("Settings", destination:  
                    List {  
                        NavigationLink("Notifications", destination:  
                            List {  
                                Toggle("Notifications: ", isOn: $notificationsOn)  
                            }.navigationTitle("Notifications")  
                        )  
                        NavigationLink("Sound and Haptics", destination:  
                            List {  
                                Toggle("Sound: ", isOn: $soundOn)  
                                Toggle("Haptics: ", isOn: $hapticsOn)  
                            }.navigationTitle("Notifications")  
                        )  
                    }.navigationTitle("Settings")  
                )  
            }  
            .navigationTitle("1st List")  
        }  
    }  
}
```

This monstrosity, is technically valid SwiftUI code, but I wouldn’t recommend using it. It’s three layers deep of nested `List`s. Let’s look at how we can split it into smaller pieces that are easier to read, reason, test, reuse and maintain.

## Your SwiftUI App is just one giant View

First, let’s look at that these two templates that we’ve see a million times:

```swift
// Example App.swift  
import SwiftUI  
  
@main  
struct ExampleApp: App {  
    var body: some Scene {  
        WindowGroup {  
            ContentView()  
        }  
    }  
}// ContentView.swift  
import SwiftUI  
  
struct ContentView: View {  
    var body: some View {  
        Text("Hello, world!")  
            .padding()  
    }  
}
```

Pardon me for stating the obvious, `ExampleApp`calls `ContentView()`which means that if you wanted to you could condense `ExampleApp` and `ContentView`into one file like this:

```swift
// ExampleApp.swift  
import SwiftUI  
  
@main  
struct ExampleApp: App {  
    var body: some Scene {  
        WindowGroup {  
            Text("Hello, world!")  
                .padding()  
        }  
    }  
}
```

A SwiftUI app is really just an `App` holding a `Scene`, holding a `View`, holding a `View`, holding a `View`, etc. In fact, you could run your entire app from one file. **Obviously, I wouldn’t recommend this.** But just knowing that we can shows us the first way to split SwiftUI code.

## Seven Ways To Split Your SwiftUI Code

## Method #1: Extract To Separate Struct

If we look at my combined `ExampleApp` implementation, and Apple’s template of `ExampleApp` and `ContentView` we can see that Apple extracted `Text("Hello, world!").padding()` out into its own `View` struct called `ContentView`. We can follow this pattern for any of our views.

Let’s look at how we could use this in our monster List example from earlier:

```swift
// NestedListExample.swift  
struct NestedListExample: View {  
    @State var notificationsOn: Bool = false  
    @State var soundOn: Bool = true  
    @State var hapticsOn: Bool = true  
      
    var body: some View {  
        NavigationView {  
            List {  
                NavigationLink("Settings", destination:  
                                SettingsView(notificationsOn: $notificationsOn, soundOn: $soundOn, hapticsOn: $hapticsOn)  
                )  
            }  
            .navigationTitle("1st List")  
        }  
    }  
}  
  
// NotificationsView.swift  
struct NotificationsView: View {  
    @Binding var notificationsOn: Bool  
      
    var body: some View {  
        List {  
            Toggle("Notifications: ", isOn: $notificationsOn)  
        }.navigationTitle("Notifications")  
    }  
}  
  
// SettingsView.swift  
struct SettingsView: View {  
    @Binding var notificationsOn: Bool  
    @Binding var soundOn: Bool  
    @Binding var hapticsOn: Bool  
      
    var body: some View {  
        List {  
            NavigationLink("Notifications", destination:  
                            NotificationsView(notificationsOn: $notificationsOn)  
            )  
            NavigationLink("Sound and Haptics", destination:  
                            SoundAndHapticsView(soundOn: $soundOn, hapticsOn: $hapticsOn)  
            )  
        }.navigationTitle("Settings")  
    }  
}  
  
// SoundAndHapticsView.swift  
struct SoundAndHapticsView: View {  
    @Binding var soundOn: Bool  
    @Binding var hapticsOn: Bool  
      
    var body: some View {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            Toggle("Haptics: ", isOn: $hapticsOn)  
        }.navigationTitle("Notifications")  
    }  
}
```

🙀 Ay caramba! Now the code is even longer and more confusing! Well actually no. This new code is far more readable. There’s no longer a pyramid of doom.

Also, it’s easier to maintain and edit. What if your designer designer said to you “Actually, could you please move the notifications onto the sound page?” Now it is much easier to simply paste `NotificationsView()` wherever you want to use it.

Yes this new code is quite a bit longer (54 lines as opposed to just 27 lines before) but shorter is not always better, especially if it means making your code less readable.

Still, this approach does have a drawback. Every nested struct loses access to its parent’s properties, which means that we have to pass in a binding into each struct. While this method is great at separating our Views into smaller pieces, some times it adds more friction than it’s worth. Let’s look at some other methods.

> **Quick Tip:** Let Xcode do at least some of the work for you. If you ⌘-Click any subview and choose `Extract subview` then Xcode will create the separate struct for you! Wow! But bear in mind it won’t create any properties that you will need. At least it can do a lot of the busywork for you.

## Method #2: Extract To Local Computed Property

Looking more at all over our SwiftUI code we can see that every single View contains `var body: some View`. Don’t let SwiftUI’s “magic” fool you. It’s not magic at all. This is just a plain old computed property which is built into the Swift language. So:

```swift
var body: some View {  
	Text("Hello World!")  
}

Is really just short for:

var body: some View {  
	get {  
		return Text("Hello World!")  
	}  
}
```

We can use this exact same approach anywhere in our code. For example like this:

```swift
struct NestedListExample: View {  
    @State var notificationsOn: Bool = false  
    @State var soundOn: Bool = true  
    @State var hapticsOn: Bool = true  
      
    var body: some View {  
        NavigationView {  
            List {  
                NavigationLink("Settings", destination:  
                    settings  
                )  
            }  
            .navigationTitle("1st List")  
        }  
    }  
      
    var settings: some View {  
        List {  
            NavigationLink("Notifications", destination:  
                notifications  
            )  
            NavigationLink("Sound and Haptics", destination:  
                soundAndHaptics  
            )  
        }.navigationTitle("Settings")  
    }  
      
    var notifications: some View {  
        List {  
            Toggle("Notifications: ", isOn: $notificationsOn)  
        }.navigationTitle("Notifications")  
    }  
      
    var soundAndHaptics: some View {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            Toggle("Haptics: ", isOn: $hapticsOn)  
        }.navigationTitle("Notifications")  
    }  
}
```

Once again, our code is more readable, but notice that this time we didn’t have to pass any `Binding`s. Why? Because everything is inside the same struct. It can just read the same properties that are already there.

## Method #3: Extract To A Function

Remember before that we extracted our subview out into a computed property? Well what is a computed property? Really, it’s just a function. So:

```swift
var soundAndHaptics: some View {  
	List {  
		Toggle("Sound: ", isOn: $soundOn)  
		Toggle("Haptics: ", isOn: $hapticsOn)  
	}.navigationTitle("Notifications")  
}
```

can be rewritten as:

```swift
func soundAndHaptics() -> some View {  
    List {  
        Toggle("Sound: ", isOn: $soundOn)  
        Toggle("Haptics: ", isOn: $hapticsOn)  
    }.navigationTitle("Notifications")  
}
```

It’s basically exactly the same thing. In fact, the compiler thinks it’s the exact same thing. If you include both of these definitions, then the compiler will say `Invalid redeclaration of 'soundAndHaptics()'`which means that a computed property is really just another function under the hood.

However, there is a difference at the call site. If you declare it as a computed variable then you will call it with `soundAndHaptics`. But if you declare it as a func then you will call it with `soundAndHaptics()`. The extra `()` tells Swift that we are running that function inline and immediately using the returned View.

Still, I probably wouldn’t use this extraction method very often. Why? Semantics. When I think of a func, I think of verbs. When I think of a var I think of nouns. In my brain, `View`s are nouns.

==However, one difference between a func and a computed property is that computed properties can’t accept parameters. But a func can. So we could write something like this:==

```swift
func soundAndHaptics(isPremiumUser: Bool) -> some View {  
    let anyView: AnyView  
      
    if isPremiumUser {  
        anyView = List {  
            Toggle("Sound: ", isOn: $soundOn)  
            Toggle("Haptics: ", isOn: $hapticsOn)  
        }.navigationTitle("Notifications") as! AnyView  
    } else {  
        anyView = List {  
            Toggle("Sound: ", isOn: $soundOn)  
            // Haptics are not included for non premium users  
        }.navigationTitle("Notifications") as! AnyView  
    }  
    return anyView  
}
```

Now that we’re using a func instead of a computed property, we can add more logic to dynamically change the View as necessary. (There are better ways to achieve that variability, but it’s nice to know that this is another tool in the toolbox.)

## Method #4: Extract To an @ViewBuilder Function

If you’ve been paying attention then that last method must have left a bad taste in your mouth. _Why is he using AnyView?_ Anytime, you see AnyView, it’s a sign that there’s probably a better way to do what you’re trying to do. And oftentimes that better way is `@ViewBuilder`. Let’s look at how we can use `@ViewBuilder` to clean up our last example.

```swift
@ViewBuilder  
func soundAndHaptics(isPremiumUser: Bool) -> some View {  
    if isPremiumUser {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            Toggle("Haptics: ", isOn: $hapticsOn)  
        }.navigationTitle("Notifications")  
    } else {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            // Haptics are not included for non premium users  
        }.navigationTitle("Notifications")  
    }  
}
```

Now, Swift no longer complains. We don’t have to type erase with AnyView anymore. John Sundell does a great job of explaining this here: Avoiding SwiftUI’s AnyView

This method is used extensively in Apple’s own SwiftUI framework. Take a look at the declaration of VStack. It’s initializer accepts a parameter called `content` that looks like this: `@ViewBuilder content: () -> Content`This is just a function, just like the one we just made. And as we can see in the declaration of VStack here:

`@frozen struct VStack<Content> where Content : View`

Content is just a generic name for any type that conforms to View.

So while @ViewBuilder functions might be somewhat useful when we want to separate a subview, they are way more useful when we want to accept a @ViewBuilder from someone else.

## Method #5: Extract To an @ViewBuilder Computed Property

It’s worth mentioning that computed properties can also be wrapped in a `@ViewBuilder`. `@ViewBuilder` is just a `@resultBuilder`. `@ResultBuilder` ’s can be applied to functions, and since computed properties are basically functions under the hood, that means you can use `@ViewBuilder` on a computed property!

So we can rewrite:

```swift
// func version  
@ViewBuilder  
func soundAndHaptics(isPremiumUser: Bool) -> some View {  
    if isPremiumUser {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            Toggle("Haptics: ", isOn: $hapticsOn)  
        }.navigationTitle("Notifications") as! AnyView  
    } else {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            // Haptics are not included for non premium users  
        }.navigationTitle("Notifications") as! AnyView  
    }  
}
```

into:

```swift
// computed variable version  
@ViewBuilder  
var soundAndHaptics: some View {  
    if isPremiumUser {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            Toggle("Haptics: ", isOn: $hapticsOn)  
        }.navigationTitle("Notifications")  
    } else {  
        List {  
            Toggle("Sound: ", isOn: $soundOn)  
            // Haptics are not included for non premium users  
        }.navigationTitle("Notifications")  
    }  
}
```

Now our computed variable can use any logic that we need just like the function version. Plus, we don’t even need to pass in a parameter, as long as `isPremiumUser` is in the same struct.

## Method #6: Extract To static func or var

Of course, if a View can be a var or a func, then that also means that it can be a static var or func. Something like this:

```swift
// static var  
@ViewBuilder  
static var exampleTableCell: some View {  
    List {  
        Text("Hello")  
    }  
}  
// static func  
@ViewBuilder  
static func exampleToggle(_ binding: Binding<Bool>) -> some View {  
    List {  
        Toggle("Toggle", isOn: binding)  
    }  
}
```

This method can be really helpful for adding in example View’s when you are still prototyping. Just remember that any static var or func, won’t be able to use any of your instance variables like our `isPremiumUser` variable from earlier.

## Method #7: Extract To A Style

What if I want to create a View that has some customization, but I still want to keep some of the uniformity of the built-in Views? For example, what if I have a Button that has some custom styling. Here’s a simple example:

```swift
struct RedCircleButton: View {  
    let string: String  
    let action: () -> Void  
      
    var body: some View {  
        Button(string, action: action)  
            .clipShape(Circle())  
            .foregroundColor(.red)  
    }  
}
```

Now my button is very reusable. But I’ve sacrificed customizability. What if I want to use a View as my label instead of a String? Thankfully, SwiftUI has a solution to this as well: Styles. Many SwiftUI views come Style types. These let you call a normal built-in type, and place all your custom styling in your “Style” Type. For example:

```swift
struct RedCircleButtonStyle: ButtonStyle {  
      
    public func makeBody(configuration: RedCircleButtonStyle.Configuration) -> some View {  
        RedCircleButton(configuration: configuration)  
    }  
      
    struct RedCircleButton: View {  
        let configuration: RedCircleButtonStyle.Configuration  
  
        var body: some View {  
            configuration.label  
                .foregroundColor(.red)  
                .clipShape(Circle())  
        }  
    }  
}
```

And to use it we just write:

```swift
Button("Some String") { print("Do something")}  
            .buttonStyle(RedCircleButtonStyle())
```

SwiftUI comes with many style protocols including `ButtonStyle`, `ListStyle`, `PickerStyle` , you get the picture.

## The Right Method for the Job

Those are all the methods of splitting SwiftUI code that I’ve found. Have you found anymore that I should add?

With so many options for splitting code. How do we know which to use when? First, don’t overthink it. Thankfully, SwiftUI makes it much easier to split and refactor code than UIKit. We don’t have massive ViewControllers with complex side effects to think about (but it is our responsibility, to separate View and Model logic). Here are my suggestions of when to use each of these methods:

- **Method #1: Extract To Separate Struct**: Use when you want something, custom and reusable.
- **Method #2: Extract To Local Computed Property:** Use when you want something private and internal.
- **Method #3: Extract To A Function:** Also works for something private and internal, but personally I would prefer a computed property for that use case.
- **Method #4: Extract To an @ViewBuilder Function**: Great for when you want to enable another View to pass you a View.
- **Method #5: Extract To an @ViewBuilder Computed Property:** Great for when you need something internal and private, that also has some internal logic, especially if you need to erase Type.
- **Method #6: Extract To static func or var:** Great for when you want mock example Views.
- **Method #7: Extract To A Style**: Great for when you only want to extract custom styling but not custom logic.

I’m sure there are many use cases that are not listed here but I hope it’s a good starting point. Now get out there and start organizing your SwiftUI code!