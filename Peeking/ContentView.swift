//
//  ContentView.swift
//  Peeking
//
//  Created by Will kaminski on 6/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       
                //Create the main tab bar with proper images and redirects
            TabView {
                MainView()
                    .tabItem {
                        Image("duck60").renderingMode(.template)
                    }
                LikedView()
                    .tabItem {
                        Image("eyeoff50").renderingMode(.template)
                    }
                HistoryView()
                    .tabItem {
                        Image("heart50").renderingMode(.template)
                    }
                MessagesView()
                    .tabItem {
                        Image("chat50").renderingMode(.template)
                    }
                ProfileViewEmployer()
                    .tabItem {
                        Image("profile50").renderingMode(.template)
                    }
            }
        }
    
}

#Preview {
    ContentView()
}
