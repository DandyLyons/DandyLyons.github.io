---
draft: true
---

# What's the difference between class and class_name in Godot?

When you're writing scripts in Godot, you might have noticed that some scripts use `class` and others use `class_name`. What's the difference between these two keywords? Let's find out.

## `class_name` keyword
You may have noticed that so many GDScript scripts in Godot start with `extends Node` or `extends Resource`. This is because Godot uses a common programming feature called class inheritance. When you use `extends`, you are creating a new class that inherits from an existing class. So when we write `extends Node`, we are creating a new class that inherits from the `Node` class. But where is the new class that we are creating? The answer is, that the whole script (file) is the new class. You can think of each script as a blueprint for a new class.

So how does Godot know what the name of the new class is? Well, if we are only using this class in this file, then we don't really need to know what the name of the class is.[^1] But if we want to use this class in another script, we need to give it a name. This is where the `class_name` keyword comes in. The `class_name` keyword is used to name the class that we are creating. This name is used when we want to create an instance of the class in another script.

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

## `class` keyword
If you are used to classes in other programming languages, such as JavaScript, Swift then the `class` keyword might look familiar to you. But pay careful attention. In GDScript it does not do the same thing as it does in so many other languages. In GDScript, the `class` keyword is not used to define a new class. It is used to define a new **inner class**. 

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
class_name Car extends Vehicle

func makeANewTire() -> Vehicle.Tire:
	return Vehicle.Tire.new()
```

In this example, we are creating a new instance of the `Tire` inner class from the `Vehicle` class. Notice how we use the `Vehicle.Tire` syntax to refer to the inner class. We can't simply call it `Tire` because it's an inner class and not a top-level class. It is a class inside another class, `Vehicle`.

## When Should I Use `class` versus `class_name`?
If you are creating a new class that you want to use in another script, you should use `class_name`. But don't forget, you might not need to use `class_name` at all. If you are creating a new class that is only used in the current script, you can skip the `class_name` keyword, since you won't be using it in another script. By default, Godot will create new script files with no class name. However, I usually like to add a class name. Thinking of a name for my class forces me to clarify what the purpose of the class is. It's a good habit to get into.

So when should you use `class_name`? If you are creating a new class that is really only relevant within the current class, then you might consider making it an inner class. This is why I declared the `Tire` class as an inner class in the `Vehicle` class. It's a way to group related classes together. This way it is clear that `Vehicle.Tire` is a class that is related to the `Vehicle` class. If you're a beginner and inner classes are confusing to you, don't worry. You don't need to use `class` at all. Later on, when you're more comfortable with GDScript, if you find yourself drowning in disorganized classes, you might consider using inner classes to group related classes together.

## Conclusion 
In this guide, we learned the difference between `class` and `class_name` in Godot. We learned that `class_name` is used to name a class that we want to use in another script, while `class` is used to define an inner class. 

## Recommeded Reading
- [Godot docs on Inner Classes](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#inner-classes)
- [Introduction to Object-Oriented Programming](https://www.geeksforgeeks.org/introduction-of-object-oriented-programming/)