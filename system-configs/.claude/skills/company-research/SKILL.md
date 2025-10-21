---
name: company-research
description: Expertise in comprehensive company research from multiple sources
---

# Company Research Expertise

## Domain Focus

Expert knowledge in gathering comprehensive company intelligence from multiple sources to inform job applications, interview preparation, and strategic decision-making.

## Core Capabilities

- Multi-source data aggregation (website, news, reviews, financial)
- Employee review analysis (Glassdoor, Blind, Comparably)
- Interview process research
- Financial and funding analysis
- Product and market research
- Leadership and team analysis
- Culture and values assessment
- Red flag identification
- Competitive landscape analysis
- Recent news and press releases

## When to Use This Skill

Invoke this skill when:

- Preparing for job applications
- Researching potential employers
- Preparing for interviews
- Writing cover letters or "why this company" statements
- Evaluating job offers
- Understanding company culture
- Identifying interview questions to prepare for
- Assessing company stability and growth

## Research Sources

### Primary Sources

```yaml
Company Website:
  - About page (mission, values, history)
  - Careers page (culture, benefits)
  - Blog (technical depth, thought leadership)
  - Press releases (recent news)
  - Team page (leadership background)
  - Products page (offerings, roadmap)

Company Social Media:
  - LinkedIn company page (updates, employee count)
  - Twitter (company voice, responsiveness)
  - GitHub (engineering culture, open source)
  - YouTube (culture videos, talks)

Financial Information:
  - Crunchbase (funding, investors)
  - PitchBook (valuations, acquisitions)
  - Public filings (if public company)
  - Annual reports (strategic direction)

Employee Reviews:
  - Glassdoor (ratings, reviews, salaries)
  - Blind (anonymous employee discussions)
  - Comparably (culture, diversity ratings)
  - Indeed Company Reviews

Interview Insights:
  - Glassdoor interview reviews
  - LeetCode company discussions
  - Blind interview experiences
  - Rooftop Slushie (tech company reviews)

News & Media:
  - TechCrunch, VentureBeat (tech news)
  - LinkedIn news mentions
  - Google News search
  - Industry-specific publications
```

## Research Framework

### Comprehensive Company Profile

```python
class CompanyResearchProfile:
    """Structured company research output"""

    def __init__(self, company_name):
        self.company_name = company_name
        self.research_data = {
            'basic_info': {},
            'culture_values': {},
            'financial': {},
            'employee_feedback': {},
            'interview_process': {},
            'recent_news': [],
            'leadership': {},
            'products': {},
            'red_flags': [],
            'green_flags': [],
            'talking_points': []
        }

    def gather_basic_info(self):
        """Company fundamentals"""
        return {
            'name': self.company_name,
            'industry': extract_industry(),
            'size': extract_employee_count(),
            'founded': extract_founding_year(),
            'headquarters': extract_location(),
            'website': extract_website(),
            'public_or_private': check_public_status()
        }

    def analyze_culture(self):
        """Culture and values assessment"""
        return {
            'stated_values': extract_from_website(),
            'employee_perception': analyze_glassdoor_reviews(),
            'diversity_score': get_comparably_diversity_score(),
            'work_life_balance': analyze_review_sentiment('work-life balance'),
            'remote_policy': extract_remote_policy(),
            'culture_keywords': extract_culture_keywords()
        }

    def research_financials(self):
        """Financial health and trajectory"""
        return {
            'funding_stage': get_funding_stage(),
            'total_funding': get_total_funding(),
            'latest_round': get_latest_round(),
            'investors': get_investors(),
            'valuation': get_valuation(),
            'revenue_estimate': get_revenue_estimate(),
            'growth_trajectory': analyze_growth()
        }
```

## Employee Review Analysis

### Glassdoor Analysis

```python
def analyze_glassdoor_reviews(company_name):
    """Extract insights from Glassdoor reviews"""

    # Scrape or API call to get reviews
    reviews = fetch_glassdoor_reviews(company_name)

    analysis = {
        'overall_rating': calculate_average_rating(reviews),
        'rating_trend': analyze_rating_trend(reviews),
        'common_pros': extract_common_themes(reviews, 'pros'),
        'common_cons': extract_common_themes(reviews, 'cons'),
        'ceo_approval': get_ceo_approval_rating(),
        'recommend_to_friend': get_recommendation_rate(),
        'career_opportunities': get_category_rating('Career Opportunities'),
        'compensation_benefits': get_category_rating('Compensation'),
        'work_life_balance': get_category_rating('Work/Life Balance'),
        'management': get_category_rating('Management')
    }

    return analysis

def extract_common_themes(reviews, category='pros'):
    """Extract frequently mentioned themes"""
    from collections import Counter
    import nltk

    # Combine all pros or cons
    all_text = ' '.join([r[category] for r in reviews])

    # Extract keywords (simplified)
    keywords = extract_keywords(all_text)

    # Count frequency
    theme_counts = Counter(keywords)

    return theme_counts.most_common(10)
```

### Red Flags in Reviews

```python
RED_FLAG_PATTERNS = [
    # Management issues
    r'(?i)micromanag',
    r'(?i)toxic\s+(culture|environment|management)',
    r'(?i)poor\s+leadership',
    r'(?i)no\s+direction',

    # Work-life balance
    r'(?i)burn\s?out',
    r'(?i)work\s+life\s+balance\s+(terrible|poor|nonexistent)',
    r'(?i)long\s+hours',
    r'(?i)weekend\s+work',

    # Financial concerns
    r'(?i)running\s+out\s+of\s+money',
    r'(?i)layoffs?',
    r'(?i)unpaid\s+overtime',
    r'(?i)delayed\s+paych',

    # Culture issues
    r'(?i)discrimination',
    r'(?i)harassment',
    r'(?i)boys\s+club',
    r'(?i)high\s+turnover'
]

def detect_review_red_flags(reviews):
    """Identify concerning patterns in reviews"""
    red_flags = []

    for pattern in RED_FLAG_PATTERNS:
        matches = sum(1 for r in reviews if re.search(pattern, r['text']))
        if matches > len(reviews) * 0.2:  # 20%+ of reviews mention
            red_flags.append({
                'issue': pattern,
                'frequency': f"{matches}/{len(reviews)} reviews",
                'severity': 'high' if matches > len(reviews) * 0.4 else 'medium'
            })

    return red_flags
```

## Interview Process Research

### Interview Insights

```python
def research_interview_process(company_name):
    """Gather interview process information"""

    insights = {
        'process_overview': {
            'typical_stages': extract_interview_stages(),
            'duration': extract_average_duration(),
            'response_time': extract_average_response_time()
        },
        'common_questions': extract_common_interview_questions(),
        'technical_focus': identify_technical_focus_areas(),
        'behavioral_focus': identify_behavioral_themes(),
        'difficulty_rating': get_average_difficulty(),
        'interview_experience_rating': get_experience_rating(),
        'tips_from_candidates': extract_candidate_tips()
    }

    return insights

def extract_common_interview_questions(company_name):
    """Get frequently asked interview questions"""

    # Sources: Glassdoor, LeetCode, Blind
    questions = fetch_interview_questions(company_name)

    # Categorize
    categorized = {
        'technical': [],
        'behavioral': [],
        'system_design': [],
        'coding': [],
        'leadership': []
    }

    for q in questions:
        category = classify_question(q)
        categorized[category].append(q)

    # Get most frequent
    for category in categorized:
        categorized[category] = get_most_common(categorized[category], limit=10)

    return categorized
```

### Interview Preparation Insights

```
Common Interview Flow for TechCorp:
========================================

Stages:
1. Recruiter Screen (30 min)
   - Background discussion
   - Compensation expectations
   - Team fit assessment

2. Hiring Manager Interview (60 min)
   - Technical background deep-dive
   - Behavioral questions (leadership, conflict)
   - Questions about company/team

3. Technical Interview (90 min)
   - System design challenge
   - Architecture discussion
   - Technical depth questions

4. Panel Interview (120 min)
   - Cross-functional stakeholders
   - Culture fit assessment
   - "Why TechCorp" discussion

5. Executive Interview (30-45 min)
   - Strategic thinking
   - Vision alignment
   - Final questions

Total Timeline: 3-4 weeks
Decision: Usually within 1 week after final interview

Common Questions:
- "Design a distributed system for [use case]"
- "How do you handle underperforming team members?"
- "Tell me about a time you had to make a difficult trade-off"
- "Why TechCorp?"
- "Where do you see yourself in 5 years?"

Candidate Tips:
- Be prepared with specific examples (STAR method)
- Research TechCorp's recent product launches
- Ask about team structure and challenges
- Prepare questions about engineering culture
```

## Financial and Growth Research

### Funding Analysis

```python
def analyze_company_financials(company_name):
    """Research financial health and trajectory"""

    # Crunchbase or PitchBook data
    financial_data = {
        'funding_rounds': get_funding_rounds(),
        'total_raised': calculate_total_raised(),
        'last_round': get_most_recent_round(),
        'valuation': get_latest_valuation(),
        'investors': get_investor_list(),
        'acquisition_history': get_acquisitions()
    }

    # Analyze trajectory
    analysis = {
        'growth_stage': determine_growth_stage(financial_data),
        'runway_estimate': estimate_runway(financial_data),
        'financial_health': assess_financial_health(financial_data),
        'risk_level': calculate_risk_level(financial_data)
    }

    return {**financial_data, **analysis}

def determine_growth_stage(financial_data):
    """Classify company growth stage"""

    if financial_data.get('ipo_date'):
        return 'Public'
    elif 'Series E' in str(financial_data.get('last_round')):
        return 'Late Stage'
    elif 'Series C' in str(financial_data.get('last_round')) or 'Series D' in str(financial_data.get('last_round')):
        return 'Growth Stage'
    elif 'Series A' in str(financial_data.get('last_round')) or 'Series B' in str(financial_data.get('last_round')):
        return 'Early Stage'
    else:
        return 'Seed/Pre-Seed'
```

## Recent News Monitoring

### News Aggregation

```python
def gather_recent_news(company_name, days=90):
    """Collect recent news about company"""

    sources = [
        search_google_news(company_name, days),
        search_techcrunch(company_name, days),
        search_linkedin_posts(company_name, days),
        get_company_press_releases(company_name, days)
    ]

    all_news = []
    for source in sources:
        all_news.extend(source)

    # Deduplicate and sort by date
    unique_news = deduplicate_articles(all_news)
    sorted_news = sorted(unique_news, key=lambda x: x['date'], reverse=True)

    # Categorize
    categorized = {
        'product_launches': [],
        'funding': [],
        'partnerships': [],
        'leadership_changes': [],
        'acquisitions': [],
        'other': []
    }

    for article in sorted_news:
        category = classify_news_article(article)
        categorized[category].append(article)

    return categorized
```

## Leadership Research

```python
def research_leadership_team(company_name):
    """Research company leadership"""

    leadership = {
        'ceo': research_executive('CEO'),
        'cto': research_executive('CTO'),
        'vp_engineering': research_executive('VP Engineering'),
        'hiring_manager': research_hiring_manager()
    }

    return leadership

def research_executive(title):
    """Get background on specific executive"""
    return {
        'name': get_exec_name(title),
        'linkedin': get_linkedin_profile(),
        'background': get_career_history(),
        'education': get_education(),
        'previous_companies': get_work_history(),
        'thought_leadership': find_articles_talks(),
        'management_style': infer_from_reviews()
    }
```

## Talking Points Generation

```python
def generate_talking_points(research_data):
    """Generate talking points for interview"""

    talking_points = []

    # Recent news
    if research_data['recent_news']:
        latest = research_data['recent_news'][0]
        talking_points.append(
            f"I saw your recent {latest['category']} about {latest['summary']}. "
            f"This aligns with my experience in {find_relevant_experience(latest)}."
        )

    # Mission alignment
    if research_data['culture_values']:
        value = research_data['culture_values']['stated_values'][0]
        talking_points.append(
            f"Your focus on {value} resonates with my approach to {relate_to_experience(value)}."
        )

    # Product/technical
    if research_data['products']:
        product = research_data['products']['main_product']
        talking_points.append(
            f"I'm excited about {product} because {explain_excitement(product)}. "
            f"I see opportunities to contribute through {suggest_contribution()}."
        )

    return talking_points
```

## Research Output Template

```markdown
# Company Research: {Company Name}

## Quick Summary
- **Industry:** {industry}
- **Size:** {employee_count} employees
- **Stage:** {funding_stage}
- **Rating:** {glassdoor_rating}/5.0 on Glassdoor

## Company Overview
{mission_statement}

Founded in {year}, {company} has grown to {size} with {funding_info}. They're known for {key_differentiator}.

## Culture & Values

**Stated Values:**
- {value_1}
- {value_2}

**Employee Perspective:**
- **Pros:** {common_pros}
- **Cons:** {common_cons}
- **Work-Life Balance:** {rating}/5.0

## Interview Process

**Typical Flow:**
1. {stage_1}
2. {stage_2}
...

**Common Questions:**
- {question_1}
- {question_2}

**Timeline:** {average_timeline}

## Recent News
- {news_1}
- {news_2}

## Red Flags / Green Flags

**🚩 Red Flags:**
- {red_flag_1 if any}

**✅ Green Flags:**
- {green_flag_1}

## Talking Points for Interview

1. **Recent News:** "{talking_point_about_news}"
2. **Mission Alignment:** "{talking_point_about_mission}"
3. **Technical Interest:** "{talking_point_about_tech}"

## Questions to Ask

1. "{insightful_question_1}"
2. "{insightful_question_2}"
```

## Best Practices

1. **Use multiple sources** - Cross-reference information
2. **Check recency** - Focus on last 6-12 months
3. **Read between lines** - Pattern recognition in reviews
4. **Verify information** - Some reviews may be biased
5. **Focus on trends** - Individual reviews less important than patterns
6. **Research interviewer** - LinkedIn research on interview panel
7. **Track changes** - Company evolution over time
8. **Respect privacy** - Don't overshare research depth in interview

## Integration Notes

- **Feeds into:** cover-letter-writing (company-specific insights)
- **Feeds into:** interview-preparation (talking points, questions)
- **Works with:** web-scraping (data gathering)
- **Works with:** job-description-analysis (culture validation)
- **Informs:** application-tracking (company evaluation)
