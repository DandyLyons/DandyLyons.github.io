# Content Publication Checklist

**Version:** 1.0  
**Last Updated:** July 2, 2025  
**Purpose:** Ensure all content meets quality standards before publication

---

## 1. Pre-Publication Checklist Overview

This checklist ensures every piece of content published on dandylyons.net meets professional standards for quality, SEO, accessibility, and technical functionality. **Complete ALL items before pushing to the `content` branch for review, and before merging to `deploy-netlify` for production.**

---

## 2. Content Structure and Formatting

### 2.1 Frontmatter Validation
**Required for ALL content types:**
- [ ] `title` field present and descriptive (50-60 characters for SEO)
- [ ] `date` field in YYYY-MM-DD format
- [ ] `slug` field matches filename and is URL-friendly (lowercase, hyphens only)
- [ ] `topics` array contains 1-3 relevant, consistent topics
- [ ] `description` field present (120-160 characters for SEO)
- [ ] `draft: true` removed (content ready for publication)

**Content-type specific requirements:**
- [ ] **Posts**: Include `topics` and ensure they align with existing site topics
- [ ] **Essays**: Include `tags: ["essays"]` and focus on evergreen topics
- [ ] **Thoughts**: Include `tags: ["thoughts"]` and `aliases` for numerical references
- [ ] **Projects**: Include relevant project metadata and links

### 2.2 Markdown Structure Validation
- [ ] Single H1 heading (article title) - automatically generated from frontmatter
- [ ] Proper heading hierarchy (H2 → H3 → H4, no skipped levels)
- [ ] Headings are descriptive and scannable
- [ ] Content sections are logically organized
- [ ] Paragraphs are appropriately sized (2-4 sentences)
- [ ] Lists use consistent formatting (hyphens for unordered, numbers for ordered)

### 2.3 Writing Quality Review
- [ ] Content follows the voice and tone guidelines in `agents/StyleGuide.md`
- [ ] Opening paragraph engages readers with relatable scenario or question
- [ ] Clear problem/solution structure maintained throughout
- [ ] Personal insights and lessons learned are included
- [ ] Conclusion provides clear takeaways or next steps
- [ ] Writing is conversational but professional
- [ ] Technical concepts are explained with appropriate context

---

## 3. Technical Content Validation

### 3.1 Code Examples and Technical Accuracy
- [ ] **ALL code examples have been tested and work as written**
- [ ] Code blocks include proper language specification for syntax highlighting
- [ ] Code examples are complete and functional (not pseudocode)
- [ ] Comments are included for complex code sections
- [ ] Error handling is included where appropriate
- [ ] Code follows current best practices for the technology discussed

### 3.2 Links and References
- [ ] **ALL external links are functional and load correctly**
- [ ] **ALL internal links use proper Hugo syntax** `{{< ref "post-slug" >}}`
- [ ] Link text is descriptive (avoid "click here" or "read more")
- [ ] External links open appropriately (consider new tab for external resources)
- [ ] No broken or dead links present
- [ ] References to tools/software include current version numbers where relevant

### 3.3 Images and Media
- [ ] **ALL images load correctly in local development**
- [ ] Images are stored in the same directory as the content file
- [ ] **Every image has descriptive alt text**
- [ ] Image file names are descriptive and contain no spaces
- [ ] Images are optimized for web (reasonable file sizes)
- [ ] Screenshots are current and match described interfaces
- [ ] Images are referenced correctly in markdown (`![Alt text](filename.jpg)`)
  - [ ] The site should avoid hosting images directly in the hugo repo because it can cost too much to host on Netlify. If an image is hosted directly in the hugo repo, then you should suggest to the human to host it on an external service like Cloudinary or Imgix.

---

## 4. SEO and Discoverability

### 4.1 SEO Metadata
- [ ] **Title is 50-60 characters** and includes primary keywords
- [ ] **Description is 120-160 characters** and compelling for search results
- [ ] **Topics/tags align with site taxonomy** and are consistently used
- [ ] Primary keywords appear naturally in the first paragraph
- [ ] Headings include relevant keywords without keyword stuffing
- [ ] Content is substantial enough to provide value (minimum 500 words for posts)

### 4.2 Internal Linking and Site Structure
- [ ] Content links to relevant existing articles where appropriate
- [ ] Related topics are connected through internal linking
- [ ] Series articles reference previous/next posts in sequence
- [ ] Content supports the overall site architecture and topic organization

### 4.3 Social Media Optimization
- [ ] Featured image specified in frontmatter (`images: ["featured-image.jpg"]`)
- [ ] Social media description is engaging and accurate
- [ ] Content is shareable and provides clear value proposition

---

## 5. Copy Editing and Proofreading

### 5.1 Grammar and Spelling
- [ ] **Run spell check** using editor or online tool
- [ ] **Proofread entire article** for grammar errors
- [ ] Check for common homophone errors (there/their/they're, its/it's, etc.)
- [ ] Verify proper capitalization of technology names (SwiftUI, macOS, GitHub, etc.)
- [ ] Consistent use of contractions and tone throughout

### 5.2 Style Consistency
- [ ] **Follows writing patterns from `agents/StyleGuide.md`**
- [ ] Consistent use of first person ("I") and second person ("you")
- [ ] Technical terms are introduced before use
- [ ] Formatting is consistent (bold, italic, code formatting)
- [ ] Numbers follow style guide (spell out 1-9, numerals for 10+)
- [ ] Dates follow format: "July 2, 2025"

### 5.3 Content Flow and Readability
- [ ] Content flows logically from introduction to conclusion
- [ ] Transitions between sections are smooth and clear
- [ ] Paragraphs are scannable with appropriate white space
- [ ] Content maintains reader engagement throughout
- [ ] Technical difficulty is appropriate for target audience

---

## 6. Local Testing and Validation

### 6.1 Hugo Development Server Testing
**Before finalizing content:**
- [ ] **Start local server:** `hugo server -D --buildFuture`
- [ ] **Verify content renders correctly** at `http://localhost:1313`
- [ ] **Check all internal links work** within the local site
- [ ] **Verify images display properly** and alt text is appropriate
- [ ] **Test responsive behavior** (desktop, tablet, mobile views)
- [ ] **Check dark/light mode compatibility**

### 6.2 Build Testing
- [ ] **Run production build:** `hugo --gc --minify --buildFuture`
- [ ] **Check build completes without errors or warnings**
- [ ] **Verify no broken internal references** in build output
- [ ] **Test built site locally** using `hugo serve` or local server

### 6.3 Cross-Browser Compatibility
- [ ] **Test in primary browsers** (Chrome, Firefox, Safari)
- [ ] **Verify mobile responsiveness** works correctly
- [ ] **Check social media preview** using browser dev tools or preview tools

---

## 7. Content-Specific Checklists

### 7.1 Technical Posts
- [ ] **Code examples tested in actual development environment**
- [ ] **Prerequisites clearly stated** (versions, dependencies, etc.)
- [ ] **Step-by-step instructions are complete and accurate**
- [ ] **Troubleshooting section included** for common issues
- [ ] **Alternative approaches mentioned** when appropriate
- [ ] **Conclusion connects to broader learning goals**

### 7.2 How-To Articles
- [ ] **Instructions tested by following them exactly as written**
- [ ] **Screenshots current and match described interfaces**
- [ ] **Prerequisites and assumptions clearly stated**
- [ ] **Expected outcomes described**
- [ ] **Common pitfalls and solutions addressed**

### 7.3 Review/Opinion Pieces
- [ ] **Personal experience and context provided**
- [ ] **Pros and cons fairly represented**
- [ ] **Target audience clearly identified**
- [ ] **Alternatives mentioned where appropriate**
- [ ] **Conclusions are well-supported by examples**

---

## 8. Accessibility and Inclusivity

### 8.1 Content Accessibility
- [ ] **Alt text provided for all images**
- [ ] **Heading structure supports screen readers** (proper hierarchy)
- [ ] **Link text is descriptive and contextual**
- [ ] **Code examples include explanatory text**
- [ ] **Color is not the only way information is conveyed**

### 8.2 Inclusive Language
- [ ] **Language is welcoming to beginners and experts**
- [ ] **Assumptions about reader background are minimal**
- [ ] **Technical concepts explained without condescension**
- [ ] **Examples are relatable and diverse**

---

## 9. Final Pre-Publication Steps

### 9.1 Content Review
- [ ] **Read entire article aloud** to catch flow issues
- [ ] **Verify all checklist items completed**
- [ ] **Check that content provides clear value to readers**
- [ ] **Ensure content aligns with site's brand and voice**

### 9.2 Metadata and Organization
- [ ] **File structure follows site conventions** (`content/en-gb/[type]/[slug]/index.md`)
- [ ] **Images and assets in correct directory**
- [ ] **Frontmatter complete and accurate**
- [ ] **Content type matches intended publication section**

### 9.3 Git and Deployment Preparation
- [ ] **All files saved and committed locally**
- [ ] **Commit message follows convention** ("Add: [brief description]")
- [ ] **Ready to push to `content` branch for review**
- [ ] **When approved, ready to merge to `deploy-netlify` for production**

---

## 10. Post-Publication Monitoring

### 10.1 Immediate Post-Deployment
**After merging to `deploy-netlify`:**
- [ ] **Monitor Netlify build logs** for successful deployment
- [ ] **Verify content appears correctly** on live site (https://dandylyons.net)
- [ ] **Test all links work** on the live site
- [ ] **Check social media preview** using actual sharing tools

### 10.2 Content Performance
- [ ] **Monitor for any user-reported issues** in first 24 hours
- [ ] **Check analytics** for engagement metrics
- [ ] **Verify RSS feed updates** with new content
- [ ] **Test LLM exports include new content** (`/llms.txt`, `/llms-full.txt`)

---

## 11. Emergency Rollback Procedures

### 11.1 If Issues Are Discovered Post-Publication
1. **Immediate Assessment:**
   - Determine severity (broken site vs. minor content issue)
   - Check if issue affects site functionality or just content quality

2. **Quick Fix Options:**
   - **Minor issues:** Create hotfix commit and redeploy
   - **Major issues:** Rollback to previous deployment in Netlify dashboard
   - **Broken builds:** Check build logs and fix configuration issues

3. **Communication:**
   - Update team/stakeholders if site is down
   - Document issue and resolution for future reference

---

## 12. Quality Assurance Tools

### 12.1 Automated Testing
**When available, use these tools:**
- **Hugo build validation:** `hugo --gc --minify --buildFuture`
- **Link checking:** Manual verification or automated tools
- **Spell checking:** Editor plugins or online tools
- **Markdown validation:** Linting tools for markdown syntax

### 12.2 Manual Review Tools
- **Browser developer tools** for responsive testing
- **Social media preview tools** for sharing optimization
- **Accessibility checkers** for WCAG compliance
- **Reading level analyzers** for content complexity

---

## 13. Checklist Summary

**Before merging to production - verify:**
- [ ] All content checklist items completed
- [ ] Local testing passed (Hugo server + build test)
- [ ] All links and images work correctly
- [ ] SEO metadata optimized
- [ ] Content follows style guide
- [ ] Code examples tested and functional
- [ ] Content reviewed on `content` branch
- [ ] Ready for deployment to production via `deploy-netlify`

**Remember:** It's better to delay publication to ensure quality than to publish broken or incomplete content. This checklist protects both the site's reputation and user experience.

---

## 14. Git Workflow for Content

### 14.1 Content Development Process
```bash
# 1. Start from main branch
git checkout main
git pull origin main

# 2. Switch to content branch
git checkout content
git pull origin content

# 3. Create your content and complete this checklist

# 4. Commit content changes
git add content/
git commit -m "Add: [description of content]"
git push origin content

# 5. When ready for production (after review)
git checkout deploy-netlify
git merge content
git push origin deploy-netlify  # This triggers automatic deployment on Netlify
```

### 14.2 Branch Usage Guidelines
- **`content` branch**: Use for all content creation and review
- **`deploy-netlify` branch**: Only merge to this when content is production-ready
- **`main` branch**: Do not use for content changes (infrastructure only)
- **`decap-cms` branch**: Do not use for content (CMS configuration only)

### 14.3 Content Review Workflow
1. **Development (Writing)**: Work on `content` branch
2. **Self-Review**: Complete this entire checklist
3. **Staging**: Push to `content` branch for review
4. **Production**: Merge reviewed content to `deploy-netlify` and push changes
5. **Monitor**: Verify deployment success on live site

---

**Checklist Version:** 1.0  
**Last Updated:** July 2, 2025  
**Next Review:** October 2, 2025
