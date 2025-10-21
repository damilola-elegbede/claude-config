---
name: job-description-analysis
description: Expertise in job description parsing, requirement extraction, and keyword analysis
---

# Job Description Analysis Expertise

## Domain Focus

Expert knowledge in analyzing job descriptions to extract requirements, skills, keywords, and hidden
insights for effective resume optimization and interview preparation.

## Core Capabilities

- Job description parsing and structure analysis
- Required vs. preferred skills classification
- Keyword and phrase extraction
- Responsibility and expectation identification
- Experience level and seniority detection
- Company culture and values inference
- Compensation and benefits analysis
- Red flag identification
- Multi-source JD aggregation (job boards, company sites)
- Requirement prioritization and weighting

## When to Use This Skill

Invoke this skill when:

- Analyzing job postings for resume tailoring
- Extracting requirements from job descriptions
- Identifying keywords for ATS optimization
- Understanding role expectations and responsibilities
- Detecting experience level and seniority requirements
- Preparing for interviews based on JD insights
- Comparing similar role postings across companies

## Job Description Structure

### Standard JD Sections

```yaml
Typical Sections:
  - Company Overview: Mission, values, culture
  - Role Summary: High-level description
  - Responsibilities: Day-to-day duties
  - Requirements: Must-have qualifications
  - Preferred Qualifications: Nice-to-have skills
  - Benefits & Perks: Compensation, culture
  - Application Instructions: How to apply

Variations:
  - Some combine Required + Preferred
  - Some use "About You" instead of "Requirements"
  - Some lead with "What You'll Do"
  - Startups often more informal, enterprises more structured
```

### Parsing Patterns

```python
import re

class JobDescriptionParser:
    SECTION_PATTERNS = {
        'responsibilities': [
            r'(?i)(responsibilities|what you\'ll do|duties|role description)',
            r'(?i)(you will|your role|day to day)'
        ],
        'requirements': [
            r'(?i)(requirements|qualifications|what we\'re looking for)',
            r'(?i)(you have|you bring|must have|required)'
        ],
        'preferred': [
            r'(?i)(preferred|nice to have|bonus|ideal)',
            r'(?i)(plus|additionally|we\'d love if)'
        ],
        'benefits': [
            r'(?i)(benefits|perks|compensation|what we offer)',
            r'(?i)(salary|equity|health|401k)'
        ],
        'company': [
            r'(?i)(about us|about \w+|our mission|who we are)',
            r'(?i)(company overview|our story)'
        ]
    }

    def parse_jd(self, jd_text):
        """Parse JD into structured sections"""
        sections = {}

        for section_name, patterns in self.SECTION_PATTERNS.items():
            for pattern in patterns:
                match = re.search(pattern, jd_text)
                if match:
                    # Extract text after section header until next header
                    start = match.end()
                    content = self._extract_section_content(jd_text, start)
                    sections[section_name] = content
                    break

        return sections
```

## Requirement Classification

### Required vs. Preferred Skills

**Identifying Required Skills:**

```python
def classify_requirements(requirements_text):
    """Classify requirements as required or preferred"""

    required_indicators = [
        'must have', 'required', 'essential', 'mandatory',
        'minimum', 'you have', 'you bring', 'you possess'
    ]

    preferred_indicators = [
        'preferred', 'nice to have', 'bonus', 'ideal',
        'plus', 'would be great', 'we\'d love'
    ]

    lines = requirements_text.split('\n')
    classified = {
        'required': [],
        'preferred': []
    }

    for line in lines:
        line_lower = line.lower()

        if any(indicator in line_lower for indicator in required_indicators):
            classified['required'].append(line.strip())
        elif any(indicator in line_lower for indicator in preferred_indicators):
            classified['preferred'].append(line.strip())
        else:
            # Default to required if in main requirements section
            classified['required'].append(line.strip())

    return classified
```

### Experience Level Detection

```python
def detect_experience_level(jd_text):
    """Determine seniority level from JD"""

    jd_lower = jd_text.lower()

    # Look for explicit mentions
    if re.search(r'\d+\+?\s*years', jd_lower):
        years_match = re.search(r'(\d+)\+?\s*years', jd_lower)
        years = int(years_match.group(1))

        if years >= 10:
            return 'senior', years
        elif years >= 5:
            return 'mid', years
        else:
            return 'junior', years

    # Look for title indicators
    level_indicators = {
        'junior': ['junior', 'entry level', 'early career'],
        'mid': ['mid level', 'intermediate'],
        'senior': ['senior', 'staff', 'principal', 'lead'],
        'leadership': ['manager', 'director', 'vp', 'head of', 'chief']
    }

    for level, keywords in level_indicators.items():
        if any(keyword in jd_lower for keyword in keywords):
            return level, None

    return 'mid', None  # Default to mid-level
```

## Keyword Extraction

### Technical Skills Extraction

```python
TECHNICAL_SKILL_PATTERNS = {
    'languages': [
        'Python', 'Java', 'JavaScript', 'TypeScript', 'Go', 'Ruby',
        'C++', 'C#', 'Rust', 'Scala', 'Kotlin', 'Swift', 'PHP'
    ],
    'frameworks': [
        'React', 'Angular', 'Vue', 'Django', 'Flask', 'Spring',
        'Rails', 'Node.js', 'Express', '.NET', 'Laravel'
    ],
    'databases': [
        'PostgreSQL', 'MySQL', 'MongoDB', 'Redis', 'Cassandra',
        'Elasticsearch', 'DynamoDB', 'Oracle', 'SQL Server'
    ],
    'cloud': [
        'AWS', 'Azure', 'GCP', 'Kubernetes', 'Docker', 'Terraform',
        'CloudFormation', 'Lambda', 'EC2', 'S3', 'ECS', 'EKS'
    ],
    'tools': [
        'Git', 'Jenkins', 'CircleCI', 'GitHub Actions', 'Jira',
        'Confluence', 'Datadog', 'New Relic', 'Splunk'
    ],
    'methodologies': [
        'Agile', 'Scrum', 'Kanban', 'DevOps', 'CI/CD', 'TDD',
        'Microservices', 'REST API', 'GraphQL'
    ]
}

def extract_technical_skills(jd_text):
    """Extract technical skills mentioned in JD"""
    found_skills = {}

    for category, skills in TECHNICAL_SKILL_PATTERNS.items():
        found_skills[category] = []
        for skill in skills:
            # Case-insensitive search, word boundary
            if re.search(rf'\b{re.escape(skill)}\b', jd_text, re.IGNORECASE):
                found_skills[category].append(skill)

    return found_skills
```

### Leadership & Soft Skills Extraction

```python
LEADERSHIP_PATTERNS = {
    'team_management': [
        'manage team', 'lead team', 'build team', 'hire',
        'mentor', 'coach', 'direct reports', 'people management'
    ],
    'strategy': [
        'strategic planning', 'roadmap', 'vision', 'long-term',
        'business strategy', 'technical strategy'
    ],
    'communication': [
        'stakeholder management', 'executive presence',
        'written communication', 'presentation', 'cross-functional'
    ],
    'execution': [
        'deliver results', 'accountability', 'ownership',
        'drive initiatives', 'project management'
    ]
}

def extract_leadership_requirements(jd_text):
    """Extract leadership and soft skill requirements"""
    jd_lower = jd_text.lower()
    leadership_skills = {}

    for category, patterns in LEADERSHIP_PATTERNS.items():
        matches = []
        for pattern in patterns:
            if pattern.lower() in jd_lower:
                matches.append(pattern)

        if matches:
            leadership_skills[category] = matches

    return leadership_skills
```

## Keyword Frequency and Importance

### Weighted Keyword Analysis

```python
from collections import Counter

def analyze_keyword_importance(jd_text):
    """Calculate keyword importance based on frequency and position"""

    # Extract all potential keywords (2+ word ngrams)
    words = re.findall(r'\b[A-Za-z]{3,}\b', jd_text.lower())
    bigrams = [' '.join(words[i:i+2]) for i in range(len(words)-1)]
    trigrams = [' '.join(words[i:i+3]) for i in range(len(words)-2)]

    # Count frequencies
    word_freq = Counter(words)
    bigram_freq = Counter(bigrams)

    # Weight by section (requirements section = higher weight)
    sections = parse_jd_sections(jd_text)
    requirements_text = sections.get('requirements', '')

    weighted_keywords = {}
    for keyword, freq in word_freq.most_common(50):
        # Check if appears in requirements (2x weight)
        weight = freq
        if keyword in requirements_text.lower():
            weight *= 2

        weighted_keywords[keyword] = weight

    return dict(sorted(weighted_keywords.items(), key=lambda x: x[1], reverse=True))
```

## Hidden Insights

### Culture and Values Detection

```python
def infer_company_culture(jd_text):
    """Infer company culture from JD language"""

    culture_signals = {
        'fast_paced': ['fast-paced', 'move quickly', 'rapid growth', 'dynamic'],
        'innovative': ['innovative', 'cutting-edge', 'pioneering', 'disruptive'],
        'collaborative': ['collaborative', 'team player', 'cross-functional'],
        'autonomous': ['autonomous', 'self-directed', 'independent', 'ownership'],
        'structured': ['process', 'established', 'enterprise', 'governance'],
        'mission_driven': ['mission', 'impact', 'purpose', 'make a difference']
    }

    jd_lower = jd_text.lower()
    detected_culture = {}

    for trait, keywords in culture_signals.items():
        score = sum(jd_lower.count(keyword) for keyword in keywords)
        if score > 0:
            detected_culture[trait] = score

    return dict(sorted(detected_culture.items(), key=lambda x: x[1], reverse=True))
```

### Red Flag Detection

```python
def detect_red_flags(jd_text):
    """Identify potential red flags in JD"""

    red_flags = []

    # Vague or unrealistic expectations
    if re.search(r'\d{1,2}\+\s*years.{0,50}entry.level', jd_text, re.IGNORECASE):
        red_flags.append("Unrealistic experience requirements for level")

    # Wear many hats (potential role ambiguity)
    if re.search(r'wear many hats|jack of all trades', jd_text, re.IGNORECASE):
        red_flags.append("Role may lack clear focus")

    # Unpaid overtime signals
    if re.search(r'work hard play hard|whatever it takes|startup hours', jd_text, re.IGNORECASE):
        red_flags.append("Possible work-life balance concerns")

    # Excessive requirement lists
    requirements = extract_requirements(jd_text)
    if len(requirements.get('required', [])) > 15:
        red_flags.append("Unreasonably long requirements list (> 15 items)")

    # Compensation not mentioned
    if not re.search(r'salary|compensation|\$\d|equity', jd_text, re.IGNORECASE):
        red_flags.append("No compensation information provided")

    return red_flags
```

## Multi-Source JD Extraction

### Job Board URL Handlers

```python
import requests
from playwright.sync_api import sync_playwright

class JDFetcher:
    def fetch_jd(self, url):
        """Fetch JD from various job board URLs"""

        if 'linkedin.com' in url:
            return self._fetch_linkedin(url)
        elif 'indeed.com' in url:
            return self._fetch_indeed(url)
        elif 'greenhouse.io' in url:
            return self._fetch_greenhouse(url)
        elif 'lever.co' in url:
            return self._fetch_lever(url)
        else:
            return self._fetch_generic(url)

    def _fetch_linkedin(self, url):
        """Fetch from LinkedIn Jobs (requires browser automation)"""
        with sync_playwright() as p:
            browser = p.chromium.launch()
            page = browser.new_page()
            page.goto(url)

            # Wait for JD to load
            page.wait_for_selector('.description__text')

            jd_text = page.query_selector('.description__text').inner_text()
            browser.close()

            return jd_text

    def _fetch_greenhouse(self, url):
        """Fetch from Greenhouse (usually simple HTML)"""
        response = requests.get(url)
        from bs4 import BeautifulSoup

        soup = BeautifulSoup(response.content, 'html.parser')
        jd_div = soup.find('div', {'id': 'content'})

        return jd_div.get_text(separator='\n') if jd_div else ""
```

## Comprehensive Analysis Output

```python
def comprehensive_jd_analysis(jd_url):
    """Perform full JD analysis"""

    # Fetch JD
    jd_text = fetch_jd_from_url(jd_url)

    # Parse into sections
    sections = parse_jd_sections(jd_text)

    # Extract skills
    technical_skills = extract_technical_skills(jd_text)
    leadership_skills = extract_leadership_requirements(jd_text)

    # Classify requirements
    requirements = classify_requirements(sections.get('requirements', ''))

    # Analyze keywords
    keyword_importance = analyze_keyword_importance(jd_text)

    # Detect level
    experience_level, years = detect_experience_level(jd_text)

    # Infer culture
    culture = infer_company_culture(jd_text)

    # Check for red flags
    red_flags = detect_red_flags(jd_text)

    return {
        'url': jd_url,
        'sections': sections,
        'skills': {
            'technical': technical_skills,
            'leadership': leadership_skills
        },
        'requirements': requirements,
        'keywords': keyword_importance,
        'experience_level': experience_level,
        'years_required': years,
        'culture_signals': culture,
        'red_flags': red_flags,
        'priority_keywords': list(keyword_importance.keys())[:20]  # Top 20
    }
```

## Best Practices

1. **Read between the lines** - Culture clues are often subtle
2. **Prioritize by frequency** - Keywords repeated multiple times are critical
3. **Context matters** - Same keyword in different sections has different weight
4. **Check multiple sources** - Compare JD across LinkedIn, company site, Indeed
5. **Note what's missing** - Lack of compensation or benefits can be telling
6. **Track changes** - JDs updated over time reveal hiring urgency

## Integration Notes

- **Feeds into:** resume-optimization (provides keyword targets)
- **Feeds into:** ats-scoring (requirement matching)
- **Feeds into:** cover-letter-writing (address specific requirements)
- **Feeds into:** interview-preparation (prep for discussed topics)
- **Works with:** company-research (cross-reference culture signals)
- **Works with:** web-scraping (multi-source JD fetching)
