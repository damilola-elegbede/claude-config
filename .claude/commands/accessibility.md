# /accessibility Command

## Description
Ensures comprehensive WCAG compliance and inclusive design through specialized accessibility-auditor and ux-accessibility agents to identify barriers, validate compliance, and enhance user experience for all abilities.

## Usage
```
/accessibility [scope] [options]
```

## Arguments
- `scope` (optional): Area to audit
  - `web`: Web application accessibility
  - `mobile`: Mobile app accessibility  
  - `api`: API accessibility considerations
  - `content`: Content accessibility
  - `full`: Complete accessibility audit (default)

## Options
- `--standard <level>`: WCAG compliance level (A, AA, AAA)
- `--platform <target>`: Platform focus (web, ios, android, desktop)
- `--tools <suite>`: Testing tools (axe, wave, pa11y, lighthouse)
- `--remediate`: Generate accessibility fixes
- `--report <format>`: Output format (json, html, pdf, summary)

## Behavior
When you use `/accessibility`, I will coordinate comprehensive accessibility evaluation:

### Phase 1 (Parallel Assessment - 0-20 min)
1. **Launch accessibility-auditor agent** for:
   - WCAG 2.1 compliance assessment
   - Automated testing with multiple tools
   - Manual testing simulation
   - Keyboard navigation validation
   - Screen reader compatibility
   - Color contrast analysis

2. **Deploy ux-accessibility agent** for:
   - User experience evaluation
   - Inclusive design assessment
   - Cognitive load analysis
   - Motor accessibility review
   - Visual accessibility evaluation
   - Assistive technology compatibility

3. **Coordinate with frontend-specialist** for:
   - Semantic HTML structure analysis
   - ARIA implementation review
   - Focus management assessment
   - Form accessibility validation
   - Interactive element evaluation

### Phase 2 (Specialized Testing - 20-45 min)
1. **Automated testing execution**:
   - axe-core accessibility engine
   - WAVE web accessibility evaluation
   - Lighthouse accessibility audit
   - pa11y command line testing
   - Color contrast analyzers

2. **Manual testing simulation**:
   - Keyboard-only navigation
   - Screen reader workflows
   - Voice control compatibility
   - High contrast mode testing
   - Zoom functionality validation

### Phase 3 (Remediation - 45+ min)
1. **Issue prioritization and fixes**:
   - Critical barrier identification
   - Implementation recommendations
   - Code generation for fixes
   - Testing validation procedures
   - Compliance documentation

## Examples
```
/accessibility                                  # Full WCAG AA audit
/accessibility web --standard AAA               # Web AAA compliance
/accessibility mobile --platform ios           # iOS accessibility audit
/accessibility --remediate --tools axe,wave    # Audit with automated fixes
/accessibility content --report pdf            # Content audit with PDF report
/accessibility api --standard AA               # API accessibility review
```

## Accessibility Categories

### WCAG 2.1 Principles
- **Perceivable**: Information presentable to users in ways they can perceive
- **Operable**: Interface components operable by all users
- **Understandable**: Information and UI operation understandable
- **Robust**: Content robust enough for various assistive technologies

### Compliance Levels
- **Level A**: Basic accessibility features (minimum)
- **Level AA**: Standard accessibility (recommended for most)
- **Level AAA**: Enhanced accessibility (government/healthcare)

### Common Barriers
- **Visual**: Color contrast, text size, alternative text
- **Motor**: Keyboard navigation, click targets, timeouts
- **Auditory**: Captions, transcripts, audio descriptions
- **Cognitive**: Clear language, consistent navigation, error prevention

## Multi-Agent Orchestration

### Comprehensive Audit Pattern
```
PHASE 1 (Parallel - 20 min):
├── accessibility-auditor: WCAG compliance testing
├── ux-accessibility: User experience evaluation
└── frontend-specialist: Technical implementation review

PHASE 2 (Sequential - 25 min):
├── accessibility-auditor: Automated tool execution
├── ux-accessibility: Manual testing simulation
└── content-specialist: Content accessibility review

PHASE 3 (Parallel - 20 min):
├── frontend-specialist: Code fix implementation
├── accessibility-auditor: Validation testing
└── tech-writer: Documentation updates
```

### Platform-Specific Patterns
```
Mobile Accessibility (iOS/Android):
├── mobile-specialist: Platform-specific guidelines
├── accessibility-auditor: Mobile WCAG testing
└── ux-accessibility: Touch accessibility evaluation

API Accessibility:
├── api-specialist: Accessible data structure
├── accessibility-auditor: Documentation compliance
└── frontend-specialist: Client implementation guidance
```

## Testing Methodology

### Automated Testing Tools
- **axe-core**: Comprehensive accessibility rules engine
- **WAVE**: Web accessibility evaluation tool
- **Lighthouse**: Google's accessibility audit
- **pa11y**: Command line accessibility testing
- **Tenon**: Cloud-based accessibility testing
- **Deque WorldSpace**: Enterprise accessibility platform

### Manual Testing Procedures
- **Keyboard Navigation**: Tab order, focus management, shortcuts
- **Screen Reader**: NVDA, JAWS, VoiceOver compatibility
- **Voice Control**: Dragon NaturallySpeaking, Voice Access
- **Switch Navigation**: Single-switch, dual-switch devices
- **Eye Tracking**: Tobii, Eye Gaze systems

### User Testing Scenarios
- **Low Vision**: Magnification, high contrast, color blindness
- **Blindness**: Screen reader, braille display, voice navigation
- **Motor Impairments**: Keyboard-only, switch devices, voice control
- **Cognitive Disabilities**: Memory, attention, processing speed
- **Hearing Impairments**: Captions, sign language, visual indicators

## Advanced Features

### Inclusive Design Patterns
- **Progressive Enhancement**: Core functionality for all
- **Responsive Design**: Flexible layouts and interactions
- **Multi-Modal Interfaces**: Multiple ways to interact
- **Error Recovery**: Clear error messages and correction
- **Cognitive Support**: Memory aids, progress indicators

### Assistive Technology Integration
- **Screen Readers**: Semantic markup, ARIA labels
- **Voice Control**: Voice commands, speech recognition
- **Switch Devices**: Switch navigation, timing controls
- **Eye Tracking**: Gaze-based interaction patterns
- **Brain-Computer Interfaces**: Emerging technology support

### Content Accessibility
- **Alternative Text**: Images, graphics, charts
- **Video Accessibility**: Captions, transcripts, audio descriptions
- **Document Accessibility**: PDF, Word, PowerPoint compliance
- **Data Visualization**: Accessible charts and graphs
- **Interactive Content**: Games, simulations, multimedia

## Platform-Specific Guidelines

### Web Accessibility
- **HTML Semantics**: Proper heading structure, landmarks
- **CSS Considerations**: Focus indicators, responsive design
- **JavaScript**: Dynamic content, ARIA live regions
- **Forms**: Labels, validation, error handling
- **Media**: Video players, audio controls

### Mobile Accessibility
- **iOS**: VoiceOver, Switch Control, AssistiveTouch
- **Android**: TalkBack, Switch Access, Voice Access
- **Touch Targets**: Minimum 44x44 px clickable areas
- **Gestures**: Alternative interaction methods
- **Dynamic Type**: Text scaling support

### Desktop Applications
- **Windows**: Narrator, JAWS, Dragon NaturallySpeaking
- **macOS**: VoiceOver, Switch Control, Voice Control
- **Linux**: Orca, Speech Dispatcher, AT-SPI
- **Cross-Platform**: Qt, Electron accessibility APIs

## Compliance Documentation

### Legal Requirements
- **ADA**: Americans with Disabilities Act compliance
- **Section 508**: Federal agency requirements
- **EN 301 549**: European accessibility standard
- **AODA**: Accessibility for Ontarians with Disabilities Act
- **DDA**: Australian Disability Discrimination Act

### Industry Standards
- **ISO 14289**: PDF accessibility standard
- **ISO 40500**: Web accessibility standard (WCAG 2.1)
- **EPUB Accessibility**: Digital publishing accessibility
- **Mobile Accessibility**: iOS/Android platform guidelines

## Output Deliverables

1. **Accessibility Audit Report**: Comprehensive compliance assessment
2. **Issue Priority Matrix**: Critical to minor accessibility barriers
3. **Remediation Roadmap**: Step-by-step implementation plan
4. **Code Fixes**: Ready-to-implement accessibility improvements
5. **Testing Scripts**: Automated accessibility test suites
6. **Training Materials**: Team accessibility education resources
7. **Compliance Documentation**: Legal and regulatory evidence

## Best Practices Implementation

### Design Principles
- **Universal Design**: Usable by all people, to the greatest extent possible
- **Inclusive First**: Consider accessibility from the beginning
- **Progressive Enhancement**: Build accessibility into the foundation
- **User-Centered**: Design with real user needs and testing
- **Continuous Testing**: Regular accessibility validation

### Development Standards
- **Semantic HTML**: Use proper HTML elements for their intended purpose
- **ARIA Best Practices**: Enhance semantics without overriding
- **Keyboard Support**: Full functionality via keyboard
- **Focus Management**: Logical focus order and visible indicators
- **Error Handling**: Clear, actionable error messages

## Integration Points

### Development Workflow
- **CI/CD Integration**: Automated accessibility testing
- **Code Reviews**: Accessibility checkpoint requirements
- **Design Systems**: Accessible component libraries
- **Testing Frameworks**: Accessibility test integration
- **Quality Gates**: Accessibility requirements for deployment

### Monitoring and Maintenance
- **Continuous Monitoring**: Ongoing accessibility validation
- **User Feedback**: Accessibility issue reporting system
- **Regular Audits**: Periodic comprehensive reviews
- **Training Programs**: Team accessibility education
- **Compliance Tracking**: Legal requirement monitoring

## Success Metrics

### Compliance Metrics
- **WCAG Conformance**: Percentage of criteria met
- **Issue Resolution**: Time to fix accessibility barriers
- **Test Coverage**: Automated test coverage percentage
- **User Satisfaction**: Accessibility user feedback scores
- **Legal Compliance**: Adherence to regulatory requirements

### User Experience Metrics
- **Task Completion**: Success rates for users with disabilities
- **Navigation Efficiency**: Time to complete common tasks
- **Error Recovery**: Success in correcting mistakes
- **User Retention**: Accessibility user engagement metrics
- **Feedback Quality**: Actionable user accessibility feedback

## Prerequisites
- **Application Access**: Running application or prototypes
- **Design Assets**: UI designs, wireframes, style guides
- **Content Samples**: Representative text, images, media
- **Platform Information**: Target devices, browsers, assistive technologies
- **Compliance Requirements**: Specific legal or organizational standards

## Notes
- Emphasizes both compliance and user experience
- Integrates automated and manual testing approaches
- Supports multiple platforms and assistive technologies
- Provides actionable remediation guidance
- Considers emerging accessibility technologies
- Balances comprehensive coverage with practical implementation