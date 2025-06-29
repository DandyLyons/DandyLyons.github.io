# Gemini Project Companion: DandyLyons Hugo Site

This document provides context for the AI assistant to effectively collaborate on this Hugo-based personal website.

## 1. Project Overview & Goals

- **Project:** A personal website built with the Hugo static site generator.
- **Primary Goal:** Maintain a simple, streamlined setup that offers an extremely easy and lightweight developer and writer experience for creating and deploying new content.

## 2. Core Technologies & Configuration

- **Hugo Version:** `hugo v0.134.0+extended darwin/arm64`. The user prefers stability over frequent updates.
- **Operating System:** macOS.
- **Configuration:** The primary configuration is in `config.toml`.
- **Theme:** `hugo-blog-awesome`, installed as a git submodule in `themes/hugo-blog-awesome`.
- **Key `config.toml` settings:**
    - `baseURL`: `https://dandylyons.net`
    - `defaultContentLanguage`: `en-gb`
    - `frontmatter.format`: `yaml` (Note: `archetypes/default.md` uses TOML `+++`).
    - `mainSections`: `["posts", "essays", "thoughts"]`
    - Taxonomies: `series`, `topics`.
    - Services: Google Analytics is enabled; Disqus is disabled; Talkyard is configured for comments.

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
-   **`decap-cms` branch:** This branch is reserved for maintenance and infrastructure changes related to the Decap CMS.

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
