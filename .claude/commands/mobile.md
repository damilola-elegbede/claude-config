# /mobile Command

## Description
Quickly access expert mobile development through Claude orchestration for production-scale native and cross-platform applications. Claude coordinates with the mobile-platform-engineer specialist who specializes in apps supporting 1M+ DAU with 99.9% crash-free rates, sub-3s app launch times, and seamless offline-first architectures synchronizing across devices.

## Behavior
This command coordinates with the mobile-platform-engineer specialist to architect and implement enterprise-grade mobile applications including real-time synchronization, advanced performance optimization achieving 60fps on mid-tier devices, comprehensive security implementations meeting banking standards, and scalable architectures supporting millions of users.

## Usage
```
/mobile [specific mobile platform requirement]
```

## Real-World Use Cases

### High-Performance Native Development
- `/mobile optimize iOS app from 5s to <2s launch time using lazy loading and precomputation`
- `/mobile implement Android app handling 10K+ offline records with SQLite optimization`
- `/mobile build real-time chat with WebSocket reconnection and message queueing`
- `/mobile create camera pipeline processing 4K video with Core Image/Camera2 API`

### Cross-Platform Architecture
- `/mobile design React Native app sharing 80% code between iOS/Android with native modules`
- `/mobile implement Flutter app with custom platform channels for device-specific features`
- `/mobile build offline-first sync resolving conflicts across 5+ device types`
- `/mobile create modular architecture supporting white-label apps with feature toggles`

### Enterprise Integration
- `/mobile implement SSO with biometric authentication and certificate pinning`
- `/mobile build MDM-compliant app with remote wipe and policy enforcement`
- `/mobile create push notification system handling 1M+ daily notifications with segmentation`
- `/mobile implement background sync with exponential backoff and battery optimization`

## Expert Capabilities

### Native iOS Development Mastery
- **SwiftUI & UIKit**: Advanced layouts, custom animations, performance optimization
- **Core Data**: Complex data models, migration strategies, CloudKit synchronization  
- **Background Processing**: BGTaskScheduler, silent push, efficient battery usage
- **Security**: Keychain integration, biometric authentication, certificate pinning

### Native Android Development Excellence
- **Kotlin & Compose**: Modern UI development with state management and navigation
- **Architecture Components**: ViewModel, LiveData, Room with migration strategies
- **Background Tasks**: WorkManager, foreground services, Doze mode optimization
- **Performance**: Memory profiling, ANR prevention, startup time optimization

### Cross-Platform Expertise
- **React Native**: Bridge optimization, native modules, CodePush deployments
- **Flutter**: Custom widgets, platform channels, state management (Riverpod, Bloc)
- **Xamarin**: .NET integration, platform-specific implementations
- **Ionic**: Capacitor plugins, hybrid app performance optimization

### Mobile Performance Engineering
- **Memory Management**: ARC optimization, leak detection, efficient data structures
- **Rendering Optimization**: 60fps scrolling, image caching, view recycling
- **Network Efficiency**: Request batching, caching strategies, offline queuing
- **Battery Optimization**: Background execution limits, location services tuning

## Performance Benchmarks
- **App Launch Time**: <2s cold start, <1s warm start on mid-tier devices
- **Crash-Free Rate**: >99.5% with comprehensive crash reporting and symbolication
- **Memory Usage**: <150MB peak for data-intensive apps, proper memory cleanup
- **Battery Impact**: <5% drain per hour of active usage with location services

## Technology Stack Expertise

### iOS Development Stack
- **Languages**: Swift 5.x with async/await, SwiftUI, Objective-C interop
- **Frameworks**: Foundation, UIKit, SwiftUI, Core Data, CloudKit, Network
- **Tools**: Xcode Instruments, TestFlight, App Store Connect API
- **Testing**: XCTest, UI testing, snapshot testing with FBSnapshotTestCase

### Android Development Stack  
- **Languages**: Kotlin with coroutines, Java interoperability
- **Frameworks**: Jetpack Compose, Android Architecture Components, Room, Retrofit
- **Tools**: Android Studio Profiler, Play Console, Gradle optimization
- **Testing**: JUnit, Espresso, Robolectric for unit and integration testing

### Cross-Platform Frameworks
- **React Native**: Metro bundler, Flipper debugging, Fastlane automation
- **Flutter**: Dart language, widget testing, platform-specific implementations
- **State Management**: Redux/MobX (RN), Provider/Riverpod (Flutter)
- **CI/CD**: GitHub Actions, Bitrise, Azure DevOps with automated testing

### Backend Integration
- **API Integration**: RESTful services, GraphQL with Apollo, real-time WebSockets  
- **Authentication**: OAuth2, OIDC, biometric authentication, social login
- **Data Synchronization**: Delta sync, conflict resolution, optimistic updates
- **Push Notifications**: FCM, APNs with segmentation and analytics

## Anti-Patterns Avoided
- **Main Thread Blocking**: Async operations, background queues, UI responsiveness
- **Memory Leaks**: Proper cleanup, weak references, retain cycle prevention
- **Battery Drain**: Location services optimization, background task limits
- **Security Vulnerabilities**: Certificate pinning, data encryption, secure storage
- **Poor Offline Experience**: Data caching, sync conflict resolution, queue management

## When to Engage

### Complexity Triggers
- Apps supporting >100K MAU requiring performance optimization
- Real-time features with <500ms message delivery requirements  
- Offline-first architecture with complex sync conflict resolution
- Multi-platform deployment with 80%+ code sharing requirements
- Enterprise security requirements (banking, healthcare, government)

### Scale Indicators
- Database operations on >50K local records requiring optimization
- Push notification campaigns to >1M users with segmentation
- Background sync handling >10K API calls with rate limiting
- Multi-tenant architecture supporting white-label deployments
- App store presence in >20 countries with localization requirements

## Related Commands
- `/backend` - For mobile API development and real-time infrastructure
- `/api` - For mobile-first API design and GraphQL implementation
- `/perf` - For advanced performance profiling and optimization
- `/security` - For mobile security audits and compliance requirements
