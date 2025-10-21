---
name: pdf-generation
description: Expertise in generating professional PDFs from markdown and HTML
---

# PDF Generation Expertise

## Domain Focus

Expert knowledge in converting markdown and HTML to professional, ATS-friendly PDF documents using tools like Pandoc, WeasyPrint, and LaTeX.

## Core Capabilities

- Markdown to PDF conversion via Pandoc
- HTML/CSS to PDF using WeasyPrint or Puppeteer
- LaTeX template customization for professional output
- Font embedding and typography optimization
- Page layout and margin control
- Header/footer management
- ATS-compatible PDF generation
- Multi-format output (PDF, DOCX, HTML)
- Styling and theming
- Metadata and document properties

## When to Use This Skill

Invoke this skill when:

- Converting markdown resumes to PDF
- Generating professional-looking PDFs from templates
- Creating ATS-compatible resume PDFs
- Customizing PDF layouts and styling
- Batch generating PDFs from multiple sources
- Ensuring consistent document formatting

## PDF Generation Approaches

### Option 1: Pandoc (Markdown → PDF via LaTeX)

**Best for:** Professional quality, precise typography, academic/technical documents

```bash
# Basic conversion
pandoc resume.md -o resume.pdf

# With custom template
pandoc resume.md -o resume.pdf \
  --template=eisvogel \
  --pdf-engine=xelatex \
  -V geometry:margin=0.75in \
  -V fontsize=11pt \
  -V colorlinks=true

# Full customization
pandoc resume.md -o resume.pdf \
  --template=custom-resume.tex \
  --pdf-engine=xelatex \
  -V mainfont="Calibri" \
  -V sansfont="Arial" \
  -V monofont="Courier New" \
  -V geometry:margin=0.5in \
  -V fontsize=10pt \
  -V linestretch=1.0 \
  --metadata title="John Doe - Resume"
```

**Custom LaTeX Template:**
```latex
% custom-resume.tex
\documentclass[11pt,letterpaper]{article}

% Margins
\usepackage[margin=0.75in]{geometry}

% Font
\usepackage{fontspec}
\setmainfont{Calibri}

% Remove page numbers
\pagenumbering{gobble}

% Compact lists
\usepackage{enumitem}
\setlist[itemize]{leftmargin=*,nosep,after=\vspace{0.5\baselineskip}}

% Section formatting
\usepackage{titlesec}
\titleformat{\section}{\Large\bfseries}{}{0em}{}[\titlerule]
\titlespacing{\section}{0pt}{12pt}{6pt}

\begin{document}

$body$

\end{document}
```

### Option 2: WeasyPrint (HTML/CSS → PDF)

**Best for:** Complete styling control, web-based workflows, complex layouts

```python
from weasyprint import HTML, CSS
from weasyprint.text.fonts import FontConfiguration

def generate_pdf_from_html(html_content, output_path):
    """Generate PDF from HTML with custom styling"""

    # Custom CSS for resume styling
    css = CSS(string='''
        @page {
            size: letter;
            margin: 0.75in;
            @bottom-right {
                content: counter(page);
            }
        }

        body {
            font-family: Calibri, Arial, sans-serif;
            font-size: 11pt;
            line-height: 1.4;
            color: #000;
        }

        h1 {
            font-size: 24pt;
            margin-bottom: 5pt;
            border-bottom: 2pt solid #333;
        }

        h2 {
            font-size: 14pt;
            margin-top: 12pt;
            margin-bottom: 6pt;
            color: #333;
            border-bottom: 1pt solid #666;
        }

        h3 {
            font-size: 12pt;
            margin-top: 8pt;
            margin-bottom: 4pt;
        }

        ul {
            margin: 0;
            padding-left: 20pt;
        }

        li {
            margin-bottom: 3pt;
        }

        .header {
            text-align: center;
            margin-bottom: 12pt;
        }

        .contact-info {
            text-align: center;
            font-size: 10pt;
            margin-bottom: 12pt;
        }
    ''')

    # Font configuration
    font_config = FontConfiguration()

    # Generate PDF
    HTML(string=html_content).write_pdf(
        output_path,
        stylesheets=[css],
        font_config=font_config
    )
```

### Option 3: Puppeteer (HTML → PDF via Headless Chrome)

**Best for:** Complex CSS, web fonts, consistent cross-platform rendering

```javascript
const puppeteer = require('puppeteer');

async function generatePDF(htmlContent, outputPath) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  await page.setContent(htmlContent);

  await page.pdf({
    path: outputPath,
    format: 'Letter',
    margin: {
      top: '0.75in',
      right: '0.75in',
      bottom: '0.75in',
      left: '0.75in'
    },
    printBackground: true,
    preferCSSPageSize: true
  });

  await browser.close();
}
```

## ATS-Friendly PDF Best Practices

### Formatting Rules

```yaml
DO:
  - Use system fonts (Arial, Calibri, Georgia)
  - Embed all fonts in PDF
  - Use standard page size (Letter or A4)
  - Maintain consistent margins (0.5-1 inch)
  - Use black text on white background
  - Ensure text is selectable (not images)
  - Use simple bullet points
  - Keep file size under 2MB

DON'T:
  - Use images for text content
  - Apply complex backgrounds or watermarks
  - Use tables for layout (ATS may parse incorrectly)
  - Rely on colors to convey information
  - Create multi-column layouts (can confuse parsers)
  - Use headers/footers for critical info
```

### Metadata Configuration

```python
from PyPDF2 import PdfReader, PdfWriter

def add_pdf_metadata(input_pdf, output_pdf, metadata):
    """Add metadata to PDF for better organization"""

    reader = PdfReader(input_pdf)
    writer = PdfWriter()

    # Copy all pages
    for page in reader.pages:
        writer.add_page(page)

    # Add metadata
    writer.add_metadata({
        '/Title': metadata.get('title', 'Resume'),
        '/Author': metadata.get('author', ''),
        '/Subject': metadata.get('subject', 'Professional Resume'),
        '/Creator': 'Resume Toolkit',
        '/Keywords': metadata.get('keywords', '')
    })

    # Write to file
    with open(output_pdf, 'wb') as output:
        writer.write(output)
```

## Markdown to HTML Conversion

If using HTML-based PDF generation, first convert markdown:

```python
import markdown

def markdown_to_html(markdown_content):
    """Convert markdown to HTML"""

    # Extensions for better formatting
    html = markdown.markdown(
        markdown_content,
        extensions=[
            'extra',  # Tables, fenced code, etc.
            'nl2br',  # Newlines to <br>
            'sane_lists'  # Better list handling
        ]
    )

    # Wrap in full HTML document
    full_html = f'''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Resume</title>
    </head>
    <body>
        {html}
    </body>
    </html>
    '''

    return full_html
```

## Resume-Specific Styling

### Professional Resume CSS

```css
/* resume-style.css */

/* Page setup */
@page {
    size: letter;
    margin: 0.75in;
}

/* Typography */
body {
    font-family: 'Calibri', 'Arial', sans-serif;
    font-size: 11pt;
    line-height: 1.4;
    color: #000000;
}

/* Name header */
h1.name {
    font-size: 28pt;
    font-weight: bold;
    margin-bottom: 8pt;
    text-align: center;
    letter-spacing: 0.5pt;
}

/* Contact info */
.contact {
    text-align: center;
    font-size: 10pt;
    margin-bottom: 16pt;
}

.contact a {
    color: #0066cc;
    text-decoration: none;
}

/* Section headers */
h2 {
    font-size: 14pt;
    font-weight: bold;
    margin-top: 14pt;
    margin-bottom: 8pt;
    padding-bottom: 4pt;
    border-bottom: 2pt solid #333333;
    text-transform: uppercase;
    letter-spacing: 1pt;
}

/* Job titles and education */
h3 {
    font-size: 12pt;
    font-weight: bold;
    margin-top: 10pt;
    margin-bottom: 4pt;
}

/* Company/school details */
.details {
    font-size: 10pt;
    font-style: italic;
    color: #555555;
    margin-bottom: 6pt;
}

/* Bullet points */
ul {
    margin: 0 0 10pt 0;
    padding-left: 20pt;
    list-style-type: disc;
}

li {
    margin-bottom: 4pt;
}

/* Skills section */
.skills {
    margin-bottom: 8pt;
}

.skills strong {
    display: inline-block;
    min-width: 120pt;
}

/* Compact mode for long resumes */
.compact {
    font-size: 10pt;
    line-height: 1.3;
}

.compact h2 {
    margin-top: 12pt;
    margin-bottom: 6pt;
}

.compact ul {
    margin-bottom: 8pt;
}
```

## Template System

### Resume Templates

```python
class ResumeTemplate:
    """Base template for resume generation"""

    def __init__(self, content, style='professional'):
        self.content = content
        self.style = style

    def generate_pdf(self, output_path):
        """Generate PDF from content"""
        html = self.to_html()
        css = self.get_css()

        HTML(string=html).write_pdf(
            output_path,
            stylesheets=[CSS(string=css)]
        )

    def to_html(self):
        """Convert content to HTML"""
        # Parse YAML frontmatter
        metadata, body = parse_frontmatter(self.content)

        # Convert markdown to HTML
        html_body = markdown.markdown(body)

        # Apply template
        return self.apply_template(metadata, html_body)

    def apply_template(self, metadata, body):
        """Apply HTML template"""
        return f'''
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>{metadata.get('name', 'Resume')}</title>
        </head>
        <body>
            <header class="header">
                <h1 class="name">{metadata.get('name', '')}</h1>
                <div class="contact">
                    {metadata.get('email', '')} | {metadata.get('phone', '')} | {metadata.get('location', '')}
                    <br>
                    {self.format_links(metadata)}
                </div>
            </header>
            <main>
                {body}
            </main>
        </body>
        </html>
        '''

    def format_links(self, metadata):
        """Format professional links"""
        links = []
        if metadata.get('linkedin'):
            links.append(f'<a href="{metadata["linkedin"]}">LinkedIn</a>')
        if metadata.get('github'):
            links.append(f'<a href="{metadata["github"]}">GitHub</a>')
        if metadata.get('portfolio'):
            links.append(f'<a href="{metadata["portfolio"]}">Portfolio</a>')

        return ' | '.join(links)

    def get_css(self):
        """Get CSS based on style"""
        styles = {
            'professional': PROFESSIONAL_CSS,
            'modern': MODERN_CSS,
            'minimal': MINIMAL_CSS,
            'ats_optimized': ATS_OPTIMIZED_CSS
        }
        return styles.get(self.style, PROFESSIONAL_CSS)
```

## Quality Checks

### PDF Validation

```python
def validate_pdf(pdf_path):
    """Validate generated PDF for ATS compatibility"""

    issues = []

    reader = PdfReader(pdf_path)

    # Check if text is extractable
    try:
        text = ""
        for page in reader.pages:
            text += page.extract_text()

        if not text or len(text) < 100:
            issues.append("PDF text extraction failed - may be image-based")

    except Exception as e:
        issues.append(f"PDF parsing error: {str(e)}")

    # Check page count (resumes should be 1-2 pages)
    page_count = len(reader.pages)
    if page_count > 2:
        issues.append(f"Resume has {page_count} pages (recommend 1-2)")

    # Check file size (should be under 2MB)
    import os
    file_size_mb = os.path.getsize(pdf_path) / (1024 * 1024)
    if file_size_mb > 2:
        issues.append(f"File size {file_size_mb:.2f}MB exceeds 2MB recommendation")

    return {
        'is_valid': len(issues) == 0,
        'issues': issues,
        'page_count': page_count,
        'file_size_mb': round(file_size_mb, 2),
        'text_extractable': len(text) > 100 if 'text' in locals() else False
    }
```

## Best Practices

1. **Test text extraction** - Always verify text is selectable in generated PDF
2. **Embed fonts** - Ensure fonts render correctly on all systems
3. **Keep it simple** - ATS parsers prefer simple layouts
4. **Optimize file size** - Compress images, remove unnecessary metadata
5. **Use standard page sizes** - Letter (US) or A4 (International)
6. **Validate output** - Check PDF opens correctly in multiple viewers
7. **Consistent spacing** - Use CSS to ensure uniform margins and padding

## Integration Notes

- **Receives from:** resume-optimization (optimized markdown content)
- **Works with:** ats-scoring (validate PDF compatibility)
- **Outputs to:** application-tracking (final PDF for submission)
- **Requires:** Pandoc, WeasyPrint, or Puppeteer (choose based on needs)
