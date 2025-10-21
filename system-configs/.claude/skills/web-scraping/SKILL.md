---
name: web-scraping
description: Expertise in web scraping for job descriptions and company information
---

# Web Scraping Expertise

## Domain Focus

Expert knowledge in extracting job descriptions from job boards, company career pages, and gathering company information from multiple online sources.

## Core Capabilities

- Job board scraping (LinkedIn, Indeed, Greenhouse, Lever)
- Company website data extraction
- Dynamic content handling (JavaScript-heavy sites)
- Anti-scraping measure bypassing (rate limiting, CAPTCHAs)
- Multi-source data aggregation
- HTML parsing and DOM navigation
- API integration (when available)
- Data cleaning and normalization
- Ethical scraping practices
- Error handling and retry logic

## Legal Compliance & Ethical Considerations

**IMPORTANT**: Web scraping must comply with legal and ethical requirements:

- **Terms of Service**: Always review and respect site ToS. Many job boards and company sites explicitly
  prohibit automated scraping.
- **robots.txt**: Check and honor robots.txt directives before scraping any domain.
- **CFAA Compliance**: Bypassing technical anti-scraping measures (CAPTCHAs, rate limits) may violate the
  Computer Fraud and Abuse Act (US) and similar laws internationally.
- **GDPR & Privacy**: Scraping personal data (employee reviews, candidate information) requires lawful basis
  under GDPR, CCPA, and other privacy regulations.
- **Rate Limiting**: Respect rate limits to avoid DoS-like behavior that could harm target servers.
- **API First**: Always prefer official APIs when available (LinkedIn API, Indeed API, Greenhouse API,
  Glassdoor Employer API).

**Disclaimer**: This skill provides technical capabilities only. Users are solely responsible for ensuring
legal compliance with all applicable laws and website terms of service in their jurisdiction.

## When to Use This Skill

Invoke this skill when:

- Fetching job descriptions from URLs
- Gathering company information from websites
- Extracting Glassdoor reviews
- Collecting LinkedIn company data
- Aggregating job postings across multiple boards
- Monitoring job posting changes over time

## Scraping Tools

### BeautifulSoup (Simple HTML Parsing)

**Best for:** Static HTML, simple sites, quick parsing

```python
import requests
from bs4 import BeautifulSoup

def scrape_simple_page(url):
    """Scrape static HTML page"""
    response = requests.get(url, headers={
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    })

    soup = BeautifulSoup(response.content, 'html.parser')

    # Extract content
    title = soup.find('h1').get_text(strip=True)
    description = soup.find('div', class_='description').get_text(strip=True)

    return {
        'title': title,
        'description': description
    }
```

### Playwright (JavaScript-Heavy Sites)

**Best for:** Dynamic content, LinkedIn, modern job boards

```python
from playwright.sync_api import sync_playwright

def scrape_dynamic_page(url):
    """Scrape JavaScript-rendered content"""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        # Set user agent to avoid detection
        page.set_extra_http_headers({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })

        page.goto(url)

        # Wait for content to load
        page.wait_for_selector('.job-description', timeout=10000)

        # Extract content
        title = page.query_selector('h1').inner_text()
        description = page.query_selector('.job-description').inner_text()

        browser.close()

        return {
            'title': title,
            'description': description
        }
```

## Job Board Scrapers

### LinkedIn Jobs

```python
def scrape_linkedin_job(job_url):
    """Scrape LinkedIn job posting"""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto(job_url)

        # Wait for job description
        page.wait_for_selector('.description__text', timeout=10000)

        data = {
            'title': page.query_selector('.top-card-layout__title').inner_text(),
            'company': page.query_selector('.topcard__org-name-link').inner_text(),
            'location': page.query_selector('.topcard__flavor--bullet').inner_text(),
            'description': page.query_selector('.description__text').inner_text(),
            'posted_date': page.query_selector('.posted-time-ago__text').inner_text()
        }

        browser.close()
        return data
```

### Indeed Jobs

```python
def scrape_indeed_job(job_url):
    """Scrape Indeed job posting"""
    response = requests.get(job_url, headers={
        'User-Agent': 'Mozilla/5.0'
    })

    soup = BeautifulSoup(response.content, 'html.parser')

    data = {
        'title': soup.find('h1', class_='jobsearch-JobInfoHeader-title').get_text(strip=True),
        'company': soup.find('div', class_='jobsearch-InlineCompanyRating').find('a').get_text(strip=True),
        'location': soup.find('div', class_='jobsearch-JobInfoHeader-subtitle').get_text(strip=True),
        'description': soup.find('div', id='jobDescriptionText').get_text(separator='\n', strip=True)
    }

    return data
```

### Greenhouse ATS

```python
def scrape_greenhouse_job(job_url):
    """Scrape Greenhouse job posting"""
    response = requests.get(job_url)
    soup = BeautifulSoup(response.content, 'html.parser')

    data = {
        'title': soup.find('h1', class_='app-title').get_text(strip=True),
        'company': extract_company_from_url(job_url),
        'location': soup.find('div', class_='location').get_text(strip=True),
        'description': soup.find('div', id='content').get_text(separator='\n', strip=True)
    }

    return data
```

### Lever Jobs

```python
def scrape_lever_job(job_url):
    """Scrape Lever job posting"""
    response = requests.get(job_url)
    soup = BeautifulSoup(response.content, 'html.parser')

    data = {
        'title': soup.find('h2').get_text(strip=True),
        'company': extract_company_from_url(job_url),
        'location': soup.find('div', class_='location').get_text(strip=True),
        'description': soup.find('div', class_='content').get_text(separator='\n', strip=True)
    }

    return data
```

## Company Research Scrapers

### Company Website

```python
def scrape_company_website(company_url):
    """Extract company information from website"""
    response = requests.get(company_url)
    soup = BeautifulSoup(response.content, 'html.parser')

    # Extract mission/about
    about = soup.find('div', class_=['about', 'mission', 'company'])
    mission = about.get_text(strip=True) if about else ""

    # Extract recent news
    news = soup.find_all('article', limit=5)
    recent_news = [article.find('h2').get_text(strip=True) for article in news if article.find('h2')]

    return {
        'mission': mission,
        'recent_news': recent_news,
        'url': company_url
    }
```

### Glassdoor Company Data

**Recommended Approach: Use Official APIs**

Glassdoor has strong anti-scraping measures and actively blocks automated scrapers. Direct scraping
violates their Terms of Service and poses legal risks.

**Official Options**:

- **Glassdoor Employer API**: Paid API for company ratings, reviews, and salary data
- **Glassdoor Community API**: Limited public data access for verified partners
- **Manual Research**: For sensitive or one-off needs, manual data collection respects ToS

**Why Not Scrape Glassdoor**:

- Strong anti-scraping (CAPTCHA, IP blocking, behavioral analysis)
- Terms of Service explicitly prohibit automated access
- GDPR risks: Employee reviews contain personal opinions/data
- Legal liability: Violates CFAA (Computer Fraud and Abuse Act)
- Account bans: Glassdoor aggressively bans scraping attempts

**Alternative**: For company research, use company-research skill with official APIs and public sources.

## Ethical Scraping Practices

### Rate Limiting

```python
import time
import random

class RateLimiter:
    """Implement rate limiting for scraping"""

    def __init__(self, min_delay=1, max_delay=3):
        self.min_delay = min_delay
        self.max_delay = max_delay
        self.last_request = 0

    def wait(self):
        """Wait before next request"""
        elapsed = time.time() - self.last_request
        delay = random.uniform(self.min_delay, self.max_delay)

        if elapsed < delay:
            time.sleep(delay - elapsed)

        self.last_request = time.time()

# Usage
limiter = RateLimiter(min_delay=2, max_delay=5)

for url in job_urls:
    limiter.wait()
    data = scrape_job(url)
```

### User Agent Rotation

```python
USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
]

def get_random_user_agent():
    """Return random user agent"""
    return random.choice(USER_AGENTS)

def scrape_with_rotation(url):
    """Scrape with user agent rotation"""
    headers = {'User-Agent': get_random_user_agent()}
    response = requests.get(url, headers=headers)
    return response
```

### Retry Logic with Exponential Backoff

```python
import time
from requests.exceptions import RequestException

def scrape_with_retry(url, max_retries=3):
    """Scrape with exponential backoff retry"""
    for attempt in range(max_retries):
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            return response

        except RequestException as e:
            if attempt == max_retries - 1:
                raise

            wait_time = 2 ** attempt  # Exponential backoff
            time.sleep(wait_time)

    return None
```

## Data Cleaning

### Text Normalization

```python
import re

def clean_scraped_text(text):
    """Clean and normalize scraped text"""
    # Remove extra whitespace
    text = re.sub(r'\s+', ' ', text)

    # Remove special characters
    text = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', text)

    # Normalize unicode
    text = text.encode('ascii', 'ignore').decode('ascii')

    return text.strip()
```

### HTML Stripping

```python
from bs4 import BeautifulSoup

def strip_html(html_content):
    """Strip HTML tags and return clean text"""
    soup = BeautifulSoup(html_content, 'html.parser')

    # Remove script and style elements
    for script in soup(['script', 'style']):
        script.decompose()

    # Get text
    text = soup.get_text(separator='\n')

    # Clean up whitespace
    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    text = '\n'.join(chunk for chunk in chunks if chunk)

    return text
```

## Universal Job Scraper

```python
class UniversalJobScraper:
    """Detect job board and use appropriate scraper"""

    SCRAPERS = {
        'linkedin.com': scrape_linkedin_job,
        'indeed.com': scrape_indeed_job,
        'greenhouse.io': scrape_greenhouse_job,
        'lever.co': scrape_lever_job
    }

    def scrape(self, url):
        """Auto-detect and scrape job posting"""
        for domain, scraper in self.SCRAPERS.items():
            if domain in url:
                return scraper(url)

        # Fallback to generic scraper
        return self.scrape_generic(url)

    def scrape_generic(self, url):
        """Generic scraper for unknown job boards"""
        response = requests.get(url)
        soup = BeautifulSoup(response.content, 'html.parser')

        # Try common selectors
        title = soup.find('h1') or soup.find('title')
        description = soup.find('div', class_=['description', 'content', 'job-description'])

        return {
            'title': title.get_text(strip=True) if title else "",
            'description': description.get_text(separator='\n', strip=True) if description else "",
            'url': url
        }
```

## Handling Anti-Scraping Measures

### Session Management

```python
import requests

class ScrapingSession:
    """Maintain session for consistent scraping"""

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0'
        })

    def get(self, url):
        """Make GET request with session"""
        return self.session.get(url)

    def close(self):
        """Close session"""
        self.session.close()
```

### Proxy Rotation (if needed)

```python
PROXIES = [
    'http://proxy1.example.com:8080',
    'http://proxy2.example.com:8080'
]

def scrape_with_proxy(url):
    """Scrape using proxy rotation"""
    proxy = random.choice(PROXIES)
    proxies = {'http': proxy, 'https': proxy}

    response = requests.get(url, proxies=proxies)
    return response
```

## Best Practices

1. **Respect robots.txt** - Check site's scraping policy
2. **Use rate limiting** - Don't overload servers
3. **Rotate user agents** - Appear as regular browsers
4. **Handle errors gracefully** - Retry with backoff
5. **Cache results** - Avoid re-scraping same data
6. **Prefer APIs** - Use official APIs when available
7. **Clean data** - Normalize and validate extracted data

## Integration Notes

- **Feeds into:** job-description-analysis (provides JD text)
- **Feeds into:** company-research (provides company data)
- **Works with:** application-tracking (monitor job postings)
- **Requires:** Playwright or Selenium for JavaScript-heavy sites
- **Alternative:** Use official APIs (LinkedIn API, Indeed API) when available
