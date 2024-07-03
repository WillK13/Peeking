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

    var body: some View {
        Group {
            if Auth.auth().currentUser == nil {
                firstView()
            } else if !isProfileSetupComplete {
                @State var isProfileSetupComplete = false
                Welcome()
            } else {
                MainTabView()
            }
        }
    }
}

struct MainTabView: View {
    
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
            ProfileViewEmployee()
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
