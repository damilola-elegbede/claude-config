---
name: resume-parsing
description: Expertise in PDF resume parsing and structured data extraction
---

# Resume Parsing Expertise

## Domain Focus

Expert knowledge in extracting structured information from PDF resumes, converting unstructured
documents into machine-readable formats for analysis and optimization.

## Core Capabilities

- PDF text extraction using pdfplumber, PyPDF2, and pdf-parse
- Section identification and classification (summary, experience, education, skills)
- Entity extraction (names, dates, companies, technologies)
- Format detection and handling (single-column, multi-column, tables)
- Character encoding and special character handling
- Layout analysis and visual structure understanding
- Conversion to structured formats (Markdown, JSON, YAML)
- Handling edge cases (scanned PDFs, custom layouts, graphics)

## When to Use This Skill

Invoke this skill when:

- Converting PDF resumes to editable formats
- Extracting structured data from resume PDFs
- Parsing applicant tracking system (ATS) resumes
- Building resume databases from PDF collections
- Analyzing resume sections and content
- Preparing resumes for optimization workflows

## Technical Approaches

### PDF Parsing Libraries

**Python Libraries:**

```python
import pdfplumber
import PyPDF2
from pdfminer.high_level import extract_text
import re

# pdfplumber - Best for layout analysis
with pdfplumber.open("resume.pdf") as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        tables = page.extract_tables()  # Handle tabular data

# PyPDF2 - Simple text extraction
with open("resume.pdf", "rb") as file:
    reader = PyPDF2.PdfReader(file)
    text = ""
    for page in reader.pages:
        text += page.extract_text()
```yaml

**Node.js Libraries:**
```javascript
const pdf = require('pdf-parse');
const fs = require('fs');

let dataBuffer = fs.readFileSync('resume.pdf');
pdf(dataBuffer).then(function(data) {
    console.log(data.text);
});
```yaml

### Section Detection Patterns

Common resume section headers to identify:

```python
SECTION_PATTERNS = {
    'summary': [
        r'(?i)^(professional\s+)?summary',
        r'(?i)^(career\s+)?objective',
        r'(?i)^profile',
        r'(?i)^about\s+me'
    ],
    'experience': [
        r'(?i)^(professional\s+)?experience',
        r'(?i)^(work\s+)?history',
        r'(?i)^employment',
        r'(?i)^career'
    ],
    'education': [
        r'(?i)^education',
        r'(?i)^academic',
        r'(?i)^qualifications'
    ],
    'skills': [
        r'(?i)^(technical\s+)?skills',
        r'(?i)^competencies',
        r'(?i)^expertise',
        r'(?i)^core\s+competencies'
    ],
    'certifications': [
        r'(?i)^certifications?',
        r'(?i)^licenses?',
        r'(?i)^credentials'
    ],
    'projects': [
        r'(?i)^projects?',
        r'(?i)^portfolio'
    ]
}
```python

### Entity Extraction Patterns

Extract specific entities from resume text:

```python
import re
from datetime import datetime

class ResumeParser:
    @staticmethod
    def extract_email(text):
        """Extract email addresses"""
        pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
        emails = re.findall(pattern, text)
        return emails[0] if emails else None

    @staticmethod
    def extract_phone(text):
        """Extract phone numbers"""
        patterns = [
            r'\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}',  # (555) 123-4567
            r'\+\d{1,3}[-.\s]?\d{3}[-.\s]?\d{3}[-.\s]?\d{4}'  # +1-555-123-4567
        ]
        for pattern in patterns:
            phones = re.findall(pattern, text)
            if phones:
                return phones[0]
        return None

    @staticmethod
    def extract_urls(text):
        """Extract URLs (LinkedIn, GitHub, portfolio)"""
        pattern = r'https?://(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&/=]*)'
        return re.findall(pattern, text)

    @staticmethod
    def extract_dates(text):
        """Extract date ranges (employment periods)"""
        patterns = [
            r'(\d{4})\s*[-–—]\s*(\d{4}|Present|Current)',  # 2020 - 2023
            r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\.?\s+\d{4}\s*[-–—]\s*(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\.?\s+\d{4}',  # Jan 2020 - Dec 2023
            r'(\d{1,2}/\d{4})\s*[-–—]\s*(\d{1,2}/\d{4}|Present)'  # 01/2020 - 12/2023
        ]
        dates = []
        for pattern in patterns:
            dates.extend(re.findall(pattern, text))
        return dates

    @staticmethod
    def extract_companies(text):
        """Extract company names (heuristic-based)"""
        # Look for patterns like "| Company Name |" or "at Company Name"
        patterns = [
            r'\|\s*([A-Z][A-Za-z\s&.,]+?)\s*\|',  # | TechCorp Inc. |
            r'\bat\s+([A-Z][A-Za-z\s&.,]+?)(?:\s+\||$)',  # at TechCorp
        ]
        companies = []
        for pattern in patterns:
            companies.extend(re.findall(pattern, text))
        return list(set(companies))  # Remove duplicates

    @staticmethod
    def extract_skills(text, skills_section):
        """Extract technical skills from skills section"""
        # Common separators: commas, bullets, pipes, newlines
        separators = r'[,•|●▪▸‣\n]'
        skills = re.split(separators, skills_section)
        # Clean and filter
        skills = [s.strip() for s in skills if s.strip()]
        # Remove common non-skill words
        skills = [s for s in skills if len(s) > 2 and s.lower() not in ['and', 'or', 'the']]
        return skills
```yaml

## Resume Structure Patterns

### Standard Resume Formats

**Single-Column Format:**
```yaml
[Header: Name, Contact]
[Summary]
[Experience]
  - Company 1
  - Company 2
[Education]
[Skills]
```yaml

**Two-Column Format:**
```yaml
[Left Column]          [Right Column]
- Skills               - Name
- Education            - Summary
- Certifications       - Experience
```yaml

**Hybrid Format:**
```yaml
[Full-width Header]
[Two columns: Summary | Skills]
[Full-width Experience]
[Two columns: Education | Certifications]
```yaml

### Markdown Output Template

```markdown
---
name: {{ name }}
email: {{ email }}
phone: {{ phone }}
location: {{ location }}
linkedin: {{ linkedin }}
github: {{ github }}
last_parsed: {{ timestamp }}
---

# {{ name }}

## Professional Summary

{{ summary }}

## Professional Experience

{{ for experience in experiences }}
### {{ experience.title }} | {{ experience.company }} | {{ experience.dates }}

{{ experience.description }}

{{ for bullet in experience.bullets }}
- {{ bullet }}
{{ endfor }}

**Technologies:** {{ experience.technologies }}

{{ endfor }}

## Education

{{ for edu in education }}
**{{ edu.degree }}** | {{ edu.institution }} | {{ edu.year }}
{{ endfor }}

## Skills

{{ skills }}

## Certifications

{{ for cert in certifications }}
- {{ cert }}
{{ endfor }}
```python

## Handling Edge Cases

### Scanned PDFs (OCR Required)

```python
from PIL import Image
import pytesseract
from pdf2image import convert_from_path

def ocr_pdf(pdf_path):
    """Extract text from scanned PDF using OCR"""
    # Convert PDF to images
    images = convert_from_path(pdf_path)

    text = ""
    for image in images:
        # Perform OCR
        text += pytesseract.image_to_string(image)

    return text
```python

### Multi-Column Layouts

```python
def extract_with_layout(pdf_path):
    """Preserve layout information for multi-column detection"""
    import pdfplumber

    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            # Get character positions
            chars = page.chars

            # Cluster by x-coordinate to detect columns
            left_column = [c for c in chars if c['x0'] < page.width / 2]
            right_column = [c for c in chars if c['x0'] >= page.width / 2]

            # Extract text from each column
            left_text = extract_text_from_chars(left_column)
            right_text = extract_text_from_chars(right_column)

            return left_text, right_text
```python

### Table Extraction

```python
def extract_tables(pdf_path):
    """Extract tabular data from resumes"""
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            tables = page.extract_tables()

            for table in tables:
                # Process table data
                # Often used for skills matrices or project lists
                process_table(table)
```python

## Validation and Quality Checks

### Parsed Resume Validation

```python
class ResumeValidator:
    @staticmethod
    def validate_parsed_resume(resume_data):
        """Validate that critical fields were extracted"""
        required_fields = ['name', 'email', 'experience']
        missing_fields = []

        for field in required_fields:
            if not resume_data.get(field):
                missing_fields.append(field)

        return {
            'is_valid': len(missing_fields) == 0,
            'missing_fields': missing_fields,
            'completeness_score': calculate_completeness(resume_data)
        }

    @staticmethod
    def calculate_completeness(resume_data):
        """Calculate how complete the parsed data is (0-100%)"""
        all_fields = [
            'name', 'email', 'phone', 'location',
            'linkedin', 'github', 'summary',
            'experience', 'education', 'skills'
        ]

        present_fields = sum(1 for f in all_fields if resume_data.get(f))
        return (present_fields / len(all_fields)) * 100
```text

## Best Practices

1. **Try multiple extraction methods** - Different libraries work better for different formats
2. **Preserve formatting cues** - Bold, italics, and indentation often indicate structure
3. **Use regex conservatively** - Over-reliance on regex can make parsing brittle
4. **Validate extracted data** - Check that dates, emails, and phones are well-formed
5. **Handle missing sections gracefully** - Not all resumes have all sections
6. **Test with diverse resume formats** - Single/multi-column, modern/traditional, creative/standard
7. **Consider OCR for scanned PDFs** - Use Tesseract or cloud OCR services
8. **Preserve original PDF** - Keep reference to source document

## Common Challenges

**Challenge:** Multi-column layouts break text extraction order
**Solution:** Use pdfplumber's layout analysis to detect columns, extract separately

**Challenge:** Scanned PDFs have no extractable text
**Solution:** Use OCR (Tesseract, AWS Textract, Google Cloud Vision)

**Challenge:** Special characters and formatting lost
**Solution:** Normalize Unicode, preserve markdown formatting where possible

**Challenge:** Date formats vary widely
**Solution:** Use dateparser library or comprehensive regex patterns

**Challenge:** Section headers not standardized
**Solution:** Use fuzzy matching and multiple patterns per section type

## Integration Notes

- **Works with:** resume-optimization (provides structured input)
- **Works with:** ats-scoring (structured resume for analysis)
- **Feeds into:** application-tracking (candidate data extraction)
- **Complements:** pdf-generation (reverse operation)
- **Requires:** Python PDF libraries (pdfplumber, PyPDF2) or Node.js alternatives
