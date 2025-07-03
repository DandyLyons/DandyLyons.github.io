# Writing Style Guide for Daniel Lyons' Blog

**Version:** 1.0  
**Last Updated:** July 2, 2025  
**Purpose:** Standardize writing style, tone, and formatting across all content on dandylyons.net

---

## 1. Voice and Tone

### 1.1 Primary Voice Characteristics
- **Conversational yet informed**: Write as if explaining complex topics to a colleague over coffee
- **Approachable expertise**: Balance technical accuracy with accessibility
- **Authentic and personal**: Use first-person perspective ("I", "my experience") when appropriate
- **Reflective and thoughtful**: Include personal insights and lessons learned
- **Humble confidence**: Share knowledge without arrogance; acknowledge limitations

### 1.2 Tone Guidelines
- **Encouraging and supportive**: Help readers feel capable of learning
- **Curious and exploratory**: Frame challenges as learning opportunities
- **Pragmatic**: Focus on practical applications and real-world experience
- **Honest about trade-offs**: Acknowledge pros and cons of different approaches
- **Occasionally playful**: Use humor sparingly but effectively

### 1.3 Avoid These Tones
- Overly academic or formal
- Condescending or dismissive
- Overly promotional or sales-focused
- Dramatic or hyperbolic
- Unnecessarily complex or jargon-heavy

---

## 2. Writing Structure and Organization

### 2.1 Opening Patterns
**Preferred opening styles:**
- Start with a relatable scenario or question
- Use a brief anecdote or personal experience
- Present a common problem or challenge
- Reference current events or trends (when relevant)

**Example openings from the blog:**
- "Have you ever felt like there's simply *too much* to read and not enough time?"
- "Testing is vitally important in virtually any tech stack. That is, unless you want to shut down 8.5 million computers worldwide."
- "Hello! Welcome to my personal site!"

### 2.2 Content Structure
**Standard article organization:**
1. **Engaging introduction** (1-2 paragraphs)
2. **Problem/context statement** (1-2 paragraphs)
3. **Main content sections** (3-6 major sections)
4. **Conclusion with takeaways** (1-2 paragraphs)
5. **Optional future considerations** (1 paragraph)

**Section headers should be:**
- Descriptive and scannable
- Question-based when appropriate ("How the heck do I make my text bold?")
- Action-oriented ("Don't Be Afraid of Markdown")
- Specific rather than generic

### 2.3 Content Types and Their Structures

#### Posts (Technical blog posts)
- **Length**: 1,500-3,000 words
- **Depth**: Deep technical exploration with code examples
- **Structure**: Problem → Solution → Implementation → Reflection
- **Research**: Thoroughly tested and verified

#### Essays (Long-form thought pieces)
- **Length**: 2,000-5,000 words
- **Depth**: Philosophical or strategic exploration
- **Structure**: Thesis → Supporting arguments → Counterarguments → Synthesis
- **Tone**: More reflective and timeless

#### Thoughts (Short-form content)
- **Length**: 500-1,500 words
- **Depth**: Single focused idea or reflection
- **Structure**: Observation → Insight → Brief exploration
- **Tone**: More immediate and conversational

---

## 3. Markdown Formatting Standards

### 3.1 Heading Hierarchy
```markdown
# Article Title (H1) - Used only once per article
## Major Section (H2) - Primary divisions
### Subsection (H3) - Secondary divisions
#### Minor Subsection (H4) - Tertiary divisions (rare)
```

**Guidelines:**
- Never skip heading levels (don't go from H2 to H4)
- Use descriptive, specific headings
- Avoid generic headings like "Introduction" or "Overview"
- Consider using question-based headings for instructional content

### 3.2 Emphasis and Formatting
```markdown
**Bold text** - For important concepts, key terms, or strong emphasis
_Italic text_ - For subtle emphasis, foreign words, or publication titles
`Code snippets` - For inline code, commands, or technical terms
```

**Usage guidelines:**
- Use bold sparingly for maximum impact
- Italics for gentle emphasis or when referencing other works
- Reserve ALL CAPS for rare, strong emphasis
- Use backticks for any technical terms, file names, or UI elements

### 3.3 Lists and Structure
**Unordered lists:**
```markdown
- Use hyphens (-) for consistency
- Keep items parallel in structure
- Use sub-bullets sparingly
  - Only when necessary for clarity
  - Don't go deeper than two levels
```

**Ordered lists:**
```markdown
1. Use for sequential steps
2. Or for ranked/prioritized items
3. Keep numbering automatic (don't hardcode)
```

### 3.4 Code Blocks
**Inline code:**
```markdown
Use `backticks` for commands, file names, or short code snippets
```

**Code blocks:**
````markdown
```swift
// Use language-specific syntax highlighting
func example() {
    print("Always include working, tested code")
}
```
````

**Guidelines:**
- Always specify the language for syntax highlighting
- Include comments for complex code
- Test all code examples before publishing
- Keep code blocks focused and relevant

### 3.5 Links and References
**Internal links:**
```markdown
[Link text]({{< ref "post-slug" >}}) - For internal references
```

**External links:**
```markdown
[Link text](https://example.com) - For external references
```

**Guidelines:**
- Use descriptive link text (not "click here")
- Open external links in new tabs when appropriate
- Verify all links work before publishing
- Use relative links for internal content

### 3.6 Images and Media
```markdown
![Descriptive alt text](image-filename.png)
```

**Guidelines:**
- Always include descriptive alt text
- Use WebP format when possible
- Optimize images for web (reasonable file sizes)
- Store images in the same directory as the content file

### 3.7 Footnotes
```markdown
Main text with a footnote reference[^1].

[^1]: Footnote content goes here, close to the original reference, NOT at the bottom of the markdown file.
```

**Usage:**
- Use for additional context or citations
- Keep footnotes brief and relevant
- Number footnotes sequentially
- Place footnote definitions at the end of the article

---

## 4. Language and Style Guidelines

### 4.1 Vocabulary and Terminology
**Preferred style:**
- Use clear, everyday language when possible
- Define technical terms when first introduced
- Prefer active voice over passive voice
- Use contractions naturally ("don't" instead of "do not")
- Write "you" instead of "one" for direct address

**Technical terms:**
- Introduce complex concepts gradually
- Use analogies and metaphors to explain difficult ideas
- Provide context for acronyms and abbreviations
- Link to external resources for deeper learning

### 4.2 Sentence Structure
**Guidelines:**
- Vary sentence length for rhythm and flow
- Use shorter sentences for emphasis
- Break up long paragraphs (3-4 sentences max)
- Use transition words to connect ideas
- Start sentences with different words/structures

### 4.3 Paragraph Guidelines
- **Length**: 2-4 sentences typically
- **Focus**: One main idea per paragraph
- **Flow**: Each paragraph should connect to the next
- **Scanability**: Use white space generously

### 4.4 Common Patterns from the Blog
**Effective phrases and constructions:**
- "Here's what I've learned..."
- "The problem with [X] is..."
- "Don't be afraid of..."
- "In my experience..."
- "Here's the thing..."
- "The beauty of [X] is..."

---

## 5. Content-Specific Guidelines

### 5.1 Technical Writing
**For code-related content:**
- Always test code examples
- Provide complete, working examples
- Include error handling when relevant
- Explain the "why" not just the "how"
- Use realistic examples, not "foo/bar"

**For tool reviews:**
- Share personal experience and use cases
- Discuss pros and cons honestly
- Provide context for who should use the tool
- Include alternatives when appropriate

### 5.2 Personal Reflections
**When sharing personal insights:**
- Connect personal experience to broader lessons
- Acknowledge when something might not work for others
- Share failures and learning moments
- Avoid oversharing personal details
- Focus on the insights gained

### 5.3 Instructional Content
**For how-to articles:**
- Use numbered steps for procedures
- Include screenshots or code examples
- Anticipate common problems
- Provide troubleshooting tips
- Test instructions with a fresh perspective

---

## 6. Consistency Standards

### 6.1 Capitalization
- **Blog/site name**: "Daniel Lyons' Personal Site" or "Strongly Typed"
- **Technology names**: Use official capitalization (SwiftUI, macOS, iOS, GitHub)
- **Headings**: Use title case for major headings, sentence case for minor ones
- **UI elements**: Use exact capitalization from the interface

### 6.2 Numbers and Formatting
- **Numbers**: Spell out numbers one through nine, use numerals for 10+
- **Dates**: Use format: "July 2, 2025" 
- **Times**: Use 12-hour format with AM/PM
- **Percentages**: Use numerals with % symbol (95%)
- **Versions**: Use official version formatting (v1.0, iOS 17.0)

### 6.3 Common Terms and Spelling
- **Website/web site**: Use "website" (one word)
- **Email**: Use "email" (not "e-mail")
- **Setup/set up**: "Setup" (noun), "set up" (verb)
- **Login/log in**: "Login" (noun), "log in" (verb)
- **GitHub**: Always capitalize the "H"
- **macOS**: Always use lowercase "m"
- **iOS**: Always use lowercase "i"

---

## 7. Frontmatter Standards

### 7.1 Required Fields
```yaml
---
title: "Article Title"
date: YYYY-MM-DD
slug: "url-friendly-slug"
topics: ["Topic1", "Topic2"]
description: "SEO-friendly description under 160 characters"
---
```

### 7.2 Optional Fields
```yaml
images: ["featured-image.jpg"]
series: ["Series Name"]
draft: true
tags: ["additional", "tags"]
aliases: ["/old-url/"]
```

### 7.3 Content Type Specific
**Posts:**
- Always include `topics` array
- Use specific, searchable topics
- Include `description` for SEO

**Essays:**
- Include `tags: ["essays"]` 
- Focus on evergreen topics
- Use thoughtful, philosophical descriptions

**Thoughts:**
- Include `tags: ["thoughts"]`
- Use `aliases` for numerical references
- Keep descriptions brief and engaging

---

## 8. Editorial Guidelines

### 8.1 Review Process
Before publishing, check:
- [ ] All code examples work as written
- [ ] All links are functional
- [ ] Images load properly and have alt text
- [ ] Spelling and grammar are correct
- [ ] Headings follow proper hierarchy
- [ ] Content matches the target audience
- [ ] SEO elements are optimized

### 8.2 Common Pitfalls to Avoid
- **Over-explaining**: Don't belabor obvious points
- **Under-explaining**: Don't assume too much knowledge
- **Inconsistent tone**: Maintain voice throughout
- **Weak conclusions**: End with clear takeaways
- **Untested code**: Always verify examples work
- **Broken links**: Check all references

### 8.3 Revision Guidelines
**First draft focus:**
- Get ideas down without worrying about perfection
- Focus on structure and flow
- Include all necessary technical details

**Second draft focus:**
- Refine language and tone
- Improve transitions between sections
- Tighten up explanations

**Final draft focus:**
- Proofread for grammar and spelling
- Verify all technical details
- Check formatting and links
- Optimize for SEO

---

## 9. SEO and Discoverability

### 9.1 Title Guidelines
- **Length**: 50-60 characters for optimal SEO
- **Format**: Be descriptive but compelling
- **Keywords**: Include relevant search terms naturally
- **Uniqueness**: Ensure titles are unique across the site

### 9.2 Description Guidelines
- **Length**: 120-160 characters
- **Content**: Summarize the main value proposition
- **Keywords**: Include primary topic keywords
- **Call to action**: Encourage clicks when appropriate

### 9.3 Topic/Tag Strategy
**Topics** (primary categorization):
- Swift, SwiftUI, iOS, macOS, Hugo, Testing, AI, Writing
- Keep topics broad but specific
- Use consistently across similar content

**Tags** (secondary categorization):
- More specific than topics
- Include content type tags ("thoughts", "essays")
- Use for series organization

---

## 10. Voice Consistency Examples

### 10.1 Good Examples from the Blog
**Conversational but informed:**
> "Don't be afraid of Markdown. I repeat, do not be afraid of Markdown."

**Personal and reflective:**
> "There's a part of me that feels like I've spent too much time writing and rewriting this personal site. Perhaps."

**Encouraging:**
> "You don't have to use AI. Use whatever tools you want. If you don't want to use AI, don't use it."

**Honest about limitations:**
> "But hugo is not without its drawbacks. A small part of me misses jekyll's liquid templating language..."

### 10.2 Maintain This Voice
- Use "I" and "you" naturally
- Share personal experiences and lessons learned
- Acknowledge when something might not work for everyone
- Use questions to engage readers
- Be honest about trade-offs and limitations
- Encourage experimentation and learning

---

**Remember**: This style guide is a living document. As the blog evolves, so should these guidelines. The goal is consistency without rigidity—maintain the authentic voice while ensuring professional quality across all content.
