# Contributing to Plant Tycoon

Thank you for your interest in contributing to Plant Tycoon! This document provides guidelines and instructions for contributing.

## 🌟 Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🎨 Enhance UI/UX
- 🔧 Fix issues
- ✨ Add new plant types or mechanics

## 🚀 Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/plant-tycoon.git`
3. Create a branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test thoroughly
6. Commit: `git commit -m "Add: your feature description"`
7. Push: `git push origin feature/your-feature-name`
8. Open a Pull Request

## 📋 Code Guidelines

### Swift Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

### SwiftUI Best Practices

- Use `@State` for view-local state
- Use `@EnvironmentObject` for shared state
- Extract reusable components
- Keep views lightweight

### Architecture

- Follow MVVM pattern
- Models: Pure data structures (no business logic)
- ViewModels: Business logic and state management
- Views: UI only, observe ViewModels
- Services: Utility functions

### Example

```swift
// ✅ Good
struct Plant: Identifiable, Codable {
    let id: UUID
    var health: Double
    
    mutating func water() {
        health = min(100, health + 15)
    }
}

// ❌ Bad
struct Plant {
    var h: Double  // Unclear name
    
    func doStuff() {  // Vague function name
        h = h + 15
    }
}
```

## 🧪 Testing

Before submitting a PR:

1. Build the project without errors
2. Test on iOS Simulator
3. Test all affected features
4. Check for memory leaks (Instruments)
5. Verify save/load functionality

## 📝 Commit Messages

Use clear, descriptive commit messages:

- `Add: New plant type - Bonsai`
- `Fix: Market trend not refreshing after 2 minutes`
- `Update: Increase fertilize cooldown to 3 minutes`
- `Refactor: Extract PlantCard into separate component`
- `Docs: Add gameplay tips to README`

## 🐛 Reporting Bugs

When reporting bugs, include:

1. **Description**: What happened?
2. **Expected behavior**: What should happen?
3. **Steps to reproduce**: How to trigger the bug?
4. **Environment**: iOS version, device/simulator
5. **Screenshots**: If applicable
6. **Save data**: Export your save if relevant

### Bug Report Template

```markdown
**Bug Description**
Plants stop growing after hiring gardener

**Expected Behavior**
Plants should continue growing automatically

**Steps to Reproduce**
1. Start new game
2. Hire gardener
3. Wait 5 minutes
4. Plants are frozen at current growth

**Environment**
- iOS 17.0
- iPhone 15 Simulator
- Xcode 15.2

**Additional Context**
Happens only after hiring gardener, not marketer
```

## 💡 Feature Requests

When suggesting features, include:

1. **Feature description**: What do you want?
2. **Use case**: Why is it useful?
3. **Implementation ideas**: How could it work?
4. **Mockups**: Visual examples (optional)

## 🎨 UI/UX Contributions

- Maintain dark theme consistency
- Use SF Symbols where appropriate
- Follow iOS Human Interface Guidelines
- Test on different screen sizes
- Ensure accessibility (VoiceOver, Dynamic Type)

## 🔄 Pull Request Process

1. **Update documentation** if needed
2. **Add comments** to complex code
3. **Test thoroughly** on simulator
4. **Keep PRs focused** - one feature per PR
5. **Respond to feedback** promptly

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on iOS Simulator
- [ ] Tested save/load
- [ ] No build warnings
- [ ] No memory leaks

## Screenshots
(if applicable)

## Checklist
- [ ] Code follows project style
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

## 🎯 Priority Areas

Current priorities for contributions:

1. **Performance optimization** - Reduce memory usage
2. **New plant types** - Add more variety
3. **Achievements system** - Track player milestones
4. **Sound effects** - Add audio feedback
5. **Animations** - Enhance visual polish
6. **Localization** - Support more languages

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift Style Guide](https://google.github.io/swift/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)

## ❓ Questions?

- Open an issue with the `question` label
- Check existing issues first
- Be respectful and patient

## 📜 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help others learn and grow

---

Thank you for contributing to Plant Tycoon! 🌱
