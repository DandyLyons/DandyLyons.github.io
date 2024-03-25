---
publish: false
tags:
  - Swift/AttributedString
---
## naive approaches
```swift
for char in myAttrString { // 🔴 For-in loop requires 'AttributedString' to conform to 'Sequence'
						  
}
```

## concept of "Views" in AttributedString
- Character View
- Run View
	- I believe a "run" refers to the span of characters with a particular styling (a particular AttributeContainer? )


## Comparing two AttributedStrings
```swift
var result: AttributedString
for (i, char) in zip(result.characters.indices, result.characters) {
      
}
```