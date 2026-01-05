
# OpenGallery

![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-lightgrey)
![License](https://img.shields.io/badge/License-MIT-blue)

**OpenGallery** is a sample iOS project focused on **clean architecture**, **testability**, and **networking design**.  
The app demonstrates how to load and display remote artwork data using a modular and well-tested API layer.

---

## 📱 Features

- Remote feed loading via a dedicated API layer
- Clear separation of concerns (networking, domain, presentation)
- High test coverage for core logic
- Fast macOS-based CI test execution
- GitHub Actions integration
- Clean and readable Swift code

---

## Architecture

The project follows a modular and test-driven architecture inspired by Clean Architecture principles.

### Key Concepts

**RemoteFeedLoader**
- Responsible for fetching remote data
- Decoupled from UI and concrete networking implementations
- Fully unit-tested

**Separation of Layers**
- Domain logic is independent from UI
- Networking details are isolated
- Easier refactoring and extension

---

## Testing

Tests are designed to run natively on macOS, avoiding iOS simulators for faster CI feedback.

### Run tests in Xcode

- Product → Test (`⌘U`)

### Run tests from terminal

```bash
xcodebuild test \
  -project Artwork/Artwork.xcodeproj \
  -scheme CI \
  -sdk macosx \
  -destination 'platform=macOS'
```

---

### Continuous Integration

This project uses GitHub Actions to automatically:

Build the project

Run all tests

Validate pull requests before merging into main

Workflow file:

```bash
.github/workflows/ci.yml
```

---

Getting Started
Requirements

- macOS

- Xcode 15 or later

- Swift 5.9 or later

Setup

```bash
git clone https://github.com/rafaelnunesr/OpenGallery.git
cd OpenGallery
open Artwork/Artwork.xcodeproj
```

Select the CI scheme and run the project.

### Project Structure
```bash
OpenGallery/
├── Artwork/
│   ├── Artwork.xcodeproj
│   └── ...
├── .github/workflows/
├── .gitignore
└── README.md
```

### License

This project is licensed under the MIT License.
See the LICENSE file for details.

### Motivation

OpenGallery exists as a learning playground to explore:

- Networking abstractions

- Test-driven development

- CI pipelines

- Clean Swift code
