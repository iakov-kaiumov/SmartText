# SmartText

SmartText is a SwiftUI package that provides `NSAttributedString` rendering in SwiftUI by wrapping `UITextView`

## Supported Platforms
* iOS 14.0+

## Usage
```swift
import AttributedText

struct ContentView: View {
    var body: some View {
        AttributedText(attributedString)
    }
}
```

`SmartText` view takes all the available width and adjusts its height to fit the contents.

## Installation
You can add AttributedText to an Xcode project by adding it as a package dependency.
1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
1. Enter `https://github.com/helfi2012/SmartText` into the package repository URL text field
1. Link **SmartText** to your application target
