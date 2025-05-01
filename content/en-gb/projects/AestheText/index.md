---
title: AestheText
projects: ['AestheText']
date: 2024-06-01
---

<a href="https://apps.apple.com/app/kaomoji-fonts-aesthetext/id6502849857">
  <img src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg" alt="Download on the App Store">
</a>

AestheText makes it easy to create _aesthetic_ text by mutating them into fun _fonts_ and _kaomoji_ facial characters. 

#### Fonts
There are dozens of fonts to choose from like 𝕥𝕙𝕚𝕤 or even ꓄ꀍꀤꌚ! These fonts are universal unicode symbols meaning they are compatible with practically any app or website. 
#### Kaomojis
Kaomojis are like emojis except they are made from multiple unicode characters, meaning there are literally infinite possible combinations. For exaple you could have a cute bear: ʕ·͡ᴥ·ʔ or even an angry man throwing a table: (╯°□°）╯︵ ┻━┻

## Tech Stack 
| Component    | Tech                              |
| ------------ | --------------------------------- |
| Platforms    | iOS, iPadOS                       |
| Architecture | TCA (The Composable Architecture) |
| UI           | SwiftUI                           |
| Purchases    | RevenueCat                        |

## Behind the Scenes
### The Composable Architecture
I chose to use TCA for two main reasons: modularity and testability. TCA makes it easy to separate your app into self-contained modules. This means, it's easy to refactor, since I can build a portion of the project without needing to build the entire project. It's also exhaustively testable since everything is a value type, so I can test that the values equal exactly what I intended. 

### In-App Purchases
For this project, I decided to use RevenueCat, so that I can take advantage of their robust In-App Purchase features, including IAP screens which can be updated remotely without the user needing to download a new version of the app. 
