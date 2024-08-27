---
date: 2024-08-27
title: Using Optionals with SwiftUI Bindings
slug: using-optionals-with-swiftui-bindings
# images: [""]
description: Bend your view to work with your model's optional values. 
tags: SwiftUI, Optionals
---

[Optionals](https://developer.apple.com/documentation/swift/optional) are an invaluable, core feature of Swift, and [Bindings](https://developer.apple.com/documentation/swiftui/binding) are the same for SwiftUI, but unfortunately it can be difficult to get them to play nicely with each other. Bindings are one of the core ways to empower child views to talk to parent views, and they are used throughout the SwiftUI framework. For example all of these core components use Bindings. 

```swift
TextField("Last name", text: $person.lastName)
DatePicker("Death date", selection: $person.deathDate)
ColorPicker("Favorite color", selection: $person.favoriteColor)
```

But this gets much more complicated if you need a `Binding` for an `Optional` property. SwiftUI rarely, if ever, provides Views that accept an Optional Binding.

```swift 
@Observable class Person {
  var lastName: String?
  var deathDate: Date?
  var favoriteColor: Color? 
}

struct PersonForm: View {
  @Bindable var person: Person
  var body: some View {
    Form {
      TextField("Last name", text: $person.lastName)
	  // 🔴 Cannot convert value of type 'Binding<String?>' to expected argument type 'Binding<String>'
      DatePicker("Death date", selection: $person.deathDate)
	  // 🔴 Cannot convert value of type 'Binding<Date?>' to expected argument type 'Binding<Date>'
      ColorPicker("Favorite color", selection: $person.favoriteColor)
	  // 🔴 Cannot convert value of type 'Binding<Color?>' to expected argument type 'Binding<Color>'
    }
  }
}
```

Today we will look at a few potential solutions and strategies: 
1. Try removing Optionals if they don't match your use case. 
2. Provide a default value for your `Binding`
3. Convert a `Binding<Value?>` to a `Binding<Value>?`
4. Create "Optional" SwiftUI Views
## Removing Optionals
First let's recognize that we are going "against the grain". We are doing something that SwiftUI really wasn't designed for. This doesn't mean that we can't, or we shouldn't do this, but it does mean that it will require extra work. So we should consider if that work is even necessary in the first place. **The best way to solve a problem, is to prevent the problem from existing in the first place.** Do we really need Optionals in our domain? The answer to this question will depend on your specific use case. 

In our example, we could simply change all of the properties to be non-Optional and this will immediately remove all the compiler errors. Problem solved. But what if we really need for these values to be Optional? Remember a `String?` can either be a `String` value or it could be `nil`. But a `String` **must** be a `String` value. It **cannot** ever be `nil`. The compiler won't let it. 

If your data will never have blank values, then this isn't a problem. But if your data could have blank values, then you must decide what to do with those values. Often, the easiest solution is to provide default values. 

```swift
@Observable class Person {
  public init(lastName: String?, deathDate: Date?, favoriteColor: Color?) {
    self.lastName = lastName ?? ""
    self.deathDate = deathDate ?? Date()
    self.favoriteColor = favoriteColor ?? Color.accentColor
  }
  
  var lastName: String
  var deathDate: Date
  var favoriteColor: Color
}
```

Here all of the properties are non-Optional, but the initializer can accept Optional values. The initializer will try use the given Optional value, but if there is no value, then it will replace it with a default value. 

This approach can be particularly helpful when you are consuming data from other systems that do not have Swift's `Optional` type, and therefore can't guarantee if a value will be present. For example, Apple's Core Data turns almost all properties into Swift Optionals. Also, many Web APIs return a JSON, with keys that may or may not be present. 

Remember this principle: **Your View should conform to your model (and not the other way around). And your model should conform to your use case (and not the other way around).** If your model conforms to your view then this will result in code that is error-prone and doesn't make sense. If your model **doesn't** conform to your use case, then your code will solve the wrong problem. 

It's also worth noting that `nil` is not the same as "empty" values. An empty string is not the same as a `nil` string. 
```swift 
let emptyString: String? = ""
let nilString: String? = nil
// nilString != emptyString
```

If you want, you can use both values to represent the same thing, in your model. There's nothing wrong with this approach and many systems have used this strategy for many years. Just be aware that if you use `""` and `nil` to mean the same thing (e.g. both mean that the person doesn't have a last name), then you are creating ambiguity in your code. (Does the person have no last name or is their last name blank? Does the person really have no last name, or did they just forget to fill out that text field?)

For the sake of our example, let's say that our use case warrants `Optional` values. Not every person has a last name, or a death date, or a favorite color. It would not be right to create a model that would force our data to be misaligned with reality. So if our use case calls for an `Optional` then we should use an `Optional` and we should figure out a way to conform our `View` to accept that. Now let's look at some strategies to accomplish that. 
## Provide a default value for your `Binding`
For some use cases it might be better and easier to simply provide a default value to our `Binding`. Unfortunately, SwiftUI doesn't have this built in, but it's quite easy to add it with an extension: 

```swift
extension Binding {
  /// Converts a `Binding<Value?>` to a `Binding<Value>`
  /// 
  /// - Parameter defaultValue: the value to return if the `wrappedValue` is `nil`
  /// - Returns: A `Binding` of a non-optional value
  public func toNonOptional<T>(defaultValue: T) -> Binding<T> where Value == T? {
    Binding<T>(
      get: { self.wrappedValue ?? defaultValue },
      set: { self.wrappedValue = $0 }
    )
  }
}
```

Then to use it we just do this: 
```swift
TextField("Last name", text: $person.lastName.toNonOptional(defaultValue: ""))
DatePicker("Death date", selection: $person.deathDate.toNonOptional(defaultValue: Date()))
ColorPicker("Favorite color", selection: $person.favoriteColor.toNonOptional(defaultValue: .accentColor))
```

This handy extension makes it quite easy to use any optional value as a binding. However, it does not provide any way to represent a `nil` value. 

## Convert a `Binding<Value?>` to a `Binding<Value>?`
This one can be really confusing, but it is extremely important to understanding SwiftUI. `Binding<Value?>` and `Binding<Value>?` are not the same. Do you see the difference?
- `Binding<Value?>`: is a non-Optional `Binding` that is holding onto an `Optional` value. In other words:
	- There **is** a `Binding` and there **might** be a `Value`
- `Binding<Value>?`: is an `Optional` `Binding` that is holding onto a non-Optional value. In other words: 
	- There **might** be a `Binding` that is holding onto a `Value` that **must** exist.

Unfortunately, most SwiftUI views want a `Binding<Value>` and not a `Binding<Value?>`. Thankfully, there's a fairly simple solution to this. SwiftUI provides an initializer for `Binding` that can unwrap a `Value`. In other words, it converts a `Binding<Value?>` to a `Binding<Value>?`

```swift
@Observable class Person {
  var lastName: String?
  var deathDate: Date?
  var favoriteColor: Color?
}

struct PersonForm: View {
  @Bindable var person: Person
  var body: some View {
    Form {
      if let lastNameBinding: Binding<String> = Binding($person.lastName) {
        TextField("Last name", text: lastNameBinding)
      }
      if let deathDateBinding = Binding($person.deathDate) {
        DatePicker("Death date", selection: deathDateBinding)
      }
      if let favoriteColorBinding = Binding($person.favoriteColor) {
        ColorPicker("Favorite color", selection: favoriteColorBinding)
      }
    }
  }
}
```

Now we have safely unwrapped our values, and we have a `Binding?` that can work with our SwiftUI views. We then unwrap our `Binding?` using `if let`. If the `Binding?` has a value, then we display our view, but if it's nil, we simply don't render the view. This approach effectively conforms our View to our model, however it creates new UX problems.

What happens if `lastName` becomes `nil`? Then we lose the `TextField` and we lose any way to edit the value. What if `lastName` has a value but we want to remove that value and turn it into `nil`? Currently our UI doesn't support that. It's not too hard to support all of this, but it does require a lot of boilerplate. 

```swift
struct PersonForm: View {
  @Bindable var person: Person
  var body: some View {
    Form {
      if let lastNameBinding: Binding<String> = Binding($person.lastName) {
        TextField("Last name", text: lastNameBinding)
        Button("Remove last name") { person.lastName = nil }
      } else {
        Button("Add last name") { person.lastName = "" }
      }
      if let deathDateBinding = Binding($person.deathDate) {
        DatePicker("Death date", selection: deathDateBinding)
        Button("Remove death date") { person.deathDate = nil }
      } else {
        Button("Add death date") { person.deathDate = Date() }
      }
      if let favoriteColorBinding = Binding($person.favoriteColor) {
        ColorPicker("Favorite color", selection: favoriteColorBinding)
        Button("Remove favorite color") { person.favoriteColor = nil }
      } else {
        Button("Add favorite color") { person.favoriteColor = Color.accentColor }
      }
    }
  }
}
```

## Create "Optional" SwiftUI Views
To remove boilerplate, we can create reusable Views that actually expect a `Binding<Value?>`. There are many ways to accomplish this. Here is just one: 

```swift 
struct OptionalTextField: View {
  @Binding var optionalString: String?
  let textFieldTitleKey: String
  let removeStringTitleKey: String
  let addStringTitleKey: String
  
  var body: some View {
    if let stringBinding: Binding<String> = Binding($optionalString) {
      TextField(textFieldTitleKey, text: stringBinding)
      Button(removeStringTitleKey) { optionalString = nil }
    } else {
      Button(addStringTitleKey) { optionalString = "" }
    }
  }
}
```

Then we can reuse this view component anywhere that we need a `TextField` for an `Optional<String>`. 

```swift 
OptionalTextField(
  optionalString: $person.lastName,
  textFieldTitleKey: "Last name",
  removeStringTitleKey: "Remove last name",
  addStringTitleKey: "Add last name"
)
```

This approach can be quite great, however, here we lose the ability to use other views as our `TextField` label. These problems are certainly fixable, but to do it in a way that is reusable, yet still flexible requires a highly nuanced approach. 

Here is a far more robust solution: 
[Github Gist: OptionalTextField.swift](https://gist.github.com/DandyLyons/80312b225934b79fc895cd0b924566a3)

## Conclusion
Today we learned various strategies to using SwiftUI Bindings with Optional values. If I can leave you with one takeaway, I hope it is this. Your model does not need to change to fit SwiftUI. Instead, adapt SwiftUI to meet your needs, and you will surely find that it is more than up to the task. 