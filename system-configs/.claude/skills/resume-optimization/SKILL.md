---
name: resume-optimization
description: Expertise in ATS optimization, keyword matching, and resume tailoring
---

# Resume Optimization Expertise

## Domain Focus

Expert knowledge in optimizing resumes for Applicant Tracking Systems (ATS), maximizing keyword
relevance, and tailoring content to specific job descriptions for maximum impact.

## Core Capabilities

- ATS compatibility analysis and optimization
- Keyword extraction and strategic placement
- Job description requirement mapping
- Resume tailoring for specific roles
- Skills alignment and gap analysis
- Bullet point optimization for impact
- Action verb selection and variety
- Quantifiable achievement identification
- Section ordering and emphasis
- Format optimization for parsability

## When to Use This Skill

Invoke this skill when:

- Tailoring resumes for specific job descriptions
- Optimizing resumes for ATS systems
- Improving keyword density and relevance
- Rewriting experience bullets for impact
- Aligning skills with job requirements
- Maximizing ATS compatibility scores
- Prioritizing relevant experiences

## ATS Optimization Principles

### ATS-Friendly Formatting Rules

```yaml
DO:
  - Use standard section headers (Experience, Education, Skills)
  - Use simple, clean fonts (Arial, Calibri, Times New Roman)
  - Use standard bullet points (• or -)
  - Include keywords from job description naturally
  - Use chronological format (most recent first)
  - Include dates in consistent format (YYYY-MM or Month YYYY)
  - Save as .docx or .pdf (text-based, not scanned)
  - Use full words and common acronyms

DON'T:
  - Use tables, text boxes, or columns (may break parsing)
  - Use headers/footers for critical information
  - Use images, logos, or graphics
  - Use fancy fonts or heavy styling
  - Use unconventional section names
  - Rely solely on formatting (bold, italics) for structure
  - Use abbreviations without spelling out first
```python

### Keyword Optimization Strategy

**Keyword Extraction from Job Description:**

```python
from collections import Counter
import re

class KeywordExtractor:
    STOP_WORDS = {'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for'}

    def extract_keywords(self, job_description):
        """Extract important keywords and phrases from JD"""
        # Extract skills and technologies
        technical_keywords = self._extract_technical_terms(job_description)

        # Extract action verbs and responsibilities
        action_keywords = self._extract_action_terms(job_description)

        # Extract domain-specific terms
        domain_keywords = self._extract_domain_terms(job_description)

        return {
            'technical': technical_keywords,
            'action': action_keywords,
            'domain': domain_keywords,
            'all': technical_keywords + action_keywords + domain_keywords
        }

    def calculate_keyword_density(self, resume, keywords):
        """Calculate how well resume matches JD keywords"""
        resume_lower = resume.lower()

        matches = {}
        for keyword in keywords:
            count = resume_lower.count(keyword.lower())
            matches[keyword] = count

        # Calculate overall density score
        total_keywords = len(keywords)
        matched_keywords = sum(1 for count in matches.values() if count > 0)

        return {
            'matches': matches,
            'match_rate': matched_keywords / total_keywords if total_keywords > 0 else 0,
            'missing_keywords': [k for k, v in matches.items() if v == 0]
        }
```python

### Resume Tailoring Workflow

**1. Analyze Job Requirements:**
```python
def analyze_job_requirements(job_description):
    """Break down JD into structured requirements"""
    return {
        'must_have_skills': extract_required_skills(job_description),
        'nice_to_have_skills': extract_preferred_skills(job_description),
        'responsibilities': extract_responsibilities(job_description),
        'keywords': extract_keywords(job_description),
        'experience_level': detect_experience_level(job_description),
        'leadership_required': detect_leadership_requirements(job_description)
    }
```python

**2. Match Experiences to Requirements:**
```python
def select_relevant_experiences(base_resume, job_requirements):
    """Select and order experiences most relevant to JD"""
    experiences = base_resume['experiences']
    scored_experiences = []

    for exp in experiences:
        relevance_score = calculate_relevance(exp, job_requirements)
        scored_experiences.append((exp, relevance_score))

    # Sort by relevance, keep top experiences
    scored_experiences.sort(key=lambda x: x[1], reverse=True)

    return [exp for exp, score in scored_experiences[:5]]  # Keep top 5
```python

**3. Optimize Bullet Points:**
```python
def optimize_bullets(experience, job_requirements):
    """Rewrite bullets to match JD keywords and emphasis"""
    optimized_bullets = []

    for bullet in experience['bullets']:
        # Add relevant keywords naturally
        optimized = inject_keywords(bullet, job_requirements['keywords'])

        # Ensure action verb + quantifiable result
        optimized = ensure_quantifiable(optimized)

        # Match tone to JD
        optimized = match_tone(optimized, job_requirements)

        optimized_bullets.append(optimized)

    return optimized_bullets
```yaml

## Impact-Focused Bullet Points

### Formula: Action Verb + Task + Quantifiable Result

**Before (Generic):**
> Managed engineering team and delivered projects

**After (Optimized):**
> Led 15-engineer team through microservices migration, reducing deployment time 88% and achieving 99.95% uptime

### Power Verbs by Category

**Leadership:**
- Led, Directed, Managed, Mentored, Coached, Guided, Championed, Spearheaded

**Achievement:**
- Delivered, Achieved, Exceeded, Accomplished, Attained, Surpassed

**Technical:**
- Architected, Designed, Engineered, Developed, Implemented, Built, Optimized

**Strategy:**
- Established, Initiated, Founded, Pioneered, Launched, Drove, Shaped

**Improvement:**
- Improved, Enhanced, Streamlined, Automated, Reduced, Increased, Accelerated

**Collaboration:**
- Collaborated, Partnered, Coordinated, Aligned, Facilitated, Unified

### Quantification Strategies

**Metrics to Include:**
```yaml
Scale:
  - Team size: "Led team of 25 engineers"
  - User base: "Platform serving 10M+ users"
  - Revenue: "System processing $500M+ annual transactions"
  - Budget: "Managed $5M annual budget"

Impact:
  - Performance: "Improved latency by 60%"
  - Cost: "Reduced cloud costs by 40% ($2M savings)"
  - Speed: "Reduced deployment time from 2 hours to 15 minutes"
  - Quality: "Increased uptime from 99.5% to 99.95%"

Outcomes:
  - Efficiency: "Automated process saving 100 hours/month"
  - Growth: "Grew team from 8 to 25 engineers"
  - Success: "Delivered 15 projects on time, zero production incidents"
```yaml

**Converting Vague to Specific:**
```yaml
Vague: "Improved system performance"
Specific: "Reduced API response time 75% (400ms → 100ms), handling 10x traffic increase"

Vague: "Managed team of engineers"
Specific: "Led 25-engineer team across 3 time zones, maintaining 95% retention rate"

Vague: "Built microservices platform"
Specific: "Architected cloud-native platform with 50+ microservices, supporting 25M users with 99.95% SLA"
```yaml

## Keyword Integration Techniques

### Natural Keyword Placement

**Job Requirement:** "Experience with Kubernetes and container orchestration"

**Poor Integration (Keyword Stuffing):**
> Used Kubernetes and container orchestration. Worked with Kubernetes container orchestration daily.

**Good Integration (Natural):**
> Led migration to Kubernetes-based container orchestration, managing 200+ microservices with automated deployment pipelines and 99.95% uptime

### Skills Section Optimization

**Match JD Skills Exactly:**

Job Description mentions: "Python, Kubernetes, AWS, PostgreSQL, Kafka"

Your Resume Skills Section:
```yaml
Technical Skills:
• Languages: Python, Go, Java
• Cloud & Infrastructure: AWS (EC2, S3, Lambda, RDS), Kubernetes, Docker, Terraform
• Data: PostgreSQL, MySQL, Redis, Kafka, Elasticsearch
• Tools: Git, CI/CD, Jenkins, GitHub Actions
```yaml

**Prioritize by Relevance:**
- List JD keywords first in each category
- Use exact terminology from JD when possible
- Group related technologies together
- Include proficiency levels if appropriate

## Section Ordering for Impact

### For Engineering Manager Roles:
```markdown
1. Professional Summary (leadership-focused)
2. Core Competencies (mix technical + leadership)
3. Professional Experience (emphasize management)
4. Education
5. Certifications & Awards
6. Publications & Speaking (if relevant)
```text

### For Technical Leadership (Staff+):
```markdown
1. Professional Summary (technical depth + impact)
2. Core Technical Expertise (prominent)
3. Professional Experience (technical achievements)
4. Technical Thought Leadership (publications, OSS)
5. Education
6. Certifications
```yaml

### For Director+ Roles:
```markdown
1. Executive Summary (strategic focus)
2. Leadership Competencies
3. Professional Experience (organizational impact)
4. Education & Executive Training
5. Board Positions / Advisory Roles (if any)
```python

## Gap Analysis and Mitigation

### Identifying Gaps

```python
def analyze_skills_gap(resume, job_requirements):
    """Identify what's missing from resume vs JD"""
    resume_skills = set(extract_skills(resume))
    required_skills = set(job_requirements['must_have_skills'])
    preferred_skills = set(job_requirements['nice_to_have_skills'])

    return {
        'missing_required': required_skills - resume_skills,
        'missing_preferred': preferred_skills - resume_skills,
        'gap_severity': calculate_gap_severity(resume_skills, required_skills),
        'recommendations': generate_gap_recommendations(resume_skills, required_skills)
    }
```yaml

### Addressing Gaps

**When you have the skill but didn't mention it:**
> Add to skills section and weave into relevant experience bullets

**When you have related/transferable skill:**
> "Experience with distributed databases (Cassandra) - easily transferable to PostgreSQL at scale"

**When skill is learnable:**
> Add to "Currently Exploring" section or mention in cover letter

## ATS Scoring Algorithm

```python
def calculate_ats_score(resume, job_description):
    """Calculate ATS compatibility score (0-100)"""

    # 1. Keyword Matching (50% weight)
    keywords = extract_keywords(job_description)
    keyword_match_score = calculate_keyword_density(resume, keywords['all'])

    # 2. Formatting (20% weight)
    format_score = check_ats_format(resume)

    # 3. Skills Alignment (20% weight)
    skills_score = calculate_skills_alignment(resume, job_description)

    # 4. Structure (10% weight)
    structure_score = check_resume_structure(resume)

    total_score = (
        keyword_match_score * 0.5 +
        format_score * 0.2 +
        skills_score * 0.2 +
        structure_score * 0.1
    ) * 100

    return {
        'total_score': round(total_score, 1),
        'breakdown': {
            'keyword_match': round(keyword_match_score * 100, 1),
            'formatting': round(format_score * 100, 1),
            'skills_alignment': round(skills_score * 100, 1),
            'structure': round(structure_score * 100, 1)
        },
        'recommendations': generate_improvement_recommendations(
            keyword_match_score, format_score, skills_score, structure_score
        )
    }
```yaml

## Optimization Checklist

Before submitting, verify:

- [ ] All required keywords from JD included naturally
- [ ] Every bullet has action verb + quantifiable result
- [ ] Most relevant experiences listed first
- [ ] Skills section matches JD requirements exactly
- [ ] Formatting is ATS-friendly (no tables, columns)
- [ ] Dates are consistent format throughout
- [ ] Section headers are standard
- [ ] File format is .docx or text-based .pdf
- [ ] ATS score is 90%+ for this specific JD
- [ ] No generic bullets - all tailored to role
- [ ] Company-specific research reflected (if applicable)

## Best Practices

1. **Tailor for each application** - Never submit generic resume
2. **Use JD language** - Mirror terminology used in job description
3. **Lead with impact** - Most impressive achievements first
4. **Quantify everything** - Numbers make impact concrete
5. **Balance keywords with readability** - Natural flow, not keyword stuffing
6. **Test with ATS scanners** - Use tools like Jobscan before submitting
7. **Keep formatting simple** - When in doubt, simpler is better for ATS

## Integration Notes

- **Works with:** job-description-analysis (provides keyword insights)
- **Works with:** ats-scoring (validates optimization effectiveness)
- **Works with:** resume-parsing (structured resume input)
- **Feeds into:** pdf-generation (optimized resume output)
- **Complements:** cover-letter-writing (consistent messaging)
