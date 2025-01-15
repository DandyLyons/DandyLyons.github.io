import SwiftUI

struct MyView: View {
  @State private var showingText = false
  var body: some View {
    if showingText {
      Text("Now you can see the text")
    } 
    Button(if showingText { "Hide" } else { "Show" }) {
      showingText.toggle()
    }
  }
}