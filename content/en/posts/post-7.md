---
title: How to scroll to a percentage in a ScrollView
date: 2024-08-02
draft: true
topics: ["SwiftUI"]
---


```swift

import SwiftUI
import Foundation
struct ScrollPosition: View {
  @State private var scrollID: Int?
  @State private var picker = 34
  
  var body: some View {
    ScrollView {
      Text(verbatim: .psalm103)
        .background {
          VStack {
            ForEach(0..<100) { num in
              VStack {
                Text("\(num)").frame(maxWidth: .infinity, alignment: .leading)
                  .id(num)
                  .opacity(0.0)
                Spacer()
              }
            }
          }
        }
        .scrollTargetLayout()
      
    }
    .scrollPosition(id: $scrollID, anchor: .top)
    .animation(.default, value: self.scrollID)
    
    .safeAreaInset(edge: .bottom) {
      VStack {
        HStack {
          Picker("Select a number", selection: $picker) {
            ForEach(0..<100) { num in
              Text("\(num)").id(num)
            }
          }
          Button("Scroll to \(picker)%") { self.scrollID = picker }
          Button("Scroll to top") { self.scrollID = 0 }
        }
        LabeledContent("scrollID", value: "\(scrollID)")
      }
//      .background(.green)
//      .background(ignoresSafeAreaEdges: .bottom)
      .background(.thinMaterial, ignoresSafeAreaEdges: .bottom)
    }
  }
}

#Preview {
  ScrollPosition()
}
```