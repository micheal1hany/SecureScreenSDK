# SecureScreenSDK

![iOS](https://img.shields.io/badge/iOS-13.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.7%2B-orange)
![SPM](https://img.shields.io/badge/SwiftPM-compatible-green)

SecureScreenSDK is a lightweight Swift SDK to prevent screen captures and detect screen recordings in iOS apps. It works with both UIKit and SwiftUI.

---

## 🚀 Features

- 🔒 Prevent screenshots using secure rendering
- 🎥 Detect screen recording (iOS 11+)
- 💡 Optionally blur, overlay color, or image while recording
- 🧩 SwiftUI support with `.screenProtected()` modifier
- 🧱 UIKit support via `SecureScreenViewController`
- 🧰 Global configuration support from AppDelegate

---

## 📦 Installation

### Swift Package Manager

Add this repo URL to your Xcode project under:
**File > Add Packages**

```text
https://github.com/micheal1hany/SecureScreenSDK.git
```

---

## 🧰 Usage

### ✅ SwiftUI (Recommended)

```swift
import SecureScreenSDK

Text("Protected content")
    .screenProtected(
        detectRecording: true,
        blurStyle: .dark // Or overlayColor / overlayImage
    )
```

You can also receive recording changes:

```swift
.screenProtected(detectRecording: true) { isRecording in
    print("Recording: \(isRecording)")
}
```

---

### ✅ UIKit with inheritance

```swift
import SecureScreenSDK

final class MyVC: SecureScreenViewController {
    override var screenProtectedDetectRecording: Bool { true }
    override var screenProtectedBlurStyle: UIBlurEffect.Style? { .dark }

    override func handleScreenProtectedRecordingState(_ isCaptured: Bool) {
        print("Recording changed: \(isCaptured)")
    }
}
```

---

### ✅ UIKit without inheritance

```swift
let screenManager = SecureScreenSDK(window: myWindow)
screenManager.configurePreventionScreenshot()
screenManager.enabledPreventScreenshot()
```

---

### ✅ Global Configuration (AppDelegate or SwiftUI)

You can enable protection globally from the AppDelegate (UIKit) or from the SwiftUI entry point:

```swift
// UIKit (AppDelegate)
import SecureScreenSDK

class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var SecureScreenSDK = { return SecureScreenSDK(window: window) }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SecureScreenSDK.configurePreventionScreenshot()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SecureScreenSDK.enabledPreventScreenshot()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        SecureScreenSDK.disablePreventScreenshot()
    }
}
```

#### Blur Background
```swift
func applicationWillResignActive(_ application: UIApplication) {
    SecureScreenSDK.enabledBlurScreen()
}

func applicationDidBecomeActive(_ application: UIApplication) {
    SecureScreenSDK.disableBlurScreen()
}
```

#### Color Overlay
```swift
func applicationWillResignActive(_ application: UIApplication) {
    SecureScreenSDK.enabledColorScreen(color: .black)
}

func applicationDidBecomeActive(_ application: UIApplication) {
    SecureScreenSDK.disableColorScreen()
}
```

#### Image Overlay
```swift
func applicationWillResignActive(_ application: UIApplication) {
    SecureScreenSDK.enabledImageScreen(image: UIImage(named: "LaunchImage"))
}

func applicationDidBecomeActive(_ application: UIApplication) {
    SecureScreenSDK.disableImageScreen()
}
```

#### SwiftUI Global Setup
If you're using a SwiftUI-only app, you can configure global screen protection by applying the `.screenProtected()` modifier to your root `ContentView()` inside `@main`:

```swift
@main
struct MySecureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .screenProtected(
                    detectRecording: true,
                    blurStyle: .dark
                )
        }
    }
}
```

This ensures all views are protected from launch without needing AppDelegate or UIWindow references.
```swift
@main
struct MySecureApp: App {
    private let SecureScreenSDK = SecureScreenSDK(window:
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow })

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    SecureScreenSDK.configurePreventionScreenshot()
                    SecureScreenSDK.enabledPreventScreenshot()
                }
                .onDisappear {
                    SecureScreenSDK.disablePreventScreenshot()
                }
        }
    }
}
```

#### Check screen recording
```swift
let isRecording = SecureScreenSDK.screenIsRecording()
```

---

### 🧪 Simulator Notes

- The **Trigger Screenshot** option from the **Simulator > Device** menu does simulate a real screenshot event.
- You can test `UIApplication.userDidTakeScreenshotNotification` **in Simulator** using that option.
- Screen recording detection (`UIScreen.isCaptured`) is only accurate on **physical devices**.

---

## 🛠 Requirements

- iOS 13.0+
- Swift 5.7+

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).

---



Enjoy building secure UIs! 🛡️
