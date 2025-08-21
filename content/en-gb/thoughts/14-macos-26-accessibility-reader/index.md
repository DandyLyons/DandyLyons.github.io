---
title: "macOS 26's Hidden Speechify Killer: Accessibility Reader"
date: 2025-07-04
draft: false
tags:
  - thoughts
  - accessibility
  - macOS
  - text-to-speech
  - macOS_26
slug: macos-26-accessibility-reader
aliases:
  - /thoughts/14/
description: Apple quietly shipped a powerful text-to-speech feature in macOS 26 that could replace premium apps like Speechify - but almost nobody knows about it.
topics:
  - accessibility
  - macOS
  - technology
  - Apple
---

Apple's macOS 26 introduces a powerful, yet frustratingly hidden, accessibility feature that could potentially "Sherlock" some of the leading voice reader applications like Readwise Reader, Speechify, and ElevenLabs' _ElevenReader_. This new addition is called **Accessibility Reader**, and it brings high-quality text-to-speech capabilities directly to your Mac at no extra charge.

## What Makes Accessibility Reader So Good?

The Accessibility Reader is a truly fantastic feature for several reasons:

*   **Cost-Free:** It's built right into macOS 26, meaning there's no additional cost to access its powerful features.
*   **On-Device Processing:** This feature appears to run entirely on your device, eliminating the need for an internet connection. This ensures privacy and consistent performance regardless of your network availability.
*   **High-Quality Text-to-Speech:** It boasts a high-quality text-to-speech voice that can read any text on your computer, making it a viable alternative to dedicated reader apps.
*   **Intuitive User Interface (UI):** Beyond just reading, the Accessibility Reader offers a well-designed UI. It highlights the text being read, providing a visual cue that enhances the reading experience.
*   **Comprehensive Playback Controls:** You get full control over the reading experience, including:
    *   Speed adjustments (speed up or slow down)
    *   Fast forward and rewind
    *   The ability to jump to any part of the text
*   **Text Formatting Options:** The reader also allows you to format the text within its interface, ensuring a pleasant and customizable reading experience.

In essence, it's a remarkably full-featured text-to-speech reader that offers a lot of value.

## The Frustrating Path to Discovery

Despite its robust features, the Accessibility Reader is remarkably difficult to find and activate on macOS. So far, the only method that I discovered involves a cumbersome multi-step process:

1.  **Highlight Text:** First, you must highlight the text you wish to have read aloud.
2.  **Right-Click (Context Menu):** Then, you right-click on the highlighted text.
3.  **Locate "Speech" Submenu:** Sometimes (I repeat <u>sometimes</u>) a submenu named "Speech" will appear in the right-click menu. It's not always there, making the feature unreliable to access.
4.  **Click "Start Speaking":** If the "Speech" submenu is present, you then click "Start Speaking." At this point, Apple's voice reader immediately begins to read the selected text aloud, and a floating UI with basic play controls appears.
5.  **Open Accessibility Reader App:** The final and most obscure step involves clicking a button within this floating UI that resembles a sheet of paper. Clicking this button will then open the dedicated Accessibility Reader app.

This long, cumbersome method is currently the only way I've found to open this otherwise excellent feature. Adding to the mystery, the Accessibility Reader app is not found in the Applications folder, reinforcing its hidden nature.

## Key Caveats and Limitations

The biggest hurdle for the Accessibility Reader is its inconsistent availability:

*   **Inconsistent Right-Click Menu Appearance:** The "Speech" submenu in the right-click context menu does not consistently appear, making it impossible to rely on for regular use. There's no clear indication of when it will or won't be available. Under, the hood, Apple is automatically adding this feature for any app using standard macOS text rendering, but the problem is not every app or website is using macOS's standard text rendering. This is a huge bummer for users (especially those who rely on text-to-speech for accessibility reasons) because it means the feature is not universally available across all applications. Users shouldn't have to know or care about the underlying tech used by each app in order to know whether they can use a feature or not.
*   **No Keyboard Shortcut:** Currently, there's no dedicated keyboard shortcut to activate the feature, further hindering quick access.
*   **Custom UI Frameworks:** The feature generally works across macOS apps that use standard UI frameworks. However, it *does not* work with apps that utilize custom UI frameworks, such as Obsidian or Visual Studio Code. In these applications, the "Start Speaking" option simply won't appear.
*   **Web Apps and Google Docs:** Similarly, if you're trying to read text from within Google Docs or certain other web applications, the "Start Speaking" button will often be absent.

## Conclusion

As much as I've spent time criticizing how difficult it is to find and start using this tool, once you do manage to get it running, the Accessibility Reader is a fantastic feature. It offers a level of quality and control that rivals many premium text-to-speech applications yet it has not additional cost and it doesn't require an internet connection. 👍 I wonder if it will be a part of my daily toolkit. 
