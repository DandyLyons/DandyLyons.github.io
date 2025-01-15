---
draft: true
date: 2025-01-14
---

# How to Import Modules in GDScript
It's common in most programming languages to use modules to organize your code and reuse functionality. This guide will show you how to import modules in GDScript.

## Autoloading a Singleton
In most beginning Godot tutorials you will see this pattern. You create a script that extends `Node` or `Object` and then you autoload it in the project settings. This is a great way to create a global singleton that you can access from anywhere in your project.

First create a new script that extends `Node` or `Object`. For example, you could create a script called `Global.gd` that looks like this:

```GDScript
extends Node
class_name Global

var score = 0
```

Next, go to the project settings by clicking on the `Project` menu and selecting `Project Settings`. Then go to the `Globals` tab at the top. Now add your script. Make sure to check the "Enable" box under "Global Variables". (Note: Godot recently changed this menu layout in Godot 4.3, so your window may look slightly different.)

Now you can access your global singleton from anywhere in your project like this:

```GDScript
# SomeOtherScript.gd
func _ready():
    Global.score += 1
```

### What Is a Singleton?
This pattern is great because it's relatively easy to set up and it can be used from anywhere in your project. However, beginner tutorials rarely explain what a singleton is. A singleton is a design pattern that allows us to create one (and only one) instance of a class. This is useful when you want to have one source of truth that everyone shares. In this case, we are using a singleton to store our game's score. But what if we want to reuse a script without sharing the same instance everywhere? 

## Importing in Other Languages

Most programming languages have some sort of mechanism for importing modules. This way, you can reuse code from other files or libraries. This is nice because we don't need to rewrite the same code over and over again. Here are some examples of how you might import modules in other languages:

| Programming Language | Equivalent Keyword/Mechanism | Description                                                                     |
| -------------------- | ---------------------------- | ------------------------------------------------------------------------------- |
| **Swift**            | `import`                     | Used to include modules or frameworks.                                          |
| **C#**               | `using`                      | Allows access to types in a namespace without needing to specify the full name. |
| **C**                | `#include`                   | Includes the contents of a file or library at compile time.                     |
| **C++**              | `#include`                   | Similar to C, it includes header files or libraries at compile time.            |
| **Rust**             | `use`                        | Brings items into scope from a module or crate.                                 |
| **Go**               | `import`                     | Imports packages for use in the current file.                                   |
| **JavaScript**       | `import`                     | Imports functions, objects, or primitives from other modules.                   |

But GDScript doesn't have an `import` keyword like most other languages. So how do you import modules in GDScript? It's pretty simple. Most of the time you can just use the type even though it is not defined in the same file. For example, if you want to use the `Vector2` class, you can just use it without importing anything:

```GDScript
var position = Vector2(0, 0)
```

### Importing Using `preload`
However, this will only work if the class is defined in the Godot engine. If you want to use a class that you defined in another script, you will need to use the `preload` keyword. This will load the script and make it available in your current script. Here's an example of one way to do this:

First we write the code that we would like to reuse in one file: 
```GDScript
# MyScript.gd
extends Node

func my_function():
    return "Hello, World!"
```

Then we can use this script in another script like this:
```GDScript
# AnotherScript.gd
extends Node

var my_script: MyType = preload("res://MyScript.gd").new()

func _ready():
    print(my_script.my_function())
```

