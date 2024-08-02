---
date: 2024-08-06
title: Boost Your Productivity with These macOS Typing Shortcuts
---
# Boost Your Productivity with These macOS Typing Shortcuts

Mastering keyboard shortcuts can significantly enhance your productivity on macOS. These shortcuts are versatile and work in nearly any text field across various macOS apps, including browsers. Moreover, many of these shortcuts can be combined, offering even more powerful text navigation and editing capabilities.

>#### [BONUS] Vim Equivalents: 
>Many power users and coders may be familiar with Vim, which is a powerful text editor. All of these features are already available in Vim, or any editor that supports Vim key bindings, but if you are using an app that does not support Vim key bindings, then you do not have access to those features. On the other hand, the keyboard shortcuts, below, are available in almost every app in macOS. Non-Vim users can experience many (definitely not all) of the powerful features that Vim users already enjoy, except across the operating system, and without the obtuse syntax. For learning purposes, I'll include the Vim equivalents in this article. 

## Clarifying Key Names and Symbols

Before diving into the shortcuts, let's clarify the different names and symbols used for macOS keys. This article will use the following terms for consistency:

- **Command (CMD)**: Sometimes represented by ⌘.
- **Option (Opt)**: Also known as Alt, represented by ⌥.
- **Control (Ctrl)**: Represented by ^.
- **Shift**: Represented by ⇧.

## The CMD Key

The CMD key, or Command key, is central to many macOS shortcuts. Here are some essential text navigation commands using the CMD key:

- **CMD + (←)**: Jump to the start of the line (equivalent to the HOME key on Windows).  
- **CMD + (→)**: Jump to the end of the line (equivalent to the END key on Windows).  
- **CMD + (↑)**: Jump to the start of the text field.  
- **CMD + (↓)**: Jump to the end of the text field.  

**Equivalent VIM Commands**:
- **CMD + (←)**: `^` (move to the start of the line).
- **CMD + (→)**: `$` (move to the end of the line).
- **CMD + (↑)**: `gg` (move to the top of the file).
- **CMD + (↓)**: `G` (move to the bottom of the file).

## The Option Key

The Option key provides another layer of text navigation precision. It allows you to move the cursor by "word". What is a "word"? It depends on the editor you're using, but usually the cursor will move up to the next space character. Sometimes it will stop at special characters such as `(` or `{` Here's how you can use it:

- **Opt + (←)**: Jump to the beginning of the current or previous word. If you are in the middle of a word, this shortcut will take you to the start of that word; otherwise, it will jump to the start of the previous word.  
- **Opt + (→)**: Jump to the beginning of the next word.  
- **Opt + (↑)**: This works similarly to CMD + (↑), jumping to the start of the text field.  
- **Opt + (↓)**: This works similarly to CMD + (↓), jumping to the end of the text field.  

**Equivalent VIM Commands**:
- **Opt + (←)**: `b` (move back one word).
- **Opt + (→)**: `w` (move forward one word).
- **Opt + (↑)**: `gg` (move to the top of the file).
- **Opt + (↓)**: `G` (move to the bottom of the file).

## The Shift Key

The Shift key is used to extend your selection while navigating text. Here are some useful combinations:

- **Shift + (←)**: Move the cursor left one character and highlight the text.
- **Shift + (→)**: Move the cursor right one character and highlight the text.
- **Shift + (↑)**: Move the cursor up one line and highlight the text.  
- **Shift + (↓)**: Move the cursor down one line and highlight the text.

In other words, adding Shift to any of these commands tells macOS, "I want to move my cursor AND keep my current highlight."

### Combining Shift with CMD and Option Keys

You can combine the Shift key with CMD or Option shortcuts to highlight larger sections of text quickly.

#### CMD + Shift Combinations

- **CMD + Shift + (←)**: Highlight from the cursor position to the start of the line.  
- **CMD + Shift + (→)**: Highlight from the cursor position to the end of the line.  
- **CMD + Shift + (↑)**: Highlight from the cursor position to the start of the text field.  
- **CMD + Shift + (↓)**: Highlight from the cursor position to the end of the text field.  

**Equivalent VIM Commands**:
- **CMD + Shift + (←)**: `v` + `0` (enter visual mode and move to the start of the line).
- **CMD + Shift + (→)**: `v` + `$` (enter visual mode and move to the end of the line).
- **CMD + Shift + (↑)**: `v` + `gg` (enter visual mode and move to the top of the file).
- **CMD + Shift + (↓)**: `v` + `G` (enter visual mode and move to the bottom of the file).

#### Option + Shift Combinations

- **Option + Shift + (←)**: Highlight the word to the left of the cursor.  
- **Option + Shift + (→)**: Highlight the word to the right of the cursor.  
- **Option + Shift + (↑)**: Highlight to the beginning of the paragraph or block of text (similar to CMD + Shift + (←)).  
- **Option + Shift + (↓)**: Highlight to the end of the paragraph or block of text (similar to CMD + Shift + (→)).  

**Equivalent VIM Commands**:
- **Option + Shift + (←)**: `v` + `b` (enter visual mode and move back one word).
- **Option + Shift + (→)**: `v` + `w` (enter visual mode and move forward one word).
- **Option + Shift + (↑)**: `v` + `gg` (enter visual mode and move to the top of the file).
- **Option + Shift + (↓)**: `v` + `G` (enter visual mode and move to the bottom of the file).

## Multi-Cursor Editing in Xcode

For developers using Xcode, multi-cursor editing can be a game-changer. This feature allows you to create multiple cursors, making simultaneous edits in multiple places possible.

- **Ctrl + Shift + Click**: Create another cursor where you clicked.  
- **Ctrl + Shift + (↑)**: Move your cursor up and create a new cursor there.  
- **Ctrl + Shift + (↓)**: Move your cursor down and create a new cursor there.  
- **CMD + Opt + Enter**: This keyboard shortcut is incredibly powerful! It does so many things at the same time and it is perfect for renaming variables or classes in code. Here's the workflow: 
  -  First, highlight something you would like to rename (i.e. "Find and Replace"). 
  -  Then press **CMD + Opt + Enter**. It will find the next occurance of what you highlighted and highlight that as well. 
  -  You can press **CMD + Opt + Enter** many times and it will find more and more occurances and highlight them as well. 
  - Now that you have all these highlights, you can make any edit you want to all of the highlights at the same time. 
  - For example, to rename, simply start typing. Since multiple spots are highlighted, the highlighted text will be replaced with a cursor at each highlight. 
  - Or if you just want to rename part of it, you can press ← and all of your cursors will move to the beginning of their highlight, and you can start typing there.

## In Practice

Let's explore some practical use cases and how you can combine the techniques from this article with basic commands like copy, paste, and undo.

### Delete an Entire Line (or Multiple Lines)

1. **Select the Line(s)**:
   - If your cursor is in the middle of the line, first move your cursor to the end of the line by pressing **CMD + (→)**. 
   - Then press **CMD + Shift + (←)**. This will move the cursor to the beginning of the line AND highlight at the same time. 
2. **Delete the Line(s)**:
   - Simply press **delete** or press **CMD + X** to cut (delete) the selected line(s).

**Equivalent VIM Command**: `dd` (delete the current line) or `d{n}d` (delete multiple lines).

### Move an Entire Line (or Multiple Lines) Up or Down

1. **Select the Line(s)**:
   - Select the line(s) using the same process, described above.
2. **Cut the Line(s)**:
   - Press **CMD + X**.
3. **Move the Cursor**:
   - Use **CMD + (↑)** or **CMD + (↓)** to move the cursor to the desired location.
   - You may need to create a new line, so you have a blank place to paste your lines. 
4. **Paste the Line(s)**:
   - Press **CMD + V** to paste the cut line(s).

>#### Moving lines in code editors
>Most code editors have a command with a name like "Move line up" which will make this process even easier by moving the line up, without the need to select text. 
>In Xcode, this command is **CMD + Opt + [** by default. 

**Equivalent VIM Commands**: 
- Move the current line up: `ddkP`.
- Move the current line down: `ddp`.
- Move multiple lines: `d{n}d{move to desired line}P`.

### Additional Practical Use Cases

#### Copy and Paste a Word(s)

1. **Select the Word**:
   - Place your cursor at the start of the word.
   - Use **Shift + Opt + (→)** to highlight the word.
2. **Copy the Word**:
   - Press **CMD + C**.
3. **Move the Cursor**:
   - Use **Opt + (→)** to navigate to the desired location.
4. **Paste the Word**:
   - Press **CMD + V**.

**Equivalent VIM Commands**:
- Select the word: `viw`.
- Copy the word: `y`.
- Paste the word: `p`.

### Cross-Platform Consistency

These powerful text navigation and editing shortcuts are not exclusive to macOS; similar concepts are also available on Windows and Linux. On Windows, the CTRL key often substitutes for the CMD key, with shortcuts like CTRL + (←) and CTRL + (→) allowing you to jump between words, and CTRL + Shift combinations enabling extended selections. Linux systems, particularly those running desktop environments like GNOME or KDE, offer comparable functionality, with the CTRL and ALT keys providing similar navigation and selection capabilities. Additionally, many text editors and IDEs across these platforms support Vim key bindings, offering a consistent editing experience for those familiar with Vim commands. This cross-platform availability ensures that users can maintain their productivity regardless of the operating system they are using.

### Conclusion

By integrating these keyboard shortcuts into your workflow, you can navigate and edit text more efficiently, saving time and boosting your productivity on macOS. Whether you are a writer, a developer, or anyone who spends a lot of time typing, mastering these shortcuts will make your macOS experience smoother and more efficient. Try using these methods today, and soon enough it will just become a part of your muscle memory! 