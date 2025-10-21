---
name: ats-scoring
description: Expertise in calculating and improving ATS compatibility scores
---

# ATS Scoring Expertise

## Domain Focus

Expert knowledge in Applicant Tracking System (ATS) algorithms, scoring methodologies, and optimization strategies to maximize resume compatibility and pass-through rates.

## Core Capabilities

- ATS compatibility scoring (0-100%)
- Keyword density analysis
- Format compatibility checking
- Skills alignment calculation
- Section structure validation
- Parsing simulation
- Improvement recommendation generation
- Competitive benchmarking
- Score breakdown and explanation
- Iterative optimization

## When to Use This Skill

Invoke this skill when:

- Scoring resume against job description
- Validating resume ATS compatibility
- Identifying optimization opportunities
- Comparing multiple resume versions
- Testing resume before submission
- Explaining why score is low/high
- Benchmarking against target score (90%+)

## ATS Scoring Algorithm

### Comprehensive Scoring Model

```python
class ATSScorer:
    """Calculate ATS compatibility score"""

    # Scoring weights
    WEIGHTS = {
        'keyword_match': 0.50,      # 50% - Most critical
        'skills_alignment': 0.20,    # 20% - Technical fit
        'formatting': 0.20,          # 20% - Parsability
        'structure': 0.10            # 10% - Organization
    }

    def calculate_score(self, resume, job_description):
        """Calculate overall ATS score (0-100)"""

        scores = {
            'keyword_match': self.score_keyword_match(resume, job_description),
            'skills_alignment': self.score_skills_alignment(resume, job_description),
            'formatting': self.score_formatting(resume),
            'structure': self.score_structure(resume)
        }

        # Calculate weighted total
        total_score = sum(
            scores[category] * self.WEIGHTS[category]
            for category in scores
        ) * 100

        return {
            'total_score': round(total_score, 1),
            'breakdown': {k: round(v * 100, 1) for k, v in scores.items()},
            'grade': self.get_grade(total_score),
            'pass_probability': self.estimate_pass_probability(total_score),
            'recommendations': self.generate_recommendations(scores)
        }

    def get_grade(self, score):
        """Convert score to letter grade"""
        if score >= 90: return 'A'
        if score >= 80: return 'B'
        if score >= 70: return 'C'
        if score >= 60: return 'D'
        return 'F'

    def estimate_pass_probability(self, score):
        """Estimate probability of passing ATS"""
        if score >= 90: return '90-95%'
        if score >= 80: return '70-80%'
        if score >= 70: return '50-60%'
        if score >= 60: return '30-40%'
        return '<20%'
```

## Keyword Match Scoring

### Keyword Extraction and Matching

```python
def score_keyword_match(self, resume, jd):
    """Score based on keyword matching (0-1.0)"""

    # Extract keywords from JD
    jd_keywords = self.extract_keywords(jd)

    # Categorize by importance
    critical_keywords = jd_keywords['critical']  # Must-have skills
    important_keywords = jd_keywords['important']  # Preferred skills
    nice_to_have = jd_keywords['nice_to_have']  # Bonus skills

    # Check resume coverage
    resume_lower = resume.lower()

    critical_score = self._calculate_category_score(
        resume_lower, critical_keywords, weight=1.0
    )
    important_score = self._calculate_category_score(
        resume_lower, important_keywords, weight=0.7
    )
    nice_score = self._calculate_category_score(
        resume_lower, nice_to_have, weight=0.3
    )

    # Weighted average
    total_score = (
        critical_score * 0.60 +
        important_score * 0.30 +
        nice_score * 0.10
    )

    return total_score

def _calculate_category_score(self, resume, keywords, weight=1.0):
    """Calculate match score for keyword category"""
    if not keywords:
        return 1.0  # No keywords = perfect score

    matches = sum(1 for kw in keywords if kw.lower() in resume)
    match_rate = matches / len(keywords)

    # Apply weight
    return match_rate * weight
```

### Keyword Density Analysis

```python
def analyze_keyword_density(self, resume, keywords):
    """Analyze keyword frequency in resume"""

    resume_lower = resume.lower()
    density = {}

    for keyword in keywords:
        count = resume_lower.count(keyword.lower())
        density[keyword] = {
            'count': count,
            'present': count > 0,
            'optimal': 1 <= count <= 4,  # Appears 1-4 times (not stuffing)
            'status': self._get_density_status(count)
        }

    return density

def _get_density_status(self, count):
    """Determine if keyword density is optimal"""
    if count == 0:
        return 'missing'
    elif count == 1:
        return 'minimal'
    elif 2 <= count <= 4:
        return 'optimal'
    else:
        return 'excessive'  # Keyword stuffing
```

## Skills Alignment Scoring

```python
def score_skills_alignment(self, resume, jd):
    """Score based on skills alignment (0-1.0)"""

    # Extract required and preferred skills from JD
    jd_skills = extract_skills(jd)
    required_skills = jd_skills['required']
    preferred_skills = jd_skills['preferred']

    # Extract skills from resume
    resume_skills = extract_skills_from_resume(resume)

    # Calculate coverage
    required_coverage = self._calculate_skill_coverage(
        resume_skills, required_skills
    )
    preferred_coverage = self._calculate_skill_coverage(
        resume_skills, preferred_skills
    )

    # Weighted score (required = 80%, preferred = 20%)
    score = (required_coverage * 0.8) + (preferred_coverage * 0.2)

    return score

def _calculate_skill_coverage(self, resume_skills, required_skills):
    """Calculate what % of required skills are present"""
    if not required_skills:
        return 1.0

    matched = sum(
        1 for skill in required_skills
        if self._skill_match(skill, resume_skills)
    )

    return matched / len(required_skills)

def _skill_match(self, required_skill, resume_skills):
    """Check if skill is present (with fuzzy matching)"""
    # Exact match
    if required_skill.lower() in [s.lower() for s in resume_skills]:
        return True

    # Fuzzy match (e.g., "JavaScript" matches "JS")
    synonyms = {
        'javascript': ['js', 'node.js', 'nodejs'],
        'python': ['py'],
        'kubernetes': ['k8s'],
        # Add more synonyms
    }

    skill_lower = required_skill.lower()
    if skill_lower in synonyms:
        return any(
            syn in [s.lower() for s in resume_skills]
            for syn in synonyms[skill_lower]
        )

    return False
```

## Formatting Scoring

### ATS-Friendly Format Checks

```python
def score_formatting(self, resume):
    """Score formatting for ATS compatibility (0-1.0)"""

    checks = {
        'uses_standard_fonts': self._check_standard_fonts(resume),
        'no_tables': not self._contains_tables(resume),
        'no_text_boxes': not self._contains_text_boxes(resume),
        'no_headers_footers': not self._has_header_footer_content(resume),
        'consistent_date_format': self._check_date_consistency(resume),
        'standard_bullets': self._check_bullet_points(resume),
        'no_images': not self._contains_images(resume),
        'single_column': self._is_single_column(resume)
    }

    # Calculate score
    passed_checks = sum(checks.values())
    total_checks = len(checks)

    score = passed_checks / total_checks

    return score

def _check_standard_fonts(self, resume):
    """Check if using ATS-friendly fonts"""
    standard_fonts = [
        'arial', 'calibri', 'georgia', 'helvetica',
        'times new roman', 'cambria', 'verdana'
    ]

    # Extract font info from resume (if available)
    # This is simplified - actual implementation depends on resume format
    return True  # Assume standard unless proven otherwise

def _contains_tables(self, resume):
    """Detect if resume uses tables"""
    # Check for table markers in markdown/HTML
    table_indicators = ['<table>', '|---|', '\t\t']
    return any(indicator in resume for indicator in table_indicators)

def _check_date_consistency(self, resume):
    """Check if dates use consistent format"""
    import re

    # Find all date patterns
    date_patterns = [
        r'\d{4}\s*[-–]\s*\d{4}',  # 2020 - 2023
        r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{4}',  # Jan 2020
        r'\d{1,2}/\d{4}'  # 01/2020
    ]

    found_formats = []
    for pattern in date_patterns:
        if re.search(pattern, resume):
            found_formats.append(pattern)

    # Consistent if only one format used
    return len(found_formats) <= 1

def _check_bullet_points(self, resume):
    """Check if using standard bullet points"""
    # Standard bullets: • - ● ▪
    standard_bullets = ['•', '-', '●', '▪']

    # Non-standard: ✓ ✗ → ➤ ★
    fancy_bullets = ['✓', '✗', '→', '➤', '★', '✦']

    return not any(bullet in resume for bullet in fancy_bullets)
```

## Structure Scoring

```python
def score_structure(self, resume):
    """Score resume structure and organization (0-1.0)"""

    checks = {
        'has_contact_info': self._has_contact_section(resume),
        'has_experience': self._has_section(resume, 'experience'),
        'has_education': self._has_section(resume, 'education'),
        'has_skills': self._has_section(resume, 'skills'),
        'logical_order': self._check_section_order(resume),
        'consistent_formatting': self._check_formatting_consistency(resume),
        'proper_headings': self._check_heading_hierarchy(resume)
    }

    passed_checks = sum(checks.values())
    total_checks = len(checks)

    return passed_checks / total_checks

def _has_section(self, resume, section_name):
    """Check if resume has specific section"""
    section_patterns = {
        'experience': r'(?i)(professional\s+)?experience|work\s+history|employment',
        'education': r'(?i)education|academic|qualifications',
        'skills': r'(?i)(technical\s+)?skills|competencies|expertise'
    }

    pattern = section_patterns.get(section_name, section_name)
    return bool(re.search(pattern, resume))

def _check_section_order(self, resume):
    """Check if sections are in logical order"""
    # Preferred order: Contact → Summary → Experience → Education → Skills
    sections = [
        ('contact', 0),
        ('summary|objective', 1),
        ('experience', 2),
        ('education', 3),
        ('skills', 4)
    ]

    section_positions = {}
    for section_pattern, expected_pos in sections:
        match = re.search(rf'(?i){section_pattern}', resume)
        if match:
            section_positions[section_pattern] = match.start()

    # Check if order is generally correct
    # (simplified - actual implementation would be more sophisticated)
    return True
```

## Recommendation Generation

```python
def generate_recommendations(self, scores):
    """Generate actionable recommendations to improve score"""

    recommendations = []

    # Keyword recommendations
    if scores['keyword_match'] < 0.9:
        recommendations.append({
            'category': 'Keywords',
            'severity': 'high',
            'issue': f"Keyword match is only {scores['keyword_match']*100:.0f}%",
            'actions': [
                'Add missing required keywords from job description',
                'Increase keyword density in experience bullets',
                'Include keywords in skills section'
            ]
        })

    # Skills recommendations
    if scores['skills_alignment'] < 0.85:
        recommendations.append({
            'category': 'Skills',
            'severity': 'high',
            'issue': f"Skills alignment is {scores['skills_alignment']*100:.0f}%",
            'actions': [
                'Add required skills to skills section',
                'Demonstrate skills through experience examples',
                'Remove irrelevant skills to focus on job requirements'
            ]
        })

    # Formatting recommendations
    if scores['formatting'] < 0.9:
        recommendations.append({
            'category': 'Formatting',
            'severity': 'medium',
            'issue': 'Format may not be fully ATS-compatible',
            'actions': [
                'Remove tables and text boxes',
                'Use standard bullet points (• or -)',
                'Ensure single-column layout',
                'Use consistent date formatting'
            ]
        })

    # Structure recommendations
    if scores['structure'] < 0.9:
        recommendations.append({
            'category': 'Structure',
            'severity': 'medium',
            'issue': 'Resume structure could be improved',
            'actions': [
                'Add missing standard sections',
                'Use standard section headers',
                'Ensure logical section order'
            ]
        })

    return sorted(recommendations, key=lambda x: {'high': 0, 'medium': 1, 'low': 2}[x['severity']])
```

## Score Interpretation

```python
SCORE_INTERPRETATION = {
    'A (90-100%)': {
        'meaning': 'Excellent ATS compatibility',
        'pass_probability': '90-95%',
        'action': 'Ready to submit'
    },
    'B (80-89%)': {
        'meaning': 'Good ATS compatibility',
        'pass_probability': '70-80%',
        'action': 'Minor optimizations recommended'
    },
    'C (70-79%)': {
        'meaning': 'Moderate ATS compatibility',
        'pass_probability': '50-60%',
        'action': 'Optimization needed before submitting'
    },
    'D (60-69%)': {
        'meaning': 'Poor ATS compatibility',
        'pass_probability': '30-40%',
        'action': 'Significant improvements required'
    },
    'F (<60%)': {
        'meaning': 'Very poor ATS compatibility',
        'pass_probability': '<20%',
        'action': 'Major revision needed'
    }
}
```

## Detailed Score Report

```markdown
# ATS Compatibility Report

## Overall Score: 87.5% (Grade: B)

**Pass Probability:** 70-80%
**Recommendation:** Minor optimizations recommended before submission

---

## Score Breakdown

### Keyword Match: 92% ✓
**Weight:** 50% of total score

**Analysis:**
- Required keywords: 19/20 present (95%)
- Preferred keywords: 12/15 present (80%)
- Overall coverage: 31/35 keywords (89%)

**Missing Keywords:**
- "regulatory compliance" (appears 5x in JD, 0x in resume)
- "strategic planning" (appears 3x in JD, 0x in resume)

### Skills Alignment: 84% ⚠
**Weight:** 20% of total score

**Analysis:**
- Required skills: 16/18 present (89%)
- Preferred skills: 8/12 present (67%)

**Missing Skills:**
- FinTech domain experience
- SOC2 compliance

### Formatting: 90% ✓
**Weight:** 20% of total score

**Checks Passed:** 7/8
- ✓ Standard fonts
- ✓ No tables
- ✓ No text boxes
- ✓ No headers/footers
- ⚠ Inconsistent date format (fix)
- ✓ Standard bullets
- ✓ No images
- ✓ Single column

### Structure: 100% ✓
**Weight:** 10% of total score

**Checks Passed:** 7/7
- ✓ Contact information
- ✓ Experience section
- ✓ Education section
- ✓ Skills section
- ✓ Logical section order
- ✓ Consistent formatting
- ✓ Proper headings

---

## Recommendations to Reach 90%+

### High Priority

1. **Add Missing Keywords**
   - Include "regulatory compliance" in relevant experience bullet
   - Add "strategic planning" to leadership competencies
   - Expected improvement: +3%

2. **Address Skills Gap**
   - Add FinTech experience examples
   - Mention SOC2 compliance if applicable
   - Expected improvement: +2%

### Medium Priority

3. **Fix Date Formatting**
   - Standardize all dates to "YYYY-MM" format
   - Expected improvement: +0.5%

---

## Estimated New Score: 93% (Grade: A)
```

## Integration Notes

- **Receives from:** resume-optimization (optimized resume)
- **Receives from:** job-description-analysis (JD keywords and requirements)
- **Feeds into:** resume-optimization (scores guide optimization)
- **Validates:** pdf-generation (ensure ATS-compatible PDF)
- **Tracks:** application-tracking (success correlation with scores)
