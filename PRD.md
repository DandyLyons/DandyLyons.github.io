# 1. Product Requirements Document (PRD)
## Daniel Lyons' Personal Blog Site

**Version:** 1.0  
**Date:** July 2, 2025  
**Last Updated:** July 2, 2025  
**Next Review:** October 2, 2025
**Author:** Development Team  

---

## 2. Project Overview

### 2.1 Product Summary
This is the Hugo-based personal blog site for Daniel Lyons, hosted at [dandylyons.net](https://dandylyons.net). The site serves as a platform for publishing technical content, thoughts, essays, and project showcases, with the blog branded as **"Strongly Typed"**.

### 2.2 Technology Stack
- **Static Site Generator:** Hugo (v0.134.0)
- **Theme:** Hugo Blog Awesome (git submodule)
- **Primary Hosting:** Netlify
- **Secondary Hosting:** GitHub Pages (legacy/redirects) DEPRECATED
- **Content Management:** Decap CMS (optional interface)
- **Notes (Digital Garden):** Obsidian Publish Site (proxied through Netlify)
- **Version Control:** Git with GitHub: [DandyLyons/DandyLyons.github.io](https://github.com/DandyLyons/DandyLyons.github.io)

### 2.3 Git Branching Strategy
- **`main`**: Infrastructure changes, configuration updates, and documentation (`agents/` directory)
- **`content`**: Content-only changes (articles, posts, essays, thoughts)
- **`deploy-netlify`**: Automatic deployment trigger branch (content ready for production)
- **`decap-cms`**: Decap CMS configuration changes only
- **`deploy-gh-pages`**: Legacy GitHub Pages deployment (DEPRECATED)

### 2.4 Site Architecture
- **Base URL:** https://dandylyons.net
- **Language:** English (en-gb)
- **Content Sections:** Posts, Essays, Thoughts, Projects, About, Resume
- **Special Features:** LLM-friendly content exports (`/llms.txt`, `/llms-full.txt`)

---

## 3. Project Structure

### 3.1 Directory Organization
```
/
├── config.toml           # Hugo configuration
├── netlify.toml          # Netlify deployment settings
├── content/en-gb/        # All content in English
│   ├── posts/            # Blog posts
│   ├── essays/           # Long-form essays
│   ├── thoughts/         # Short thoughts/informal writing
│   ├── projects/         # Project showcases
│   ├── about/            # About page
│   └── unlisted/         # Draft/unlisted content
├── layouts/              # Custom Hugo templates
├── static/               # Static assets
├── themes/               # Git submodule for theme. This site is currently using the Hugo Blog Awesome theme. 
├── public/               # Generated site (build output)
└── .github/workflows/    # CI/CD configurations
```

### 3.2 Content Types
- **Posts:** Technical blog posts with topics, descriptions, images
- **Essays:** Long-form writing pieces
- **Thoughts:** Short-form content and quick notes
- **Projects:** Portfolio/showcase items
- **Pages:** Static pages (About, Resume)

---

## 4. Development Environment Setup

### 4.1 Prerequisites
- **Hugo Extended:** v0.134.0 or later
- **Git:** For version control and submodule management
- **Node.js:** (Optional) For additional tooling
- **Text Editor:** VS Code recommended

### 4.2 Initial Setup
1. **Clone Repository:**
   ```bash
   git clone https://github.com/DandyLyons/DandyLyons.github.io.git
   cd DandyLyons
   ```

2. **Initialize Submodules:**
   ```bash
   git submodule update --init --recursive
   ```

3. **Verify Hugo Installation:**
   ```bash
   hugo version
   # Should show v0.134.0 or later with "extended"
   ```

---

## 5. Standard Operating Procedures (SOPs)

### 5.1 Running Hugo Locally

#### 5.1.1 Development Server
**Purpose:** Start local development server for content creation and testing

**Steps:**
1. Navigate to project root directory
2. Run development server:
   ```bash
   hugo server -D --buildFuture
   ```
3. Access site at `http://localhost:1313`
4. Server will auto-reload on file changes. (Server may need to be manually restarted for certain changes such as configuration updates, theme changes, or new content types.)

**Options:**
- `-D`: Include draft content
- `--buildFuture`: Include future-dated content
- `--port 8080`: Use custom port

#### 5.1.2 Production Build Testing
**Purpose:** Test production build locally before deployment

**Steps:**
1. Build site for production:
   ```bash
   hugo --gc --minify --buildFuture
   ```
2. Serve built site:
   ```bash
   hugo serve -D --buildFuture
   ```
3. Access at `http://localhost:8000`

### 5.2 Content Creation Workflow

#### 5.2.1 Creating New Posts
**Purpose:** Add new blog posts to the site

**Steps:**
1. Create new post:
    - **Content Creation Commands:**
        - Command for new `thoughts`: `hugo new thoughts/post_num-post-title/index.md && code ./content/en-gb/thoughts/post_num-post-title/index.md`.
        - Command for new `essays`: `hugo new essays/post-title/index.md && code ./content/en-gb/essays/post-title/index.md`.
        - Command for new `posts`: `hugo new posts/post-title/index.md && code ./content/en-gb/posts/post-title/index.md`.
2. Edit frontmatter with required fields:
   ```yaml
   ---
   title: "Your Post Title"
   slug: "url-friendly-slug"
   date: 2025-07-02
   topics: ['Topic1', 'Topic2']
   images: ["featured-image.jpg"]
   description: "Brief description for SEO"
   ---
   ```
3. Write content in Markdown following style guide found in `agents/StyleGuide.md`.
4. Add images to post directory if needed
5. Preview with `hugo server -D`

#### 5.2.2 Content Review Process
1. **Draft Phase:** Set `draft: true` in frontmatter
2. **Review Phase:** Test locally, check formatting
3. **Content Branch:** Push to `content` branch for review
4. **Production Ready:** Merge to `deploy-netlify` branch for automatic deployment

### 5.3 Deployment to Netlify

#### 5.3.1 Automatic Deployment (Primary Method)
**Purpose:** Deploy changes to production site automatically

**Trigger:** Push to `deploy-netlify` branch

**Process:**
1. **Prepare Content:**
   - Ensure all content is ready for publication according to the checklist located in `agents/ContentChecklist.md`.
   - Remove `draft: true` from frontmatter
   - Verify images and links work locally

2. **Deploy:**
   ```bash
   # For content changes - first push to content branch for review
   git add .
   git commit -m "Add: [brief description of changes]"
   git push origin content
   
   # When ready for production deployment
   git checkout deploy-netlify
   git merge content
   git push origin deploy-netlify
   ```

3. **Monitor Deployment:**
   - Check Netlify dashboard for build status
   - Verify deployment at https://dandylyons.net
   - Review build logs if deployment fails

**Build Configuration:**
- **Hugo Version:** 0.134.0
- **Build Command:** `hugo --gc --minify --buildFuture`
- **Publish Directory:** `public`
- **Build Time:** ~2-3 minutes typical

#### 5.3.2 Manual Deployment Verification
**Purpose:** Verify successful deployment and functionality

**Checklist:**
Read the `agents/DeploymentChecklist.md` for manual verification steps.

### 5.4 GitHub Pages Deployment (DEPRECATED)
GitHub Pages deployment is deprecated and should only be used for legacy redirects. The primary deployment method is through Netlify.

#### 5.4.1 GitHub Pages Deployment Process
**Purpose:** Deploy to GitHub Pages for redirects/legacy support

**Trigger:** Push to `deploy-gh-pages` branch

**Note:** This is primarily used for redirect functionality and should not be used for primary deployment.

**Steps:**
```bash
git push origin deploy-gh-pages
```

**Build Process:**
- GitHub Actions workflow triggers
- Hugo builds with GitHub Pages configuration
- Deploys to `dandylyons.github.io`

### 5.5 Automated Site Validation with Playwright

#### 5.5.1 Setting Up Playwright Testing
**Purpose:** Automatically validate site functionality and content integrity

**Prerequisites:**
```bash
npm init -y
npm install --save-dev @playwright/test
npx playwright install
```

#### 5.5.2 Basic Validation Test Suite

**Create:** `tests/site-validation.spec.js`
```javascript
const { test, expect } = require('@playwright/test');

const BASE_URL = 'http://localhost:1313'; // or https://dandylyons.net for production

test.describe('Site Validation', () => {
  test('homepage loads correctly', async ({ page }) => {
    await page.goto(BASE_URL);
    await expect(page).toHaveTitle(/Daniel Lyons/);
    await expect(page.locator('h1')).toContainText('Daniel Lyons');
  });

  test('navigation menu works', async ({ page }) => {
    await page.goto(BASE_URL);
    
    // Test main navigation links
    await page.click('text=Posts');
    await expect(page).toHaveURL(/.*\/posts\//);
    
    await page.click('text=Projects');
    await expect(page).toHaveURL(/.*\/projects\//);
    
    await page.click('text=About');
    await expect(page).toHaveURL(/.*\/about\//);
  });

  test('blog posts are accessible', async ({ page }) => {
    await page.goto(`${BASE_URL}/posts/`);
    
    // Check that posts list loads
    await expect(page.locator('article')).toHaveCount.greaterThan(0);
    
    // Click on first post
    await page.click('article:first-child a');
    
    // Verify post page loads
    await expect(page.locator('h1')).toBeVisible();
  });

  test('RSS feed is accessible', async ({ page }) => {
    const response = await page.goto(`${BASE_URL}/posts/index.xml`);
    expect(response.status()).toBe(200);
    expect(response.headers()['content-type']).toContain('xml');
  });

  test('LLM exports are accessible', async ({ page }) => {
    // Test LLM exports
    const llmsResponse = await page.goto(`${BASE_URL}/llms.txt`);
    expect(llmsResponse.status()).toBe(200);
    
    const llmsFullResponse = await page.goto(`${BASE_URL}/llms-full.txt`);
    expect(llmsFullResponse.status()).toBe(200);
  });

  test('social links are present', async ({ page }) => {
    await page.goto(BASE_URL);
    
    // Check for social media icons/links
    await expect(page.locator('a[href*="github.com"]')).toBeVisible();
    await expect(page.locator('a[href*="linkedin.com"]')).toBeVisible();
  });
});
```

#### 5.5.3 Running Playwright Tests

**Local Development Testing:**
```bash
# Start Hugo server first
hugo server -D --buildFuture &

# Run tests
npx playwright test

# Stop Hugo server
kill %1
```

**Production Testing:**
```bash
# Test against live site
BASE_URL=https://dandylyons.net npx playwright test
```

**CI Integration:**
Add to `.github/workflows/test.yml`:
```yaml
name: Test Site
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2.6.0
        with:
          hugo-version: '0.134.0'
          extended: true
      - name: Build site
        run: hugo --minify
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Install Playwright
        run: npx playwright install --with-deps
      - name: Start Hugo server
        run: |
          cd public
          python3 -m http.server 8000 &
          sleep 5
      - name: Run Playwright tests
        run: BASE_URL=http://localhost:8000 npx playwright test
```

### 5.6 Git Workflow and Branch Management

#### 5.6.1 Branch-Specific Workflows

**Content Changes (`content` branch):**
```bash
# Start from main branch
git checkout main
git pull origin main

# Create/switch to content branch
git checkout -b content  # if branch doesn't exist
# OR
git checkout content     # if branch exists
git pull origin content

# Make content changes, then commit
git add content/
git commit -m "Add: [description of content changes]"
git push origin content

# When ready for production
git checkout deploy-netlify
git merge content
git push origin deploy-netlify  # Triggers automatic deployment
```

**Infrastructure Changes (`main` branch):**
```bash
# For config, theme, or agents/ directory changes
git checkout main
git add .
git commit -m "Update: [description of infrastructure changes]"
git push origin main
```

**CMS Configuration (`decap-cms` branch):**
```bash
# For Decap CMS configuration only
git checkout decap-cms
git add static/admin/
git commit -m "Update: CMS configuration"
git push origin decap-cms
```

#### 5.6.2 Branch Purpose Guidelines
- **`main`**: Default branch for infrastructure, configuration, documentation
- **`content`**: Staging area for content review before production
- **`deploy-netlify`**: Production deployment trigger (auto-deploys to dandylyons.net)
- **`decap-cms`**: CMS configuration isolation from content changes

---

## 6. Content Management

### 6.1 Content Guidelines

#### 6.1.1 Frontmatter Standards
**Required Fields:**
- `title`: SEO-optimized title
- `slug`: URL-friendly identifier
- `date`: Publication date (YYYY-MM-DD)
- `topics`: Array of relevant topics
- `description`: Meta description for SEO

**Optional Fields:**
- `images`: Featured images array
- `series`: Blog series identifier
- `draft`: Set to `true` for unpublished content

#### 6.1.2 Image Management
- **Location:** Store in same directory as content file
- **Formats:** WebP preferred, PNG/JPG acceptable
- **Naming:** Descriptive filenames, no spaces
- **Optimization:** Compress images before adding
- **Alt Text:** Always include descriptive alt attributes

### 6.2 SEO and Performance

#### 6.2.1 SEO Checklist
See also: `agents/SEOChecklist.md` for detailed SEO guidelines.

- [ ] Descriptive page titles (under 60 characters)
- [ ] Meta descriptions (under 160 characters)
- [ ] Proper heading hierarchy (H1, H2, H3...)
- [ ] Internal linking between related posts
- [ ] Topic categorization for content organization
- [ ] Social media preview images

#### 6.2.2 Performance Considerations
- **Image Optimization:** Use Hugo's image processing
- **Minification:** Enabled in production builds
- **CDN:** Netlify provides global CDN
- **Caching:** Configured through Netlify headers

---

## 7. Troubleshooting

### 7.1 Common Issues

#### 7.1.1 Build Failures
**Hugo Version Mismatch:**
- **Symptom:** Build fails with version-related errors
- **Solution:** Ensure Hugo Extended v0.134.0+ is installed
- **Check:** `hugo version`

**Submodule Issues:**
- **Symptom:** Theme not found errors
- **Solution:** Update submodules
- **Command:** `git submodule update --init --recursive`

**Memory Issues:**
- **Symptom:** Build fails with memory errors
- **Solution:** Increase build memory in Netlify settings
- **Setting:** Environment Variables → `HUGO_MEMORYLIMIT=512`

#### 7.1.2 Content Issues
**Images Not Loading:**
- **Check:** Image file exists in correct directory
- **Check:** Filename matches exactly (case-sensitive)
- **Check:** Image format is supported (jpg, png, webp, svg)

**Draft Content Showing:**
- **Check:** Remove `draft: true` from frontmatter
- **Check:** Date is not in the future (unless using `--buildFuture`)

#### 7.1.3 Deployment Issues
**Netlify Build Failures:**
- **Check:** Build logs in Netlify dashboard
- **Check:** Hugo version in `netlify.toml` matches local
- **Check:** All required files are committed and pushed

**DNS Issues:**
- **Check:** Netlify DNS settings
- **Check:** Domain configuration
- **Check:** SSL certificate status

### 7.2 Emergency Procedures

#### 7.2.1 Site Down Recovery
1. **Check Netlify Status:** https://www.netlifystatus.com/
2. **Rollback Deployment:** Use Netlify dashboard to deploy previous version
3. **Emergency Contact:** Check deployment logs for specific errors
4. **Hotfix Process:** Create fix on separate branch, test locally, deploy

#### 7.2.2 Content Recovery
1. **Git History:** Use `git log` to find previous versions
2. **Netlify Deploys:** Previous deployments saved for rollback
3. **Local Backup:** Always maintain local development copy

---

## 8. Maintenance Schedule

### 8.1 Regular Maintenance Tasks

#### 8.1.1 Weekly Tasks
- [ ] Review site performance in Netlify analytics
- [ ] Check for broken links in recent posts
- [ ] Monitor build times and success rates
- [ ] Review and moderate any comments (if enabled)

#### 8.1.2 Monthly Tasks
- [ ] Update Hugo version if new stable release available
- [ ] Review and update theme submodule
- [ ] Audit content for outdated information
- [ ] Review SEO performance in search console
- [ ] Backup content and configuration files

#### 8.1.3 Quarterly Tasks
- [ ] Comprehensive site audit with Playwright tests
- [ ] Review and update social media links
- [ ] Analyze site performance and loading speeds
- [ ] Update dependencies and security patches
- [ ] Review and update this PRD document

---

## 9. Team Onboarding

### 9.1 New Developer Checklist

#### 9.1.1 Environment Setup
- [ ] Install Hugo Extended (v0.134.0+)
- [ ] Clone repository with submodules
- [ ] Verify local development server works
- [ ] Set up Playwright testing environment
- [ ] Review codebase structure and configuration
- [ ] Read through this PRD document completely

#### 9.1.2 Knowledge Areas
**Required Understanding:**
- Hugo static site generator fundamentals
- Markdown content creation
- Git workflows and branching strategy (see Section 2.3)
- Netlify deployment process
- Basic SEO principles

**Helpful Background:**
- Go templates (for advanced Hugo customization)
- JavaScript (for theme modifications)
- Web performance optimization
- Content management best practices

---

## 10. References and Resources

### 10.1 Documentation Links
- **Hugo Documentation:** https://gohugo.io/documentation/
- **Hugo Blog Awesome Theme:** https://github.com/hugo-sid/hugo-blog-awesome
- **Netlify Documentation:** https://docs.netlify.com/
- **Playwright Documentation:** https://playwright.dev/
- **Decap CMS Documentation:** https://decapcms.org/docs/

### 10.2 Configuration References
- **Main Config:** `config.toml`
- **Netlify Config:** `netlify.toml`
- **GitHub Actions:** `.github/workflows/`
- **CMS Config:** `static/admin/config.yml`

### 10.3 Support Channels
- **Hugo Community:** https://discourse.gohugo.io/
- **Netlify Support:** https://answers.netlify.com/
- **Theme Issues:** https://github.com/hugo-sid/hugo-blog-awesome/issues

---

