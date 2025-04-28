//
//  SecureScreenManager.swift
//  SecureScreenSDK
//
//  Created by Micheal Hany on 4/22/25.
//

import UIKit

/// A lightweight convenience wrapper to manage SecureScreenSDK lifecycle in SwiftUI or UIKit.
public final class SecureScreenManager {

    private var screenProtector: SecureScreenSDK?

    /// Initializes an empty manager. Call `enable()` to activate protection.
    public init() {}

    /// Enables screenshot protection and optionally starts screen recording detection.
    /// - Parameters:
    ///   - recordingDetection: Whether to observe screen recording state.
    ///   - onRecordingChange: Callback invoked when recording state changes.
    public func enable(recordingDetection: Bool = false, onRecordingChange: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
#if DEBUG
            print("⚠️ SecureScreen:  No active UIWindow found")
#endif
            return
        }

        let protector = SecureScreenSDK(window: window)
        protector.configurePreventionScreenshot()
        protector.enabledPreventScreenshot()
        self.screenProtector = protector

        if recordingDetection, #available(iOS 11.0, *) {
            protector.screenRecordObserver { isCaptured in
                onRecordingChange?(isCaptured)
            }
        }
    }

    /// Disables all screen protection and removes observers.
    public func disable() {
        screenProtector?.disablePreventScreenshot()
        screenProtector?.removeAllObserver()
        screenProtector = nil
    }

    /// Exposes the underlying SecureScreenSDK instance for advanced use.
    public var raw: SecureScreenSDK? {
        return screenProtector
    }
}
