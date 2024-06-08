# DisplayLink
![Swift Version](https://img.shields.io/badge/Swift-5.1+-orange.svg) ![iOS Version](https://img.shields.io/badge/iOS-13+-orange.svg) ![macOS Version](https://img.shields.io/badge/macOS-10.15+-orange.svg)

A  `DisplayLink` for iOS & macOS.

## Usage

```swift
import DisplayLink
// create it
let displayLink = DisplayLink()
// activate it
displayLink.activate()
// subscribe
import Combine
displayLink.frameSubject.sink(receiveValue: { (frameTimestamp: CFTimeInterval) in
    print(frameTimestamp)
)}
```

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
dependencies: [
    .package(url: "https://github.com/IgorMuzyka/DisplayLink", .upToNextMajor(from: "1.0.0")),
]
```

