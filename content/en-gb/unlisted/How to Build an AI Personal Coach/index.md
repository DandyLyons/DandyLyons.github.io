---
title: "How to Build an AI Personal Coach"
slug: how-to-build-an-ai-personal-coach
date: 2025-07-23
author: Daniel Lyons
tags:
    - AI
    - Personal Development
    - Automation
topics: []
draft: 
description: 
---

Have you ever wished you had a personal coach by your side, ready to offer insights and motivation based on your latest thoughts and goals? In this post, we'll explore how to build a simple AI personal coach right on your Mac. This isn't about complex coding; it's about leveraging existing tools to create a smart automation that understands your notes and provides helpful reflections.

## Prerequisites

This guide is designed for anyone interested in AI tinkering, even if you don't have a background in programming. While we'll touch on some technical concepts, we'll make them approachable.

Here's what you'll need to get started:

*   **macOS**: This project is built specifically for Apple's macOS operating system.
*   **VS Code (or a `plist` editor like Xcode)**: We'll be working with a type of XML file called a `plist`. VS Code with the "[Property List Editor](https://marketplace.visualstudio.com/items?itemName=ivhernandez.vscode-plist)" extension offers a user-friendly graphical interface for this, but you can also use Apple's Xcode or any other `plist` editor.
*   [Apple Shortcuts](https://support.apple.com/guide/shortcuts/welcome/ios): A built-in macOS application that allows you to create custom workflows and automations.
*   [Ollama](https://ollama.readthedocs.io/en/quickstart/#model-library): A fantastic tool that lets you run large language models (LLMs) locally on your machine.
*   **Markdown Knowledge**: Our personal notes will be written in Markdown, a lightweight markup language for creating formatted text using a plain-text editor. You can use any text editor, including VS Code, or a dedicated Markdown editor like Obsidian, to manage your notes.

## Goal

Our primary goal for this project is to build an automation that will:

*   **Read your latest personal notes**: These notes will be structured as Markdown files in a designated folder hierarchy.
*   **Write a helpful note**: The automation will generate a new note in the persona of a personal coach, offering insights or questions based on the context of your personal notes.

## Components

To achieve our goal, we'll combine a few key components:

*   **Scheduled Job using `launchd`**: We'll set up a daily job that runs every morning at 8 AM. This job will be managed by `launchd`, macOS's system for managing daemons and agents.
*   **Markdown Files for Notes**: Your personal notes will be kept as simple Markdown files. This makes them easy to read, edit, and process.
*   **Large Language Model (LLM)**: The core intelligence of our coach will come from an LLM. The scheduled job will prompt this LLM using your personal notes as context, guiding it to generate a coach-like response.

## Apple Shortcuts

For simplicity and to integrate seamlessly with macOS, our `launchd` job will directly call an Apple Shortcut. This Shortcut will then handle the interaction with the LLM. (But just so you know, `launchd` can run any script or command you want, e.g. a Python script).

Inside the Shortcut, we'll use the "Get Contents of URL" action. This action is incredibly versatile and effectively acts like the `curl` command in your terminal, allowing the Shortcut to send requests to and receive responses from our locally running LLM via Ollama. The response from Ollama will then be piped into a "Send Message" action within Shortcuts, allowing it to automatically send an iMessage to yourself. We will also write a Markdown message for the day with your agenda, incorporating the coach's message.

## Why Use Ollama?

The choice of Ollama is crucial for one main reason: **privacy**.

Ollama allows you to run large language models **directly on your own machine**. This means your personal notes, which will be fed to the LLM as context, never leave your computer. You can include anything in your notes—your deepest thoughts, sensitive information, or private goals—without having to worry about someone else potentially reading them in the cloud. Your data stays yours, providing peace of mind.

### Personal Cloud Compute

If you prefer to avoid the initial setup complexity of Ollama, Apple offers an alternative with its new "Use Model" command. This command provides two options for running models:

*   **Local Model**: You can run a smaller, less powerful model directly on your device. While convenient, these models are generally "dumber" compared to larger counterparts.
*   **Apple's Bigger Model in "Personal Cloud Compute"**: This is an intriguing option. With Personal Cloud Compute, Apple runs a larger model in the cloud. However, Apple has engineered this service with significant technical safeguards to ensure that **no one**, not even Apple itself, can read your prompts or the model's responses. This is a great choice if you can trust Apple's commitment to your privacy, offering a balance between performance and data security.

## Why Use `launchd`?

You might be wondering why we're using `launchd` to schedule our job instead of something simpler.

Unfortunately, Apple Shortcuts on macOS currently lacks an "Automations" tab, which means there's no built-in way to schedule recurring jobs directly within Shortcuts. Many familiar with command-line tools might think of `cron`, but `launchd` offers a more modern and deeply integrated solution for macOS. It's generally considered easier to use than `cron` for many common scheduling tasks and offers better resource management.

## What is a `plist`?

`launchd` defines its automation tasks using a specific XML format called a `plist` (property list). While a `plist` is essentially a text file, directly editing XML can be tedious and prone to errors.

For our example, we'll leverage the "Property List Editor" extension in VS Code. This extension intelligently reads the XML structure of the `plist` file and presents it as an easy-to-read and easy-to-use graphical user interface (GUI). This makes configuring our scheduled job much simpler and less intimidating.

## Structure of Personal Notes

One of the great values of Large Language Models (LLMs) is their ability to understand natural language. You no longer need to follow a strict, rigid format to communicate with computers. You can "speak" to them in everyday language, and if your input is a little unclear, the LLM can often make an educated guess about what you're trying to convey.

However, just like with a real human, if your input is really disorganized and unclear, the LLM will struggle to satisfy your request effectively. The clearer and more structured your prompt is, the more likely the LLM is to provide a helpful and accurate response. For this reason, we highly recommend giving your personal notes some intentional structure.

Here's a suggested folder hierarchy for your personal notes:

```
Personal Notes/
├── Time-Based/
│   ├── 2025/
│   │   ├── 07_July/
│   │   │   ├── Week_29/
│   │   │   │   ├── 2025-07-20_Sunday.md
│   │   │   │   └── ...
│   │   │   └── ...
│   │   └── ...
│   └── ...
├── Goals/
│   ├── Annual_Goals/
│   │   ├── 2025_Goals.md
│   │   └── ...
│   ├── Quarterly_Goals/
│   │   ├── Q3_2025_Goals.md
│   │   └── ...
│   └── Long-Term_Goals.md
├── Roles_and_Projects/
│   ├── [Your Role 1 Name]/
│   │   ├── Project_A/
│   │   │   ├── Task_1.md
│   │   │   ├── Task_2.md
│   │   │   └── ...
│   │   ├── Project_B/
│   │   │   └── ...
│   │   └── ...
│   ├── [Your Role 2 Name]/
│   │   ├── Project_X/
│   │   │   └── ...
│   │   └── ...
│   └── ...
├── Contacts/
│   ├── John_Doe.md
│   ├── Jane_Smith.md
│   └── ...
└── Insights/
    ├── Idea_1.md
    ├── Learning_Summary.md
    └── ...
```

## Building the Personal Coach Automation: Step-by-Step

Now that we understand the components and recommended note structure, let's dive into building your AI Personal Coach.

### Step 1: Install and Set Up Ollama

First, we need to get Ollama running on your Mac and download a language model.

1.  **Download Ollama**: Visit the official Ollama website ([https://ollama.com/](https://ollama.com/)) and download the macOS application.
2.  **Install Ollama**: Drag the downloaded `.app` file to your Applications folder.
3.  **Run Ollama**: Open Ollama from your Applications folder. It will typically run in the background. You'll see a small Ollama icon in your menu bar.
4.  **Download a Model**: Open your Terminal application (you can find it in `Applications/Utilities/Terminal.app`). We'll download a popular and relatively small model called Llama 2. Type the following command and press Enter:

    ```bash
    ollama run llama2
    ```

    Ollama will automatically download the Llama 2 model. This might take some time depending on your internet connection. Once downloaded, you'll see a prompt where you can chat with Llama 2 directly in your terminal. You can type ` /bye` and press Enter to exit the chat.

### Step 2: Organize Your Personal Notes

Now, let's set up the foundation for your AI coach's insights: your personal notes.

1.  **Create the `Personal Notes` Folder**: In your preferred location (e.g., your Documents folder), create a new folder named `Personal Notes`. This will be the root of your note-taking system.
2.  **Implement the Suggested Hierarchy**: Inside the `Personal Notes` folder, create the subfolders as outlined in the "Structure of Personal Notes" section (e.g., `Time-Based`, `Goals`, `Roles_and_Projects`, `Contacts`, `Insights`).
3.  **Start Populating Your Notes**: Begin writing your notes in Markdown files within this structure. For example, create a file for today's date in `Personal Notes/Time-Based/2025/07_July/Week_29/2025-07-23_Wednesday.md`. Add some thoughts, reflections, or tasks for the day. The more detailed your notes, the better context your AI coach will have.

### Step 3: Create the Apple Shortcut

This is where we'll build the logic that reads your notes, interacts with Ollama, and delivers the coaching message.

1.  **Open the Shortcuts App**: You can find it in your Applications folder.
2.  **Create a New Shortcut**: Click the `+` icon in the toolbar or go to `File > New Shortcut`. Name your shortcut something descriptive, like "Daily AI Coach".
3.  **Get Today's Notes**:
    *   Add an action: Search for "Get Current Date".
    *   Add an action: Search for "Format Date". Set the format to `YYYY-MM-DD`. This will give us `2025-07-23`.
    *   Add an action: Search for "Format Date" again. Set the format to "Full Day of Week" (e.g., "Wednesday").
    *   Add an action: Search for "Combine Text". Combine the two formatted dates with an underscore in between (e.g., `2025-07-23_Wednesday`). This will be our daily note filename.
    *   Add an action: Search for "Get Contents of Folder". Select your `Personal Notes/Time-Based/[Current Year]/[Current Month]/[Current Week]/` folder. *(Note: You'll need to manually update the year, month, and week paths in the Shortcut's folder selection, or use more advanced Shortcuts logic to dynamically determine the path based on the current date, which is beyond the scope of this beginner guide but worth exploring later).*
    *   Add an action: Search for "Filter Files". Set it to `Where Name Is [Combined Date Variable].md`. This will ensure you only get today's specific note.
    *   Add an action: Search for "Get Contents of File". This will read the content of your daily note.
    *   Add an action: Search for "Combine Text". Combine the output of "Get Contents of File". If you have multiple daily notes (e.g., one for morning thoughts, one for evening summary), this step will merge them.

4.  **Craft the LLM Prompt**:
    *   Add an action: Search for "Text". In this text block, write your prompt for the AI coach. Here's a suggested prompt; feel free to modify it to your liking:

    ```
    You are a supportive and insightful personal coach. Your role is to review the following notes from your coachee, provide encouraging insights, ask reflective questions, and suggest actionable steps for the day. Be concise, empathetic, and always end with a positive affirmation.

    Coachee's Notes:
    [Insert Combined Text Variable from previous step here]
    ```
    *   Drag the "Combined Text" variable (from step 3) into the prompt text block where indicated.

5.  **Call Ollama**:
    *   Add an action: Search for "Get Contents of URL".
    *   Set **URL**: `http://localhost:11434/api/generate`
    *   Set **Method**: `POST`
    *   Click on **Headers** to add:
        *   `Content-Type`: `application/json`
    *   Click on **Request Body** and select `JSON`.
    *   Add the following key-value pairs. For the `prompt` value, drag in your "Text" variable containing the crafted prompt.

    ```json
    {
      "model": "llama2",
      "prompt": "[Your Prompt Text Variable]",
      "stream": false
    }
    ```
    *   Make sure `stream` is `false` so you get the full response at once.

6.  **Process Ollama's Response**:
    *   Add an action: Search for "Get Dictionary from Input". This will parse the JSON response from Ollama.
    *   Add an action: Search for "Get Value for Key". Select "Dictionary" as the input, and type `response` as the key. The LLM's generated coaching message will be under this key.

7.  **Send iMessage to Yourself**:
    *   Add an action: Search for "Send Message".
    *   For **Recipients**, select your contact card or type in your Apple ID email/phone number to send the message to yourself.
    *   For **Message**, drag in the variable containing the "response" from the previous step.

8.  **Write Daily Agenda Note**:
    *   Add an action: Search for "Text". Create a new text block that will form your daily agenda. You can include today's date, some static text, and the AI coach's message. For example:

    ```
    # Daily Agenda - [Current Date (Long Format Variable)]

    ## Coach's Message:
    [AI Coach Response Variable]

    ## My Plan for Today:
    - [ ]
    - [ ]
    ```
    *   Drag in the "Current Date (Long Format)" variable (from earlier in step 3) and the "AI Coach Response" variable (from step 6) into this text block.
    *   Add an action: Search for "Create Note" or "Append to Note". If you want a new note each day, use "Create Note". If you have a running daily agenda note you want to update, use "Append to Note" and specify that note. For "Create Note", set the title to `Daily Agenda - [Current Date (YYYY-MM-DD Variable)]` and the body to your newly created agenda text.

9.  **Test Your Shortcut**: Run the Shortcut once from the Shortcuts app to ensure it works as expected. Check your iMessages and your notes app!

### Step 4: Create the `launchd` `plist` File

Now, let's schedule this Shortcut to run automatically every morning.

1.  **Open VS Code**: Navigate to your `~/Library/LaunchAgents/` folder. This folder might be hidden. You can access it by opening Finder, pressing `Cmd + Shift + G`, and typing `~/Library/LaunchAgents/`.
2.  **Create a New `plist` File**: In this `LaunchAgents` folder, create a new file named `com.yourusername.dailycoach.plist` (replace `yourusername` with your actual macOS username or any unique identifier).
3.  **Edit the `plist` Content**: Copy and paste the following XML into your new `plist` file. Remember to replace `"Daily AI Coach"` with the exact name of your Apple Shortcut.

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>com.yourusername.dailycoach</string>
        <key>ProgramArguments</key>
        <array>
            <string>/usr/bin/shortcuts</string>
            <string>run</string>
            <string>Daily AI Coach</string>
        </array>
        <key>StartCalendarInterval</key>
        <dict>
            <key>Hour</key>
            <integer>8</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
        <key>StandardOutput</key>
        <string>/tmp/com.yourusername.dailycoach.log</string>
        <key>StandardError</key>
        <string>/tmp/com.yourusername.dailycoach.error</string>
    </dict>
    </plist>
    ```

    **Explanation of Keys:**
    *   **Label**: A unique identifier for your job.
    *   **ProgramArguments**: Specifies the command to run. Here, it's calling the `shortcuts` command-line tool to `run` your "Daily AI Coach" Shortcut.
    *   **StartCalendarInterval**: Defines the schedule. `Hour` 8 and `Minute` 0 means it will run every day at 8:00 AM.
    *   **StandardOutput** and **StandardError**: These are optional but highly recommended for debugging. They direct any output or errors from your script to log files in the `/tmp/` directory.

    If you're using the "Property List Editor" extension in VS Code, it will present this XML in a much more readable GUI, where you can easily fill in the values.

### Step 5: Load the `launchd` Job

Once your `plist` file is saved, you need to tell `launchd` to load it.

1.  **Open Terminal**: (If you closed it, open it again from `Applications/Utilities/Terminal.app`).
2.  **Load the `plist`**: Type the following command and press Enter (replace `yourusername` with your actual macOS username):

    ```bash
    launchctl load ~/Library/LaunchAgents/com.yourusername.dailycoach.plist
    ```
    If there are no errors, the command will complete silently.

3.  **Test the Job (Optional)**: To run the job immediately without waiting for 8 AM, you can use:

    ```bash
    launchctl start com.yourusername.dailycoach
    ```
    Check your iMessages and notes to see if the coach message appeared.

4.  **Unload (if needed for changes)**: If you need to make changes to your `plist` file, you must first unload it, make the changes, and then load it again:

    ```bash
    launchctl unload ~/Library/LaunchAgents/com.yourusername.dailycoach.plist
    # Make your changes to the .plist file
    launchctl load ~/Library/LaunchAgents/com.yourusername.dailycoach.plist
    ```

### Step 6: Testing and Refinement

Your AI Personal Coach automation is now set up!

*   **Daily Check**: Each morning at 8:00 AM, your Shortcut should run, process your notes, get a coaching message from Ollama, and send it to you via iMessage, also generating your daily agenda note.
*   **Refining Your Prompt**: The quality of your coach's messages heavily depends on the prompt you give the LLM in the Apple Shortcut. Experiment with different phrasing. You might want to ask it to focus on specific aspects (e.g., "focus on my goals for the week," "provide a motivational quote," "help me prioritize my tasks").
*   **Checking Logs**: If something isn't working, check the log files created by your `launchd` job in `/tmp/` (e.g., `com.yourusername.dailycoach.log` and `com.yourusername.dailycoach.error`). These files can provide clues about what went wrong.

---

You've now built your very own AI personal coach, right on your Mac! This project demonstrates the power of combining simple, accessible tools to create a personalized, privacy-focused automation that supports your daily reflections and growth. Enjoy your new digital coach!

