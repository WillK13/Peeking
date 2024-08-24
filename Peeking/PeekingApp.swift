//
//  PeekingApp.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import UserNotifications
import RevenueCat

@main
struct PeekingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appViewModel = AppViewModel()
    
//    private var f = false
//    @State private var usersi = "JxLbyqyg3wOwZPEvOpBOlWYosy33"

    var body: some Scene {
        WindowGroup {
            ZStack {
                if appViewModel.isLoading {
                    LoadingView()
                } else {
                    if Auth.auth().currentUser == nil {
                        firstView()
                            .environmentObject(appViewModel)
                    } else if appViewModel.shouldShowContentView {
                        ContentView()
                            .environmentObject(appViewModel)
                    } else {
                        Welcome()
                            .environmentObject(appViewModel)
                    }
//                    ProfileShare(userId: $usersi, needsButtons: .constant(false))
//                            .environmentObject(appViewModel)
//                     Commenting out ProfileConfirmationEmployer
//                     ProfileConfirmation()
//                        .environmentObject(appViewModel)
//                    firstView()
//                        .environmentObject(appViewModel)

                }
            }
            .onAppear {
                appViewModel.checkUserProfile()
            }
        }
    }
//    init() {
//        if let firebaseUserId = Auth.auth().currentUser?.uid {
//                Purchases.configure(withAPIKey: "appl_EePRhZXbbVCmTtRVCaBozxePmke", appUserID: firebaseUserId)
//        }
//        else {
//                Purchases.configure(withAPIKey: "appl_EePRhZXbbVCmTtRVCaBozxePmke", appUserID: nil)
//        }
//                Purchases.logLevel = .debug
//    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase is configured!")

        // Register for remote notifications
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
        }
        application.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(tokenString)")
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        // This is not a notification that Firebase Auth can handle, so handle it as needed
        completionHandler(.newData)
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Auth.auth().canHandle(url)
    }
  
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return Auth.auth().canHandle(userActivity.webpageURL!)
    }
}
