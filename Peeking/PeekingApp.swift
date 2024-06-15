//
//  PeekingApp.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

@main
struct PeekingApp: App {
    @State private var isProfileSetupComplete = false

    var body: some Scene {
        WindowGroup {
            if isProfileSetupComplete {
                ContentView()
            } else {
                ProfileSetupViewEmployee(isProfileSetupComplete: $isProfileSetupComplete)
            }
        }
    }
}
