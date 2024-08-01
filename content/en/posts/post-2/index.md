---
title: How to use a JS for...of loop with an index
date: 2023-09-07
topics: ["JavaScript"]
images: ["image.jpg"]
---
> **Note**:
> I originally posted this blog post to Medium, [here](https://medium.com/@_DandyLyons/how-to-use-a-js-for-of-loop-with-an-index-a4675ed22351).

JavaScript’s `for...of` loop is a powerful construct for iterating over elements in an [iterable](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols#built-in_iterables), such as arrays, strings, or [other iterable objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols#built-in_iterables:~:text=iterables%20and%20iterators.-,Built%2Din%20iterables,-String%2C%20Array). However, unlike the traditional [C-style for loop](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for), **the** `for...of` **loop doesn't provide a built-in index**. But fear not! In this blog post, we'll learn how to use the `for...of` loop with an index.

## The Traditional `for...of` Loop

Before diving into adding an index, let’s quickly review how the standard `for...of` loop works:

```js
const nums = [10, 20, 30, 40, 50];  
  
for (const num of nums) {  
  console.log(num);  
}
```

This loop will iterate through ==`nums`== and print each element to the console. However, if you need to keep track of the index as well, you can modify the loop…

## Adding an Index to the `for...of` Loop

To add an index to the `for...of` loop, you can use the [entries()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/entries) method of an array, which returns an iterable containing index-value pairs. Here's how you can do it:

```js
const nums = [10, 20, 30, 40, 50];

for (const [index, num] of nums.entries()) {
  console.log(`Index: ${index}, Value: ${num}`);
}
```

In this modified loop, we use the `entries()` method to get an iterable of index-value pairs, and then we [destructure](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) each pair into `index` and `num`. Now, you have access to both the index and the value during each iteration.

## Output
```
Index: 0, Value: 10  
Index: 1, Value: 20  
Index: 2, Value: 30  
Index: 3, Value: 40  
Index: 4, Value: 50
```

With this approach, you can easily work with both the elements and their respective indices when using the `for...of` loop.

## Considerations

Be aware that the `entries()` method used above loops through the array once with an efficiency of `O(n)`. So if you have a very large array, you will notice a performance cost. As with everything else, there are tradeoffs. Personally, I think readability and maintainability are worth a negligible performance cost. For example, this style of for loop makes it all but impossible to commit the subtle [Off-by-one error](https://en.wikipedia.org/wiki/Off-by-one_error). The best code is the code you never have to write in the first place, and if you eliminate the need to check for an off-by-one error in the first place, then I think that’s a great tradeoff.

Nevertheless, if you’re dealing with strict performance constraints, weak hardware, or massive datasets, then you should certainly consider using the C-style for loop.

## Conclusion

JavaScript’s `for...of` loop is a versatile way to iterate over iterable objects. By leveraging the `entries()` method, you can easily include an index alongside the values in your loops. This can be especially useful when you need to perform operations that require knowledge of the element's position within the iterable. Happy coding!