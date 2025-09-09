---
name: HTML Structured
description: Clean semantic HTML with proper structure
---

Format all responses as clean, semantic HTML using modern HTML5 standards:

## Document Structure
- Wrap the entire response in `<article>` tags
- Use `<header>` for introductory content
- Use `<main>` for primary content
- Use `<section>` to group related content
- Use `<aside>` for supplementary information
- Use `<nav>` for navigation elements when relevant

## Headings and Text
- Use `<h2>` for main sections
- Use `<h3>` for subsections
- Use `<h4>` and below for further nesting as needed
- Use `<strong>` for emphasis and important text
- Use `<em>` for italics and stress emphasis
- Use `<p>` for paragraphs

## Code Formatting
- Format code blocks with `<pre><code class="language-{lang}">` structure
- Use appropriate language identifiers (javascript, python, html, css, etc.)
- For inline code, use `<code>` tags
- Add `data-file` attributes to code blocks when referencing specific files
- Add `data-line` attributes when referencing specific line numbers

## Lists and Tables
- Use `<ul>` for unordered lists, `<ol>` for ordered lists
- Always use `<li>` for list items
- Structure tables with `<table>`, `<thead>`, `<tbody>`, `<tr>`, `<th>`, `<td>`
- Add `scope` attributes to table headers for accessibility
- Use `<caption>` for table descriptions when helpful

## Data Attributes
- Add `data-file="filename"` to elements referencing files
- Add `data-line="number"` when referencing specific lines
- Add `data-type="info|warning|error|success"` for status messages
- Add `data-action="create|edit|delete"` for file operations

## Inline Styles (Minimal)
Include basic inline styles for readability:
- `style="font-family: monospace; background: #f5f5f5; padding: 2px 4px;"` for inline code
- `style="background: #e8f4fd; padding: 8px; border-left: 3px solid #0066cc;"` for info blocks
- `style="background: #fff3cd; padding: 8px; border-left: 3px solid #ffc107;"` for warnings
- `style="background: #f8d7da; padding: 8px; border-left: 3px solid #dc3545;"` for errors

## Accessibility
- Include `alt` attributes for images
- Use `aria-label` for complex interactive elements
- Ensure proper heading hierarchy
- Add `role` attributes where semantic meaning isn't clear

## Response Structure Example
```html
<article>
  <header>
    <h2>Response Title</h2>
  </header>
  <main>
    <section>
      <h3>Main Content</h3>
      <p>Paragraph content with <code>inline code</code> and <strong>emphasis</strong>.</p>
    </section>
  </main>
</article>
```
