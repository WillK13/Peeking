//
//  ContentView.swift
//  Peeking
//
//  Created by Will kaminski on 6/6/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Binding var isProfileSetupComplete: Bool
    @State private var showSignInView = true
    @State private var normalOpen = false

    var body: some View {
        Group {
            if Auth.auth().currentUser == nil {
                PhoneAuthView(showSignInView: $showSignInView, isProfileSetupComplete: $isProfileSetupComplete)
            } else if !isProfileSetupComplete {
                Welcome(isProfileSetupComplete: $isProfileSetupComplete)
            } else {
                MainTabView(normalOpen: $normalOpen, showSignInView: $showSignInView)
            }
        }
    }
}

struct MainTabView: View {
    @Binding var normalOpen: Bool
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image("duck60").renderingMode(.template)
                }
            LikedView()
                .tabItem {
                    Image("eyem").renderingMode(.template)
                }
            HistoryView()
                .tabItem {
                    Image("heartm").renderingMode(.template)
                }
            MessagesView()
                .tabItem {
                    Image("messagesm").renderingMode(.template)
                }
            ProfileViewEmployee(normalOpen: $normalOpen)
                .tabItem {
                    Image("profilem").renderingMode(.template)
                }
        }.navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isProfileSetupComplete: .constant(true))
    }
}
