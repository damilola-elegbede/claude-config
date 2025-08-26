# ElevenLabs MCP Integration Documentation

## Overview

The ElevenLabs MCP (Model Context Protocol) integration provides seamless access to advanced
text-to-speech, voice cloning, and audio transcription capabilities directly within Claude Code's
agent ecosystem. This integration enables agents to leverage cutting-edge AI voice synthesis for
creating natural, expressive audio content with multi-language support and custom voice designs.

## What is ElevenLabs MCP Integration?

ElevenLabs MCP integration connects Claude's agents directly to ElevenLabs' AI voice synthesis
platform through Model Context Protocol servers. This allows agents to:

- **Generate Natural Speech**: Convert text to high-quality, expressive audio using advanced
  neural networks
- **Create Custom Voices**: Design and clone voices with specific characteristics and
  emotional tones
- **Multi-Language Support**: Generate speech in 29+ languages with native pronunciation
- **Audio Transcription**: Convert speech back to text with high accuracy
- **Voice Variation**: Create multiple variations of the same voice for different use cases
- **Real-time Streaming**: Generate and stream audio content for interactive applications

## Supported Agents

### Primary Content & Media Agents

1. **content-creator** - Generates audio content for presentations, tutorials, and
   marketing materials
2. **accessibility-auditor** - Creates audio alternatives for visual content to ensure
   WCAG compliance
3. **technical-writer** - Produces audio versions of documentation and technical guides
4. **ux-researcher** - Creates audio prototypes for user testing and voice interface research

### Secondary Support Agents

1. **frontend-engineer** - Implements TTS features in web applications and user interfaces
2. **mobile-developer** - Integrates voice capabilities into mobile applications
3. **api-architect** - Designs voice-enabled API endpoints and audio processing pipelines
4. **test-engineer** - Creates automated tests for voice generation and audio quality validation
5. **localization-specialist** - Manages multi-language voice content and cultural adaptations

## MCP Server Configuration

### Prerequisites

- Claude Code CLI with MCP support enabled
- Python 3.8+ or Node.js 18+ for ElevenLabs MCP server
- ElevenLabs API key (free tier available, paid plans for advanced features)
- Active internet connection for voice generation
- Audio playback capabilities on target system

### Installation Steps

#### Method 1: npx Installation (Recommended for Claude Desktop)

1. **Ensure Node.js is installed**:

   ```bash
   # Install Node.js if not already installed
   brew install node
   ```

2. **Set Environment Variables**:

   ```bash
   export ELEVENLABS_API_KEY="your_api_key_here"
   export ELEVENLABS_DEFAULT_VOICE="Rachel"  # Optional
   ```

3. **Configure Claude Settings**:

   Add to your `~/.claude/settings.json`:

   ```json
   {
     "mcpServers": {
       "elevenlabs": {
         "command": "npx",
         "args": ["-y", "elevenlabs-streaming-mcp-server"],
         "env": {
           "ELEVENLABS_API_KEY": "${ELEVENLABS_API_KEY}"
         }
       }
     }
   }
   ```

#### Method 2: Manual Installation (Alternative)

1. **Install the package globally**:

   ```bash
   npm install -g elevenlabs-streaming-mcp-server
   ```

2. **Configure without -y flag**:

   ```json
   {
     "mcpServers": {
       "elevenlabs": {
         "command": "elevenlabs-streaming-mcp-server",
         "args": [],
         "env": {
           "ELEVENLABS_API_KEY": "${ELEVENLABS_API_KEY}"
         }
       }
     }
   }
   ```

3. **Verify Connection**:

   ```bash
   claude mcp list
   # Should show: elevenlabs - Connected

   claude mcp test elevenlabs
   # Should return: "ElevenLabs MCP Server - Ready"
   ```

### API Key Setup

1. **Get API Key**: Visit [ElevenLabs](https://elevenlabs.io) and create an account
2. **Free Tier**: 10,000 characters/month for personal projects
3. **Paid Plans**: Higher limits, voice cloning, and commercial usage rights

## Benefits of ElevenLabs Integration

### Voice Quality Excellence

- **Natural Prosody**: Advanced intonation, rhythm, and stress patterns
- **Emotional Range**: Convey different emotions and speaking styles
- **Clarity**: Crystal-clear articulation suitable for professional content
- **Consistency**: Reliable voice quality across different text lengths

### Accessibility Features

- **WCAG Compliance**: Audio alternatives for visual content
- **Screen Reader Enhancement**: High-quality narration for assistive technology
- **Multi-sensory Content**: Support users with different learning preferences
- **Language Accessibility**: Native pronunciation for international users

### Development Efficiency

- **API Simplicity**: Clean, well-documented RESTful API
- **Fast Generation**: Sub-second response times for most content
- **Batch Processing**: Handle multiple text segments efficiently
- **Error Handling**: Graceful fallbacks and detailed error messages

### Content Creation Power

- **Professional Narration**: Podcast-quality audio for presentations
- **Interactive Applications**: Real-time voice feedback and responses
- **Educational Content**: Engaging audio for tutorials and courses
- **Marketing Materials**: Compelling voiceovers for promotional content

## Common Use Cases with ElevenLabs

### Documentation Audio Generation

```python
import elevenlabs_mcp

# Generate audio for technical documentation
def create_audio_docs(markdown_content):
    """Convert markdown documentation to audio format"""

    # Extract text content from markdown
    text_content = extract_text_from_markdown(markdown_content)

    # Generate speech with professional voice
    audio = elevenlabs_mcp.generate_speech(
        text=text_content,
        voice="Daniel",  # Professional male voice
        model="eleven_multilingual_v2",
        stability=0.5,
        similarity_boost=0.8
    )

    return audio

# Usage example
docs_audio = create_audio_docs("""
# API Integration Guide

Welcome to our comprehensive API integration guide.
This tutorial will walk you through the essential steps
for connecting your application to our services.

## Prerequisites

Before you begin, ensure you have the following:
- Valid API credentials
- Development environment setup
- Basic knowledge of REST APIs
""")
```

### Multi-Language Content Creation

```python
def create_multilingual_content(text, languages=None):
    """Generate the same content in multiple languages"""

    if languages is None:
        languages = ['en', 'es', 'fr', 'de', 'pt']

    audio_versions = {}

    for lang in languages:
        # Select appropriate voice for each language
        voice_map = {
            'en': 'Rachel',
            'es': 'Domi',
            'fr': 'Thomas',
            'de': 'Seraphina',
            'pt': 'Matilda'
        }

        audio = elevenlabs_mcp.generate_speech(
            text=text,
            voice=voice_map[lang],
            model="eleven_multilingual_v2"
        )

        audio_versions[lang] = audio

    return audio_versions

# Usage for international documentation
welcome_message = "Welcome to our platform. Let's get started with your first project."
multilingual_audio = create_multilingual_content(welcome_message)
```

### Voice Cloning for Brand Consistency

```python
def create_brand_voice(sample_audio_path, brand_text):
    """Clone a voice for consistent brand messaging"""

    # Create custom voice from sample
    custom_voice = elevenlabs_mcp.clone_voice(
        name="Brand_Voice_2024",
        files=[sample_audio_path],
        description="Official brand voice for company communications"
    )

    # Generate content with cloned voice
    brand_audio = elevenlabs_mcp.generate_speech(
        text=brand_text,
        voice_id=custom_voice.voice_id,
        model="eleven_monolingual_v1"
    )

    return brand_audio

# Usage for marketing content
marketing_copy = """
Discover the future of productivity with our innovative platform.
Join thousands of teams who have transformed their workflow
and achieved remarkable results.
"""
brand_narration = create_brand_voice("ceo_sample.mp3", marketing_copy)
```

### Interactive Tutorial Audio

```python
def create_interactive_tutorial(steps):
    """Generate step-by-step audio tutorial"""

    tutorial_segments = []

    for i, step in enumerate(steps, 1):
        # Add step numbering and pacing
        step_text = f"Step {i}. {step['instruction']} Take your time to complete this step."

        audio_segment = elevenlabs_mcp.generate_speech(
            text=step_text,
            voice="Adam",  # Clear instructional voice
            model="eleven_monolingual_v1",
            stability=0.7,  # More stable for instructions
            similarity_boost=0.6
        )

        tutorial_segments.append({
            'step': i,
            'audio': audio_segment,
            'duration': step.get('estimated_time', 30)
        })

    return tutorial_segments

# Usage for technical tutorials
coding_steps = [
    {
        'instruction': 'Open your terminal and navigate to your project directory',
        'estimated_time': 15
    },
    {
        'instruction': 'Install the required dependencies using npm install',
        'estimated_time': 45
    },
    {
        'instruction': 'Create a new component file in the components folder',
        'estimated_time': 30
    }
]

tutorial_audio = create_interactive_tutorial(coding_steps)
```

## Integration Workflow

### Typical Development Flow

1. **Content Analysis**: content-creator and technical-writer analyze text requirements
2. **Voice Selection**: ux-researcher and accessibility-auditor select appropriate voices
3. **Audio Generation**: frontend-engineer or mobile-developer implements TTS features
4. **Quality Validation**: test-engineer and accessibility-auditor validate audio output
5. **Localization**: localization-specialist adapts for different markets

### Agent Coordination Patterns

- **Parallel Generation**: Multiple agents create different audio content simultaneously
- **Sequential Processing**: Content Creation → Voice Generation → Quality Testing → Deployment
- **Iterative Refinement**: Continuous feedback between content and audio quality teams

## Best Practices

### Voice Selection Guidelines

- **Content Type Matching**: Use professional voices for business content, conversational voices
  for tutorials
- **Audience Consideration**: Match voice characteristics to target demographic
- **Brand Alignment**: Ensure voice personality matches brand values and tone
- **Accessibility Requirements**: Choose clear, well-articulated voices for accessibility features

### Audio Quality Optimization

```python
# Optimal settings for different content types
VOICE_SETTINGS = {
    'documentation': {
        'stability': 0.7,
        'similarity_boost': 0.8,
        'model': 'eleven_multilingual_v2'
    },
    'marketing': {
        'stability': 0.5,
        'similarity_boost': 0.9,
        'model': 'eleven_monolingual_v1'
    },
    'tutorial': {
        'stability': 0.8,
        'similarity_boost': 0.6,
        'model': 'eleven_multilingual_v2'
    },
    'accessibility': {
        'stability': 0.9,
        'similarity_boost': 0.7,
        'model': 'eleven_multilingual_v2'
    }
}
```

### Agent Collaboration Tips

- Start with content-creator for script development and voice strategy
- Involve accessibility-auditor early for compliance requirements
- Use ux-researcher for voice preference testing and user feedback
- Deploy technical-writer for documentation audio creation
- Engage test-engineer for automated quality validation

### Performance Optimization

- **Batch Processing**: Group similar content for efficient API usage
- **Caching Strategy**: Cache frequently used audio segments
- **Streaming Implementation**: Use streaming for long-form content
- **Fallback Mechanisms**: Implement text fallbacks for accessibility

## Troubleshooting

### Common Issues

#### API Connection Problems

**Symptoms**: Connection timeouts, authentication errors

**Solutions**:

- Verify API key is correctly set in environment variables
- Check network connectivity and firewall settings
- Validate API key permissions and usage limits
- Test with minimal example to isolate issues

```bash
# Test API connection
curl -X GET "https://api.elevenlabs.io/v1/voices" \
  -H "xi-api-key: YOUR_API_KEY"
```

#### Audio Quality Issues

**Symptoms**: Robotic voice, poor pronunciation, unnatural intonation

**Solutions**:

- Adjust stability settings (higher for more consistent, lower for more expressive)
- Fine-tune similarity boost for voice authenticity
- Try different voice models for better language support
- Review text formatting and punctuation for proper pacing

```python
# Quality troubleshooting settings
quality_settings = {
    'robotic_voice': {'stability': 0.3, 'similarity_boost': 0.9},
    'poor_pronunciation': {'model': 'eleven_multilingual_v2'},
    'unnatural_pace': {'add_pauses': True, 'sentence_break_time': 0.8}
}
```

#### Rate Limiting and Quota Issues

**Symptoms**: HTTP 429 errors, quota exceeded messages

**Solutions**:

- Implement exponential backoff retry logic
- Monitor usage through ElevenLabs dashboard
- Optimize text length and batch requests efficiently
- Consider upgrading plan for higher limits

```python
import time
import random

def generate_with_retry(text, max_retries=3):
    """Generate speech with retry logic for rate limiting"""

    for attempt in range(max_retries):
        try:
            return elevenlabs_mcp.generate_speech(text=text, voice="Rachel")
        except RateLimitError:
            if attempt == max_retries - 1:
                raise
            # Exponential backoff with jitter
            delay = (2 ** attempt) + random.uniform(0, 1)
            time.sleep(delay)
```

#### Voice Cloning Problems

**Symptoms**: Poor voice similarity, cloning failures

**Solutions**:

- Ensure audio samples are high quality (22kHz+, clear speech)
- Provide at least 1 minute of clean audio per voice
- Use consistent recording conditions for all samples
- Avoid background noise and audio compression artifacts

#### MCP Server Issues

**Symptoms**: Server not responding, configuration errors

**Solutions**:

- Restart MCP server process
- Verify Python/Node.js version compatibility
- Check Claude settings.json syntax and configuration
- Review server logs for detailed error messages

```bash
# Debug MCP server connection
claude mcp debug elevenlabs
# View server logs
tail -f ~/.claude/logs/mcp-elevenlabs.log
```

### Performance Troubleshooting

#### Slow Audio Generation

**Solutions**:

- Use shorter text segments (under 500 characters)
- Implement parallel processing for multiple segments
- Cache frequently generated audio content
- Consider using streaming for real-time applications

#### Memory Issues with Large Files

**Solutions**:

- Stream audio directly to file system instead of memory
- Implement chunked processing for long documents
- Use temporary files for intermediate audio segments
- Monitor memory usage and implement cleanup routines

## Support Resources

- **ElevenLabs Documentation**: [docs.elevenlabs.io](https://docs.elevenlabs.io/)
- **API Reference**: [api.elevenlabs.io](https://api.elevenlabs.io/)
- **Voice Library**: [elevenlabs.io/voice-library](https://elevenlabs.io/voice-library)
- **MCP Protocol Docs**: Model Context Protocol specification
- **Agent Reference**: `system-configs/.claude/agents/` directory
- **Community Forum**: ElevenLabs Discord and GitHub discussions
- **Usage Analytics**: ElevenLabs dashboard for quota and usage monitoring

### Advanced Configuration

#### Custom Voice Training

For enterprise users requiring custom voice models:

```python
# Advanced voice training configuration
training_config = {
    'voice_name': 'Corporate_Narrator_2024',
    'training_files': [
        'samples/corporate_1.wav',
        'samples/corporate_2.wav',
        'samples/corporate_3.wav'
    ],
    'voice_description': 'Professional corporate narrator for training materials',
    'labels': {
        'accent': 'american',
        'age': 'middle_aged',
        'gender': 'female',
        'use_case': 'professional_narration'
    }
}
```

#### Integration with Content Management Systems

For automated content-to-audio workflows:

```python
def setup_cms_integration(cms_webhook_url):
    """Set up automatic audio generation from CMS updates"""

    cms_config = {
        'webhook_url': cms_webhook_url,
        'content_types': ['blog_post', 'documentation', 'tutorial'],
        'voice_mapping': {
            'blog_post': 'Rachel',
            'documentation': 'Daniel',
            'tutorial': 'Adam'
        },
        'output_formats': ['mp3', 'wav'],
        'storage_path': '/audio/generated/'
    }

    return cms_config
```

---

*This integration enables sophisticated audio content creation through AI-powered voice synthesis,
making digital content more accessible and engaging for diverse audiences worldwide.*
