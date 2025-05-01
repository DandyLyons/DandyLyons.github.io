---
title: What's the difference between class and class_name in Godot?
slug: godot-class-vs-class_name
date: 2025-02-11
tags: ["Godot", "GDScript"]
description: Discover how inner classes and class names work in Godot's GDScript.
series: ["GDScript Fundamentals"]
---

When you're writing scripts in Godot, you might have noticed that some scripts use `class` and others use `class_name`. What's the difference between these two keywords? Let's find out.

## `class_name` keyword
You may have noticed that so many GDScript scripts in Godot start with `extends Node` or `extends Resource`. This is because Godot uses a common programming feature called class inheritance. 

```gdscript
extends Node
var str = "Hello, World!"
```

So when you use `extends`, you are telling GDScript that your class inherits from an existing class. So when we write `extends Node`, we are creating a new class that inherits from the `Node` class. 

But where is the new class that we are creating? The answer is, that the whole script (file) is the new class. In fact, **every script in GDScript is defining a new class**. 

So how does Godot know what the name of the new class is? Well, if we are only using this class in this file, then we don't really need to know what the name of the class is.[^1] But if we want to use this class in another script, then we need to give it a name. This is where the `class_name` keyword comes in. The `class_name` keyword is used to name the class that we are creating. This name is used when we want to create an instance of the class in another script.

[^1]: The Godot game engine almost certainly has a way to refer to the class name internally, but as a user, you don't need to worry about it. To us, that's just an implementation detail.

Here's an example of how you might use `class_name`:

```GDScript
# MyNode.gd
extends Node
class_name MyNode
```

Now you can create an instance of `MyNode` in another script like this:

```GDScript
# SomeOtherScript.gd
var my_node = MyNode.new()
```

So in summary, `class_name` in GDScript, behaves much like `class` in other programming languages, like Swift or JavaScript. It is used to name the class that you are creating.

## `class` keyword
If you are used to classes in other programming languages, then the `class` keyword might look familiar to you. But pay careful attention. In GDScript, it does not do the same thing as it does in so many other languages. In GDScript, the `class` keyword is **not** used to define a new class. It is used to define a new **inner class**. 

### What is an inner class?
An [inner class](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#inner-classes) is a class that is defined inside another class. This is useful when you want to group related classes together. Here's an example of how you might use `class` to define an inner class:

```GDScript
# Vehicle.gd
class_name Vehicle
extends Node
var tires: Array[Tire]

class Tire:
	var size: int
	var brand: String

```

In this example, we have a class called `Vehicle` that contains an inner class called `Tire`. This is a common pattern in Godot when you want to group related classes together. Now let's create another file named `Car.gd` that uses the `Tire` inner class:

```GDScript
# Car.gd
class_name Car

# 🔴 Could not find type `Tire` in this context. 
func makeANewTire() -> Tire:
	return Tire.new()
```

Uh oh! The `Tire` type cannot be found! Why is this? It's because `Tire` is an inner class of `Vehicle`. We need to refer to it as `Vehicle.Tire`:

```GDScript
# Car.gd
class_name Car

func makeANewTire() -> Vehicle.Tire:
	return Vehicle.Tire.new()
```

Now it works! As you can see, `Tire` is not a "regular" class. It is an inner class of `Vehicle`. So we need to refer to it as `Vehicle.Tire`. In other words, the `Tire` inner class is [namespaced](https://en.wikipedia.org/wiki/Namespace) under the `Vehicle` class. 

Now try this. Remove `Vehicle.` and add `extends Vehicle` so that your script looks like this:

```GDScript
# Car.gd
class_name Car
extends Vehicle

func makeANewTire() -> Tire:
	return Tire.new()
```

Now it works again! This is because `Car` is now a subclass of `Vehicle`. In other words the `Car` class inherits from the `Vehicle` class. And since it inherits from `Vehicle`, it also inherits the `Tire` inner class. So this also works: 

```GDScript
class_name Car
extends Vehicle

func makeANewTire() -> Car.Tire:
	return Car.Tire.new()
```

## When Should I Use `class` versus `class_name`?
>⭐ If you are creating a new class that you want to use in another script, you should use `class_name`. 

But don't forget, you might not need to use `class_name` at all. If you are creating a new class that is only used in the current script, you can skip the `class_name` keyword, since you won't be using it in another script. By default, Godot will create new script files with no class name. However, I usually like to add a class name. Thinking of a name for my class forces me to clarify what the purpose of the class is. It's a good habit to get into.

So when should you use `class_name`? 

>⭐ If you are creating a new class that is really only relevant within the current class, then you might consider making it an inner class with the `class` keyword. 

This is why I declared the `Tire` class as an inner class in the `Vehicle` class. This way it is clear that `Vehicle.Tire` is a class that is related to the `Vehicle` class. 

If you're a beginner and inner classes are confusing to you, don't worry. You don't need to use `class` at all. Later on, when you're more comfortable with GDScript, if you find yourself drowning in disorganized classes, then you might consider using inner classes to group related classes together.

## Conclusion 
In this guide, we learned the difference between `class` and `class_name` in Godot. We learned that `class_name` is used to name a class that we want to use in another script, while `class` is used to define an inner class. 

## Recommeded Reading
- [Godot docs on Inner Classes](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#inner-classes)
- [Introduction to Object-Oriented Programming](https://www.geeksforgeeks.org/introduction-of-object-oriented-programming/)