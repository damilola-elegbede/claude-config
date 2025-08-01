# /frontend Command

## Description
Quickly access expert frontend engineering through Claude orchestration for production-scale client-side applications. Claude coordinates with the frontend-architect specialist who specializes in high-performance web applications serving 100K+ concurrent users with Core Web Vitals scores in the 90+ range and sub-300ms time-to-interactive.

## Behavior
This command coordinates with the frontend-architect specialist to architect and implement enterprise-grade frontend systems including micro-frontends, real-time applications with WebSocket/SSE, advanced state management patterns, and accessibility-compliant interfaces meeting WCAG 2.1 AA standards.

## Usage
```
/frontend [specific performance or architecture requirement]
```

## Real-World Use Cases

### High-Performance Applications
- `/frontend optimize React app from 3.2s to <1s LCP using code splitting and lazy loading`
- `/frontend implement virtualization for 100K+ row data tables with <16ms frame times`
- `/frontend reduce bundle size from 2.5MB to <500KB using tree shaking and dynamic imports`
- `/frontend build PWA with offline-first architecture and 99.9% cache hit ratio`

### Enterprise Architecture
- `/frontend design micro-frontend architecture with module federation and shared state`
- `/frontend implement real-time dashboard handling 10K+ WebSocket connections with Redux Toolkit`
- `/frontend build design system with 50+ components supporting dark/light themes`
- `/frontend create A/B testing framework with feature flags and analytics integration`

### Performance Engineering
- `/frontend eliminate CLS by implementing skeleton loading for dynamic content`
- `/frontend optimize First Input Delay from 200ms to <100ms using web workers`
- `/frontend implement service worker with advanced caching strategies for 95% offline functionality`
- `/frontend profile and fix memory leaks causing 50MB+ heap growth in SPA`

## Expert Capabilities

### Performance Optimization Mastery
- **Core Web Vitals**: LCP <2.5s, FID <100ms, CLS <0.1 across all device types
- **Bundle Optimization**: Webpack/Vite configuration reducing initial load by 60%+
- **Critical Path**: Above-the-fold rendering in <1s on 3G connections
- **Memory Management**: Preventing memory leaks in long-running SPAs with event cleanup

### Modern Framework Expertise
- **React**: Concurrent features, Suspense, server components, custom hooks optimization
- **Vue 3**: Composition API, Teleport, advanced reactivity with performance monitoring
- **Angular**: Lazy loading, OnPush strategy, standalone components, RxJS optimization
- **Svelte/SvelteKit**: Compile-time optimizations, stores, server-side rendering

### State Management Architecture
- **Redux Toolkit**: Normalized state, RTK Query for data fetching, performance patterns
- **Zustand**: Lightweight state management with persistence and devtools integration  
- **Recoil/Jotai**: Atomic state management for complex dependency graphs
- **Context Optimization**: Preventing unnecessary re-renders with strategic context splitting

### Real-Time & Progressive Features
- **WebSocket Management**: Auto-reconnection, message queuing, connection pooling
- **Server-Sent Events**: Long-lived connections with automatic fallback strategies
- **Progressive Web Apps**: Service workers, app shell architecture, push notifications
- **Offline-First**: Background sync, conflict resolution, storage quota management

## Performance Benchmarks
- **Lighthouse Scores**: 90+ across Performance, Accessibility, Best Practices, SEO
- **Time to Interactive**: <3s on 3G, <1s on broadband connections
- **Bundle Sizes**: <250KB initial, <100KB per route with effective code splitting
- **Runtime Performance**: 60fps scrolling, <16ms frame times for animations

## Technology Stack Expertise

### Build Tools & Bundlers
- **Vite**: Lightning-fast HMR, native ESM, optimized production builds
- **Webpack 5**: Module federation, advanced optimization, custom plugins
- **Rollup**: Library bundling with tree shaking and format flexibility
- **Parcel**: Zero-config bundling with automatic optimization

### CSS Architecture
- **CSS Modules**: Scoped styles with composition and theming support
- **Styled Components**: Dynamic styling with theme providers and SSR optimization
- **Tailwind CSS**: Utility-first design with JIT compilation and purging
- **PostCSS**: Advanced preprocessing with autoprefixer and optimization plugins

### Testing & Quality Assurance
- **Jest/Vitest**: Unit testing with coverage reporting and snapshot testing
- **React Testing Library**: Integration testing with accessibility-focused queries
- **Playwright/Cypress**: E2E testing with visual regression and performance audits
- **Storybook**: Component development with visual testing and documentation

### Accessibility & Standards
- **WCAG 2.1 AA**: Keyboard navigation, screen reader support, color contrast
- **ARIA Patterns**: Complex widgets like comboboxes, data grids, carousels
- **Focus Management**: Skip links, focus trapping, logical tab sequences
- **Semantic HTML**: Proper landmark structure and heading hierarchies

## Anti-Patterns Avoided
- **Prop Drilling**: Context API or state management solutions for deep component trees  
- **Unnecessary Re-renders**: Memoization strategies and state structure optimization
- **Bundle Bloat**: Lazy loading, code splitting, and dependency analysis
- **Accessibility Afterthoughts**: A11y-first development with automated testing
- **Memory Leaks**: Proper cleanup of event listeners, timers, and subscriptions

## When to Engage

### Complexity Triggers
- Applications serving >10K concurrent users with real-time updates
- Core Web Vitals scores below 75 requiring optimization
- Complex state management across 20+ components with data dependencies
- Accessibility requirements beyond basic compliance (government, healthcare)
- Micro-frontend architecture with multiple teams and shared dependencies

### Scale Indicators
- Bundle sizes >2MB requiring optimization strategies
- Data tables/lists with >1K items needing virtualization
- Real-time features with >100 concurrent WebSocket connections
- Multi-language support with dynamic locale switching
- Cross-platform deployment (web, mobile web, electron, PWA)

## Related Commands
- `/mobile` - For mobile-specific optimizations and React Native
- `/api` - For frontend-backend integration and GraphQL implementation
- `/perf` - For advanced performance profiling and Core Web Vitals optimization
- `/security` - For CSP, XSS prevention, and client-side security audits
