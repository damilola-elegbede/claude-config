---
name: application-tracking
description: Expertise in application pipeline management and success analytics
---

# Application Tracking Expertise

## Domain Focus

Expert knowledge in managing job application pipelines, tracking progress through stages, analyzing success metrics, and optimizing application strategies.

## Core Capabilities

- Application status tracking
- Pipeline stage management
- Success rate analytics
- Timeline tracking
- Interview scheduling and tracking
- Follow-up reminders
- Keyword effectiveness analysis
- Resume version tracking
- Offer comparison
- Data visualization and reporting

## When to Use This Skill

Invoke this skill when:

- Adding new job applications
- Updating application status
- Tracking interview stages
- Analyzing success patterns
- Generating pipeline reports
- Setting follow-up reminders
- Comparing multiple offers
- Evaluating application strategies
- Identifying optimization opportunities

## Application Lifecycle

### Status Pipeline

```yaml
Pipeline Stages:
  Applied:
    - Description: Application submitted
    - Next Action: Wait for response
    - Typical Duration: 3-7 days
    - Success Rate: 60-70% move forward

  Screening:
    - Description: Recruiter phone screen
    - Next Action: Schedule technical interview
    - Typical Duration: 1-2 weeks
    - Success Rate: 40-50% move forward

  Interview:
    - Description: Technical/behavioral interviews
    - Next Action: Complete all interview rounds
    - Typical Duration: 2-4 weeks
    - Success Rate: 30-40% receive offers

  Offer:
    - Description: Offer received
    - Next Action: Evaluate and negotiate
    - Typical Duration: 1 week to decide
    - Success Rate: 70-80% accept

  Rejected:
    - Description: Application declined
    - Next Action: Learn from feedback
    - Archive for analysis

  Withdrawn:
    - Description: Candidate withdrew
    - Next Action: Update preferences
    - Archive for analysis
```

## Data Model

### Application Record Structure

```python
from dataclasses import dataclass
from datetime import datetime
from typing import List, Optional

@dataclass
class Application:
    """Single job application record"""

    # Basic Information
    application_id: str
    company: str
    position: str
    job_url: str
    applied_date: datetime

    # Status Tracking
    status: str  # applied, screening, interview, offer, rejected, withdrawn
    stage_history: List[dict]  # Timeline of status changes

    # Contact Information
    recruiter_name: Optional[str] = None
    recruiter_email: Optional[str] = None
    hiring_manager: Optional[str] = None

    # Application Materials
    resume_version: Optional[str] = None
    cover_letter_used: bool = False
    referral: Optional[str] = None

    # Interview Tracking
    interviews: List[dict] = None  # Interview details

    # Metrics
    ats_score: Optional[float] = None
    response_time_days: Optional[int] = None

    # Follow-up
    next_action: Optional[str] = None
    next_action_date: Optional[datetime] = None
    follow_up_reminder: Optional[datetime] = None

    # Outcome
    outcome: Optional[str] = None  # offer, rejected, withdrawn
    outcome_date: Optional[datetime] = None
    offer_details: Optional[dict] = None
    rejection_reason: Optional[str] = None

    # Notes
    notes: List[str] = None
    lessons_learned: Optional[str] = None

    # Research
    company_research: Optional[str] = None
    glassdoor_rating: Optional[float] = None
```

### Interview Record

```python
@dataclass
class Interview:
    """Single interview record"""

    date: datetime
    type: str  # recruiter_screen, technical, behavioral, panel, final
    interviewer: str
    duration: int  # minutes
    format: str  # phone, video, onsite

    # Preparation
    prep_materials: List[str] = None
    questions_prepared: List[str] = None

    # Post-Interview
    questions_asked: List[str] = None
    notes: str = None
    thank_you_sent: bool = False
    impression: str = None  # positive, neutral, negative

    # Next Steps
    next_round_scheduled: Optional[datetime] = None
```

## Tracking Operations

### Add New Application

```python
class ApplicationTracker:
    """Manage application pipeline"""

    def add_application(
        self,
        company: str,
        position: str,
        job_url: str,
        resume_version: str = None,
        cover_letter_used: bool = False,
        referral: str = None
    ):
        """Add new application to tracker"""

        app_id = self._generate_app_id(company, position)

        application = Application(
            application_id=app_id,
            company=company,
            position=position,
            job_url=job_url,
            applied_date=datetime.now(),
            status='applied',
            stage_history=[{
                'status': 'applied',
                'date': datetime.now(),
                'notes': 'Application submitted'
            }],
            resume_version=resume_version,
            cover_letter_used=cover_letter_used,
            referral=referral,
            interviews=[],
            notes=[]
        )

        self.applications.append(application)
        return application
```

### Update Application Status

```python
    def update_status(
        self,
        app_id: str,
        new_status: str,
        notes: str = None
    ):
        """Update application status and track change"""

        app = self.get_application(app_id)

        if not app:
            raise ValueError(f"Application {app_id} not found")

        # Add to history
        app.stage_history.append({
            'status': new_status,
            'date': datetime.now(),
            'notes': notes or ''
        })

        # Update current status
        app.status = new_status

        # Calculate response time if moving from applied
        if len(app.stage_history) == 2 and new_status == 'screening':
            app.response_time_days = (
                datetime.now() - app.applied_date
            ).days

        # Set next action
        app.next_action = self._suggest_next_action(new_status)

        return app
```

### Track Interview

```python
    def add_interview(
        self,
        app_id: str,
        interview_date: datetime,
        interview_type: str,
        interviewer: str,
        duration: int = 60
    ):
        """Add interview to application"""

        app = self.get_application(app_id)

        interview = Interview(
            date=interview_date,
            type=interview_type,
            interviewer=interviewer,
            duration=duration,
            format='video'  # default
        )

        app.interviews.append(interview)

        # Update status if not already in interview stage
        if app.status != 'interview':
            self.update_status(app_id, 'interview', f'{interview_type} scheduled')

        return interview
```

## Analytics and Reporting

### Pipeline Overview

```python
    def get_pipeline_summary(self):
        """Generate pipeline summary statistics"""

        total = len(self.applications)
        by_status = {}

        for app in self.applications:
            status = app.status
            by_status[status] = by_status.get(status, 0) + 1

        return {
            'total_applications': total,
            'by_status': by_status,
            'active': sum(
                by_status.get(s, 0)
                for s in ['applied', 'screening', 'interview', 'offer']
            ),
            'completed': sum(
                by_status.get(s, 0)
                for s in ['rejected', 'withdrawn']
            )
        }
```

### Success Metrics

```python
    def calculate_success_metrics(self):
        """Calculate application success rates"""

        total = len(self.applications)
        if total == 0:
            return {}

        # Count by status
        responded = sum(1 for app in self.applications if app.status != 'applied')
        screening = sum(1 for app in self.applications if app.status in ['screening', 'interview', 'offer'])
        interview = sum(1 for app in self.applications if app.status in ['interview', 'offer'])
        offers = sum(1 for app in self.applications if app.status == 'offer')

        return {
            'response_rate': responded / total if total > 0 else 0,
            'screening_rate': screening / total if total > 0 else 0,
            'interview_rate': interview / total if total > 0 else 0,
            'offer_rate': offers / total if total > 0 else 0,

            # Conversion rates
            'applied_to_screening': screening / responded if responded > 0 else 0,
            'screening_to_interview': interview / screening if screening > 0 else 0,
            'interview_to_offer': offers / interview if interview > 0 else 0,

            # Averages
            'avg_response_time_days': self._calculate_avg_response_time(),
            'avg_time_to_offer_days': self._calculate_avg_time_to_offer()
        }
```

### Keyword Effectiveness

```python
    def analyze_keyword_effectiveness(self):
        """Analyze which keywords correlate with success"""

        keyword_performance = {}

        for app in self.applications:
            # Get keywords from resume version
            keywords = self._extract_keywords_from_resume(app.resume_version)

            for keyword in keywords:
                if keyword not in keyword_performance:
                    keyword_performance[keyword] = {
                        'total_applications': 0,
                        'responses': 0,
                        'interviews': 0,
                        'offers': 0
                    }

                stats = keyword_performance[keyword]
                stats['total_applications'] += 1

                if app.status != 'applied':
                    stats['responses'] += 1
                if app.status in ['interview', 'offer']:
                    stats['interviews'] += 1
                if app.status == 'offer':
                    stats['offers'] += 1

        # Calculate effectiveness scores
        for keyword, stats in keyword_performance.items():
            total = stats['total_applications']
            stats['response_rate'] = stats['responses'] / total
            stats['interview_rate'] = stats['interviews'] / total
            stats['offer_rate'] = stats['offers'] / total

            # Overall effectiveness score (weighted)
            stats['effectiveness_score'] = (
                stats['response_rate'] * 0.3 +
                stats['interview_rate'] * 0.4 +
                stats['offer_rate'] * 0.3
            ) * 10  # Scale to 0-10

        # Sort by effectiveness
        sorted_keywords = sorted(
            keyword_performance.items(),
            key=lambda x: x[1]['effectiveness_score'],
            reverse=True
        )

        return dict(sorted_keywords[:20])  # Top 20
```

## Visualization and Reporting

### Pipeline Dashboard

```python
    def generate_dashboard(self):
        """Generate text-based pipeline dashboard"""

        summary = self.get_pipeline_summary()
        metrics = self.calculate_success_metrics()

        dashboard = f"""
Application Pipeline Dashboard
================================

Total Applications: {summary['total_applications']}
├─ Applied: {summary['by_status'].get('applied', 0)} ({summary['by_status'].get('applied', 0) / summary['total_applications'] * 100:.0f}%)
├─ Screening: {summary['by_status'].get('screening', 0)} ({summary['by_status'].get('screening', 0) / summary['total_applications'] * 100:.0f}%)
├─ Interview: {summary['by_status'].get('interview', 0)} ({summary['by_status'].get('interview', 0) / summary['total_applications'] * 100:.0f}%)
├─ Offer: {summary['by_status'].get('offer', 0)} ({summary['by_status'].get('offer', 0) / summary['total_applications'] * 100:.0f}%)
└─ Rejected: {summary['by_status'].get('rejected', 0)} ({summary['by_status'].get('rejected', 0) / summary['total_applications'] * 100:.0f}%)

Success Metrics
===============
- Response Rate: {metrics['response_rate'] * 100:.1f}%
- Interview Rate: {metrics['interview_rate'] * 100:.1f}%
- Offer Rate: {metrics['offer_rate'] * 100:.1f}%

Conversion Funnel
=================
Applied → Screening: {metrics['applied_to_screening'] * 100:.1f}%
Screening → Interview: {metrics['screening_to_interview'] * 100:.1f}%
Interview → Offer: {metrics['interview_to_offer'] * 100:.1f}%

Timeline Metrics
================
- Avg Response Time: {metrics['avg_response_time_days']:.1f} days
- Avg Time to Offer: {metrics['avg_time_to_offer_days']:.1f} days
"""

        return dashboard
```

### Follow-up Reminders

```python
    def get_follow_ups_due(self):
        """Get applications needing follow-up"""

        today = datetime.now()
        follow_ups = []

        for app in self.applications:
            # Check follow-up reminder
            if app.follow_up_reminder and app.follow_up_reminder <= today:
                follow_ups.append({
                    'application': app,
                    'type': 'reminder',
                    'action': app.next_action,
                    'days_overdue': (today - app.follow_up_reminder).days
                })

            # Check if no response after 7 days
            elif app.status == 'applied':
                days_since_applied = (today - app.applied_date).days
                if days_since_applied >= 7:
                    follow_ups.append({
                        'application': app,
                        'type': 'no_response',
                        'action': 'Send follow-up email',
                        'days_since_action': days_since_applied
                    })

        return sorted(follow_ups, key=lambda x: x.get('days_overdue', x.get('days_since_action', 0)), reverse=True)
```

## Best Practices

1. **Update promptly** - Log changes as they happen
2. **Track everything** - Interviews, emails, calls, research
3. **Set reminders** - Follow-ups, thank you notes, deadlines
4. **Take notes** - Capture interview insights while fresh
5. **Analyze patterns** - What's working? What's not?
6. **Version control** - Track which resume version was used
7. **Learn from rejections** - Document feedback for improvement

## Integration Notes

- **Receives from:** All skills and agents (application materials)
- **Tracks:** resume-optimization (resume versions and effectiveness)
- **Tracks:** ats-scoring (score correlation with success)
- **Tracks:** company-research (research insights)
- **Provides:** Success analytics to inform strategy
- **Storage:** JSON files, SQLite, or dedicated database
