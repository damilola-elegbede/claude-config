---
name: social-media-apis
description: Expertise in social media platform APIs (Instagram, Facebook, Twitter, WhatsApp)
---

# Social Media APIs Expertise

## Domain Focus

Expert knowledge in integrating with social media platform APIs for automated posting, content management, and engagement tracking.

## Core Capabilities

- Instagram Graph API (business accounts)
- Facebook Graph API endpoints
- Twitter API v2 (posts, media, threads)
- WhatsApp Business API
- OAuth 2.0 flows and token management
- Rate limiting and quota management
- Error handling and retry strategies
- Webhook integration for real-time updates

## When to Use This Skill

Invoke this skill when:

- Building automated posting scripts
- Debugging API authentication issues
- Implementing cross-platform publishing
- Setting up webhooks for engagement tracking
- Managing API tokens and credentials
- Handling platform-specific API constraints

## Platform-Specific Details

### Instagram Graph API

**Authentication:**

```bash
# Get long-lived access token
curl -X GET "https://graph.facebook.com/v18.0/oauth/access_token" \
  -d "grant_type=fb_exchange_token" \
  -d "client_id={app-id}" \
  -d "client_secret={app-secret}" \
  -d "fb_exchange_token={short-lived-token}"
```

**Post Image:**

```bash
# Step 1: Create media container
curl -X POST "https://graph.facebook.com/v18.0/{ig-user-id}/media" \
  -F "image_url={image-url}" \
  -F "caption={caption}" \
  -F "access_token={access-token}"

# Step 2: Publish media container
curl -X POST "https://graph.facebook.com/v18.0/{ig-user-id}/media_publish" \
  -F "creation_id={creation-id}" \
  -F "access_token={access-token}"
```

**Rate Limits:**

- 200 calls per hour per user
- 4800 calls per 24 hours per user

### Facebook Graph API

**Post to Page:**

```bash
curl -X POST "https://graph.facebook.com/v18.0/{page-id}/photos" \
  -F "url={image-url}" \
  -F "caption={message}" \
  -F "access_token={page-access-token}"
```

**Post Link:**

```bash
curl -X POST "https://graph.facebook.com/v18.0/{page-id}/feed" \
  -F "message={message}" \
  -F "link={link-url}" \
  -F "access_token={page-access-token}"
```

**Rate Limits:**

- 200 calls per hour per user
- App-level rate limits apply

### Twitter API v2

**Authentication (OAuth 2.0):**

```python
import requests
from requests_oauthlib import OAuth1

auth = OAuth1(
    client_key="API_KEY",
    client_secret="API_SECRET",
    resource_owner_key="ACCESS_TOKEN",
    resource_owner_secret="ACCESS_SECRET"
)
```

**Post Tweet:**

```python
url = "https://api.twitter.com/2/tweets"
payload = {"text": "Hello world!"}
response = requests.post(url, json=payload, auth=auth)
```

**Post with Media:**

```python
# Step 1: Upload media
media_url = "https://upload.twitter.com/1.1/media/upload.json"
files = {"media": open("image.jpg", "rb")}
media_response = requests.post(media_url, files=files, auth=auth)
media_id = media_response.json()["media_id_string"]

# Step 2: Post tweet with media
tweet_url = "https://api.twitter.com/2/tweets"
payload = {
    "text": "Check this out!",
    "media": {"media_ids": [media_id]}
}
response = requests.post(tweet_url, json=payload, auth=auth)
```

**Rate Limits:**

- 200 tweets per 15 minutes (user context)
- 300 tweets per 3 hours (app context)

### WhatsApp Business API

**Send Text Message:**

```bash
curl -X POST "https://graph.facebook.com/v18.0/{phone-number-id}/messages" \
  -H "Authorization: Bearer {access-token}" \
  -H "Content-Type: application/json" \
  -d '{
    "messaging_product": "whatsapp",
    "to": "{recipient-phone}",
    "type": "text",
    "text": {"body": "{message}"}
  }'
```

**Send Image:**

```bash
curl -X POST "https://graph.facebook.com/v18.0/{phone-number-id}/messages" \
  -H "Authorization: Bearer {access-token}" \
  -H "Content-Type: application/json" \
  -d '{
    "messaging_product": "whatsapp",
    "to": "{recipient-phone}",
    "type": "image",
    "image": {
      "link": "{image-url}",
      "caption": "{caption}"
    }
  }'
```

**Rate Limits:**

- 1000 messages per second per business
- 80 messages per second per phone number

## Best Practices

### Token Management

```python
import os
from datetime import datetime, timedelta

class TokenManager:
    def __init__(self):
        self.tokens = {}

    def is_expired(self, platform):
        """Check if token is expired"""
        if platform not in self.tokens:
            return True
        expiry = self.tokens[platform]['expires_at']
        return datetime.now() >= expiry

    def refresh_token(self, platform):
        """Refresh access token before expiry"""
        # Platform-specific refresh logic
        pass
```

### Rate Limiting Handler

```python
import time
from functools import wraps

def rate_limit_handler(max_calls, period):
    """Decorator to handle rate limiting"""
    calls = []

    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            now = time.time()
            # Remove old calls outside the period
            while calls and calls[0] < now - period:
                calls.pop(0)

            if len(calls) >= max_calls:
                sleep_time = period - (now - calls[0])
                time.sleep(sleep_time)

            calls.append(time.time())
            return func(*args, **kwargs)
        return wrapper
    return decorator

@rate_limit_handler(max_calls=200, period=900)  # 200 per 15 min
def post_to_twitter(text):
    # Post logic here
    pass
```

### Error Handling

```python
import requests
from requests.exceptions import RequestException

def post_with_retry(url, data, auth, max_retries=3):
    """Post with exponential backoff retry"""
    for attempt in range(max_retries):
        try:
            response = requests.post(url, json=data, auth=auth)
            response.raise_for_status()
            return response.json()
        except requests.HTTPError as e:
            if e.response.status_code == 429:  # Rate limited
                wait_time = int(e.response.headers.get('Retry-After', 60))
                time.sleep(wait_time)
            elif 500 <= e.response.status_code < 600:  # Server error
                time.sleep(2 ** attempt)  # Exponential backoff
            else:
                raise
        except RequestException as e:
            if attempt == max_retries - 1:
                raise
            time.sleep(2 ** attempt)

    raise Exception(f"Failed after {max_retries} attempts")
```

## Common Patterns

### Cross-Platform Posting

```python
class SocialMediaPoster:
    def __init__(self, credentials):
        self.ig = InstagramClient(credentials['instagram'])
        self.fb = FacebookClient(credentials['facebook'])
        self.tw = TwitterClient(credentials['twitter'])
        self.wa = WhatsAppClient(credentials['whatsapp'])

    def post_to_all(self, content, platforms=None):
        """Post to multiple platforms"""
        platforms = platforms or ['instagram', 'facebook', 'twitter']
        results = {}

        for platform in platforms:
            try:
                if platform == 'instagram':
                    results[platform] = self.ig.post(content)
                elif platform == 'facebook':
                    results[platform] = self.fb.post(content)
                elif platform == 'twitter':
                    results[platform] = self.tw.post(content)
            except Exception as e:
                results[platform] = {'error': str(e)}

        return results
```

### Webhook Handler

```python
from flask import Flask, request
import hmac
import hashlib

app = Flask(__name__)

@app.route('/webhook', methods=['GET', 'POST'])
def webhook():
    if request.method == 'GET':
        # Verification for Facebook/Instagram webhooks
        mode = request.args.get('hub.mode')
        token = request.args.get('hub.verify_token')
        challenge = request.args.get('hub.challenge')

        if mode == 'subscribe' and token == VERIFY_TOKEN:
            return challenge
        return 'Invalid verification token', 403

    if request.method == 'POST':
        # Verify signature
        signature = request.headers.get('X-Hub-Signature-256')
        if not verify_signature(request.data, signature):
            return 'Invalid signature', 403

        # Process webhook event
        data = request.json
        # Handle different event types
        return 'OK', 200

def verify_signature(payload, signature):
    """Verify webhook signature"""
    expected = hmac.new(
        APP_SECRET.encode(),
        payload,
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(f'sha256={expected}', signature)
```

## Quick Reference

| Platform | API Version | Auth Method | Max Post Length | Media Upload |
|----------|-------------|-------------|-----------------|--------------|
| Instagram | Graph v18.0 | OAuth 2.0 | 2,200 chars | Container → Publish |
| Facebook | Graph v18.0 | OAuth 2.0 | 63,206 chars | Direct upload |
| Twitter | API v2 | OAuth 1.0a/2.0 | 280 chars | Upload → Attach |
| WhatsApp | Cloud API v18.0 | Bearer Token | 4,096 chars | URL or upload |

## Common Error Codes

| Code | Platform | Meaning | Solution |
|------|----------|---------|----------|
| 190 | Instagram/FB | Invalid token | Refresh access token |
| 429 | All | Rate limited | Respect Retry-After header |
| 368 | Instagram | Temporary block | Wait 24-48 hours |
| 100 | Facebook | Invalid parameter | Check API documentation |
| 326 | Twitter | Account locked | Verify account status |

## Security Best Practices

- Store credentials in environment variables, never in code
- Use `.env` files (gitignored) for local development
- Rotate tokens regularly (every 60 days minimum)
- Implement webhook signature verification
- Use HTTPS for all API calls
- Log API errors but never log tokens
- Implement proper OAuth flows (never share secrets)

## Integration Notes

- Works alongside: `social-media-content` for content formatting
- Escalate to: `backend-engineer` for complex API integrations
- Escalate to: `security-auditor` for credential management issues
- Complements: `media-optimization` for preparing uploads
