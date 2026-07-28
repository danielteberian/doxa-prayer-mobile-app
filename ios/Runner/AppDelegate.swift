import FirebaseCore
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Retained so the badge channel's handler isn't torn down after setup.
  private var badgeChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Reads GoogleService-Info.plist from the app bundle. The correct per-flavor
    // plist must be present for the active flavor — see FIREBASE_CRASHLYTICS_SETUP.md
    // ("iOS" section) for the per-flavor plist + build-phase setup.
    FirebaseApp.configure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Reset the app-icon badge on request from Dart (clearNotificationBadge).
    // flutter_local_notifications can set a badge but not clear it, so we do it
    // natively here.
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "DoxaBadgePlugin")
    if let messenger = registrar?.messenger() {
      let channel = FlutterMethodChannel(
        name: "app.prayer.doxa/badge", binaryMessenger: messenger)
      channel.setMethodCallHandler { call, result in
        guard call.method == "clearBadge" else {
          result(FlutterMethodNotImplemented)
          return
        }
        if #available(iOS 16.0, *) {
          UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
          UIApplication.shared.applicationIconBadgeNumber = 0
        }
        result(nil)
      }
      badgeChannel = channel
    }
  }
}
