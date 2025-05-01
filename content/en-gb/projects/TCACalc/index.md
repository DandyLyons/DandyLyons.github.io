---
title: TCACalc
projects: ['TCACalc']
date: 2023-10-09
---
[GitHub](https://github.com/DandyLyons/TCACalc)

## Tech Stack 
| Component      | Tech                              |
| -------------- | --------------------------------- |
| Platforms      | iOS                               |
| Architecture   | TCA (The Composable Architecture) |
| Model Paradigm | FSM (Finite State Machine)        |
| UI             | SwiftUI                           |

## Behind the Scenes
Partway through development, I discovered that the common calculator is much more complicated than it seems from the outside. The actual calculation is trivial, but they behave differently depending which "mode" they are currently in. This particular problem is best modeled as a Finite State Machine. While TCA is already a state machine, with no implicit side effects, it's states are not finite. With a small bit of extra infrastructure, I was able to implement a FSM in TCA, thus vastly reducing the complexity of the calculator, now that I no longer needed to account for an exponential growth of behavior branch paths. 