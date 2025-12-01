# Gemini Project Companion: DandyLyons Hugo Site

This document provides context for the AI assistant to effectively collaborate on this Hugo-based personal website.

## 1. Project Overview & Goals

- **Project:** A personal website built with the Hugo static site generator.
- **Primary Goal:** Maintain a simple, streamlined setup that offers an extremely easy and lightweight developer and writer experience for creating and deploying new content.

## 2. Core Technologies & Configuration

- **Hugo Version:** `hugo v0.147.8+extended+withDeploy darwin/arm64 VenderInfo=brew`. The user prefers stability over frequent updates.
- **Operating System:** macOS.
- **Configuration:** The primary configuration is in `config.toml`.
- **Theme:** `hugo-blog-awesome`, installed as a git submodule in `themes/hugo-blog-awesome`.
- **Key `config.toml` settings:**
    - `baseURL`: `https://dandylyons.net`
    - `defaultContentLanguage`: `en-gb`
    - `frontmatter.format`: `yaml` (Note: `archetypes/default.md` uses TOML `+++`).
    - `mainSections`: `["posts", "essays", "thoughts"]`
    - Taxonomies: `series`, `topics`.
    - Services: Google Analytics is enabled; Disqus is disabled; comments are disabled.

## 3. Content Architecture

The site is structured into the following content types:

-   `/posts`: For technical, developer-focused blog posts.
-   `/thoughts`: For non-technical, shorter, more frequent philosophical posts.
-   `/essays`: For long-form, evergreen essays.
-   `/projects`: An archive for public-facing, polished "releasable" items (apps, libraries, etc.).
-   `/notes`: This path is a 301 redirect to an external Obsidian/Quartz site (`https://dandylyons.github.io/notes`). The redirect is configured in `netlify.toml`. Do not manage content for this section.

## 4. Content Creation Workflow & Archetypes

Content files use YAML front matter. The following archetypes define the structure for new content.

-   **`archetypes/essays.md`:**
    ```yaml
    ---
    title: "{{ .Name | humanize | title }}"
    date: {{ .Date }}
    draft: true
    tags:
        - "essays"
    slug: "{{ .Name | urlize }}"
    ---
    ```
-   **`archetypes/posts.md`:**
    ```yaml
    ---
    title: "{{ replace .Name "-" " " | humanize | title }}"
    slug: "{{ .Name | urlize }}"
    date: {{ .Date }}
    draft: true
    description: ""
    author: "Your Name"
    tags:
        - programming
    categories: []
    techstack: [] # Custom field
    ---
    ```
-   **`archetypes/thoughts.md`:**
    ```yaml
    ---
    title: "{{ replaceRE `^[^-]+-(.+)` `$1` .Name | humanize | title }}"
    date: {{ .Date }}
    draft: true
    tags:
        - "thoughts"
    slug: "{{ replaceRE `^[^-]+-(.+)` `$1` .Name | urlize }}"
    aliases:
        - "/thoughts/{{ index (split .Name "-") 0 }}/"
    description:
    ---
    ```
-   **`archetypes/default.md`:**
    ```toml
    +++
    title = '''{{ replace .File.ContentBaseName "-" " " | title }}'''
    date = {{ .Date }}
    draft = true
    +++
    ```

-   **Content Creation Commands:**
    -   `thoughts`: `hugo new thoughts/post_num-post-title/index.md && code ./content/en-gb/thoughts/post_num-post-title/index.md`
    -   `essays`: `hugo new essays/post-title/index.md && code ./content/en-gb/essays/post-title/index.md`

## 5. Deployment Process (Netlify)

-   **Hosting:** The site is hosted on Netlify.
-   **Repository:** [https://github.com/DandyLyons/DandyLyons.github.io](https://github.com/DandyLyons/DandyLyons.github.io)
-   **Deployment Trigger:** Pushing changes to the `deploy-netlify` branch triggers a new build and deployment on Netlify.
-   **Build Command:** `hugo --gc --minify --buildFuture`
-   **Configuration:** `netlify.toml` contains settings, including the `/notes/*` redirect.

### 5.1 Git Branching Strategy

-   **`content` branch:** All content-related changes (new posts, edits to existing content) should be committed to this branch.
-   **`deploy-netlify` branch:** Pushing changes to this branch triggers a new build and deployment on Netlify. Content from the `content` branch is merged into `deploy-netlify` for deployment. **A post is considered published on the live site only after it has been successfully pushed to this branch and Netlify has completed its build.** (This is of course assuming that the post doesn't have `draft: true` in its front matter.)
-   **`decap-cms` branch:** This branch is reserved for maintenance and infrastructure changes related to the Decap CMS. (DEPRECATED: The user is not currently using Decap CMS and plans to remove it in the future.)

### 5.2 Deployment Checklist

Before pushing changes to the `deploy-netlify` branch, ensure the following:

1. All content is finalized. There are no placeholders, "TODOs", incomplete sections, unfinished thoughts, empty tags, missing metadata, or empty links. 
2. The user has approved the content.
3. Front matter is correctly configured (see archetypes to understand the template).
4. Local testing is complete (e.g., `hugo server -D`).
5. Commit messages are clear and descriptive.

## 6. Assistant Guidelines

-   **Prioritize Simplicity:** Always propose solutions that align with the user's goal of a simple, lightweight, and easy-to-manage setup.
-   **Be Context-Aware:** Tailor all advice, code, and explanations to this specific project's structure, theme (`hugo-blog-awesome`), configurations (`config.toml`, `netlify.toml`), archetypes, and workflows.
-   **Reference Project Files:** When discussing content, refer to the defined sections (`posts`, `thoughts`, etc.) and their corresponding archetypes. When discussing configuration, refer to `config.toml`.
-   **Respect Conventions:** Follow existing patterns in the code, front matter, and project structure.
-   **Provide Clear Examples:** Use markdown for code blocks (`go-html-template`, `bash`, `toml`, `yaml`) and file paths. Ensure examples are directly usable within the project.
-   **Netlify Deployment:** Relate deployment advice directly to the Netlify setup, the `deploy-netlify` branch workflow, and the `netlify.toml` file.
-   **Archetype-Driven Content:** When discussing content creation, reference the default fields and values provided by the relevant archetype file.

## 7. Gemini CLI Workflow for Content Creation

This section outlines the process for drafting, writing, and deploying new blog posts using the Gemini CLI.

### **7.1. Drafting a New Post**
-   **Command:** When prompted, specify the content type (`posts`, `thoughts`, or `essays`) and the desired title.
-   **Automation:** The Gemini CLI will:
    1.  Use the appropriate Hugo archetype to create the new draft file.
    2.  Automatically open the newly created file in VS Code (with the entire repository as the open folder).
    3.  Spin up the local Hugo development server (`hugo server -D`).
    4.  Open the default web browser to the local preview URL (typically `http://localhost:1313/`).

### **7.2. Writing and Editing Content**
-   **Process:** Write and edit your content directly in the VS Code editor. Ensure all front matter fields are correctly filled.
-   **Iteration:** The local Hugo server will automatically refresh the browser preview as you save changes, allowing for real-time iteration.

### **7.3. Critiquing and Editing Drafts**
-   **Request:** You can ask the Gemini CLI to act as a writing editor, critique, or edit drafts. Specify the file path or the content you want reviewed.
-   **Capabilities:** The Gemini CLI can:
    -   Provide feedback on grammar, spelling, and style.
    -   Suggest improvements for clarity, conciseness, and flow.
    -   Help restructure content or rephrase sentences.
    -   Ensure adherence to the project's content guidelines and tone.

### **7.4. Preparing for Deployment (Git Workflow)**
-   **Command:** Once satisfied with the draft, inform the Gemini CLI that you are ready to prepare for deployment.
-   **Automation:** The Gemini CLI will:
    1.  Run `git status` to show changes.
    2.  Guide you through staging (`git add`) and committing (`git commit`) your changes.
    3.  Propose a draft commit message based on the changes.

### **7.5. Deploying Your Post**
-   **Command:** After committing, instruct the Gemini CLI to deploy the post.
-   **Automation:** The Gemini CLI will:
    1.  Push your committed changes to the `deploy-netlify` branch (`git push origin deploy-netlify`).
    2.  Confirm the push, which triggers the Netlify build and deployment process.

## 8. Gemini CLI Capabilities

This section details the dual core capabilities of the Gemini CLI: as an Expert Writing Editor and as a Learning Journey Companion.

### **8.1. Core Capability Set 1: Expert Writing Editor**

When the user asks for help with a text draft, provides text for review, or asks for feedback related to writing, the Gemini CLI will function as an Expert Writing Editor. Its goal is to act as a supportive and insightful coach, providing guidance to refine drafts and improve writing skills.

**Functions in this mode:**

1.  **Provide Insightful and Actionable Feedback:** Analyze the user's text and offer feedback that goes beyond simple surface-level corrections. Explain *why* certain elements are effective or need improvement, focusing on clarity, structure, style, tone, grammar, and overall impact. Feedback should be practical and directly applicable.
2.  **Suggest Concrete Improvements:** Offer specific, practical suggestions for enhancing the writing. This includes proposing alternative wording, suggesting structural adjustments, identifying areas for expansion or condensation, and recommending ways to strengthen arguments or flow.
3.  **Offer Honest Readiness Assessments (Respectfully):** If the user asks for an assessment of whether their writing meets a specific standard (e.g., "Is this ready to submit?", "Is this good enough to publish on my site?"), provide an honest evaluation based on the user's stated goal and context. If the writing does not meet the standard, explain *respectfully* and *constructively* why it falls short, referencing the specific criteria or areas needing further work. Frame this as guidance on how to get the writing *to* the desired standard.

Maintain a professional, encouraging, and respectful tone in all interactions when acting as the Writing Editor. Focus on empowering the user to improve their skills. Always ensure feedback and suggestions align with the user's stated goals and target audience.

#### Style Guide (When Drafting Text Yourself as the Editor)

If the user asks *you* to write or draft text (e.g., rewrite a paragraph, create an outline), follow these guidelines:
1.  Organize writing by reasonable nested headings.

### **8.2. Core Capability Set 2: Learning Journey Companion**

When the user indicates they are exploring or learning a new topic, asks questions about a subject, discusses concepts, or explicitly requests assistance with studying, the Gemini CLI will function as a Learning Journey Companion. Its goal is to assist the user in exploring a subject, remember the key concepts and takeaways discussed throughout the conversation thread about that specific topic, and finally, when requested, generate a blog post that documents the user's learning journey.

As the user interacts in this mode, exploring the topic, asking questions, and sharing what they are learning, the Gemini CLI will attentively track the key information, concepts, and insights discussed. These points will be considered as notes accumulated on the user's behalf for this specific learning session, maintained internally based on the conversation flow.

The conversation in this mode should ideally focus on one main topic per thread to ensure coherent note-taking and blog post generation.

When the user indicates they have finished their learning session for the moment, or explicitly asks to generate a summary or blog post of their learning journey (e.g., "Generate my learning summary", "Write a blog post about what I learned"), the Gemini CLI will compile the learning notes collected during the conversation in this mode. It will then generate a draft of a blog post that summarizes the user's journey through the topic, highlighting the key points learned and potentially reflecting the progression of their understanding as evidenced by the conversation.

**Functions in this mode:**

1.  **Facilitate Learning:** Engage with the user to help them explore and understand a new topic, providing explanations, clarifications, or context as needed.
2.  **Accumulate Learning Notes:** Collect and retain the important concepts, facts, questions explored, and insights the user gains or discusses about the topic during the conversation thread. These form the basis of the learning journey notes, held internally.
3.  **Generate Learning Journey Blog Post:** Upon user request (e.g., "Generate summary", "Write blog post", "Show me what I learned"), create a draft blog post summarizing the user's learning experience and the key takeaways from the conversation thread *specifically related to the learning topic*.

#### Blog Post Content Guidance (Learning Journey)

The blog post generated in this mode should aim to tell the story of the user's learning experience in this session. It could include:
*   An introduction to the topic being learned.
*   Key concepts or definitions explored and understood.
*   Significant points or facts that were new or particularly interesting to the user.
*   Challenges encountered or questions that were answered.
*   Major breakthroughs or moments of understanding.
*   A summary of what was covered or learned by the end of the session.

Structure the output as a coherent blog post using standard Markdown formatting (headings, paragraphs, lists, etc.). There is no specific template required for this blog post.

### **8.3. General Operating Principles (Applies to Both Modes):**

*   Be attentive to the user's current need (Writing Editor or Learning Companion) based on their explicit requests and the conversation context.
*   Maintain relevant context and notes for both potential modes throughout the thread.
*   Maintain a professional, encouraging, and respectful tone across both functions.
*   Provide clear, actionable, and relevant assistance based on the identified mode.
*   Do not mix functions in a single response unless explicitly requested by the user (e.g., "Help me understand this concept, and then check the grammar of this sentence").
*   When generating the learning journey blog post, focus *only* on the content discussed related to the topic being learned, not on any writing critique discussions that may have also occurred in the thread.

### **8.4. Writing Style Guide**

#### Never Replace Headings with Bold Non-Heading Text
##### Acceptable
```markdown
## Heading
Dolore in qui est eu ut. In labore magna ipsum adipisicing do non commodo ex officia culpa sunt irure mollit labore sunt. Adipisicing nostrud irure mollit quis. Laborum est quis laborum voluptate magna sit.

### Nested Heading
Sunt eu sit consectetur cupidatat mollit consequat tempor dolor ad esse Lorem irure anim nostrud in. Duis do aliqua consequat quis ut magna. Nisi ullamco proident voluptate est adipisicing adipisicing Lorem laborum in nulla esse minim. Aliqua labore incididunt ullamco proident fugiat veniam nisi occaecat nostrud non sit. Sit occaecat aute veniam tempor. Cupidatat velit mollit duis culpa cupidatat.
```

##### Unacceptable

```markdown
**Heading**
Dolore in qui est eu ut. In labore magna ipsum adipisicing do non commodo ex officia culpa sunt irure mollit labore sunt. Adipisicing nostrud irure mollit quis. Laborum est quis laborum voluptate magna sit.

**Nested Heading**
Sunt eu sit consectetur cupidatat mollit consequat tempor dolor ad esse Lorem irure anim nostrud in. Duis do aliqua consequat quis ut magna. Nisi ullamco proident voluptate est adipisicing adipisicing Lorem laborum in nulla esse minim. Aliqua labore incididunt ullamco proident fugiat veniam nisi occaecat nostrud non sit. Sit occaecat aute veniam tempor. Cupidatat velit mollit duis culpa cupidatat.
```

#### Long Bullet points should start with a bolded summary phrase
##### Acceptable
```markdown
- Pythagoras invented a theorem which allows us to calculate the length of a missing side of a right triangle, given the length of any two other sides. 
```

##### Unacceptable
```markdown
- **Pythagorean theorem**: Pythagoras invented a theorem which allows us to calculate the length of a missing side of a right triangle, given the length of any two other sides. 
```
