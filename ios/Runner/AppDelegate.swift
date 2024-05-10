import UIKit
import Flutter
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    application.registerForRemoteNotifications()
    if #available(iOS 10.0, *) {
                      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //GeneratedPluginRegistrant.register(with: self)
        var applicationResult = false

        if (!applicationResult) {
          applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        }

        if (!applicationResult) {
           applicationResult = super.application(app, open: url, options: options)
        }

        return applicationResult
    }
}
