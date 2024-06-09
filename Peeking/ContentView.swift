//
//  ContentView.swift
//  Peeking
//
//  Created by Will kaminski on 6/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       
            
            TabView {
                MainView()
                    .tabItem {
                        Image("duck60").renderingMode(.template)
                    }
                LikedView()
                    .tabItem {
                        Image("eyeoff60").renderingMode(.template)
                    }
                HistoryView()
                    .tabItem {
                        Image("heart60").renderingMode(.template)
                    }
                MessagesView()
                    .tabItem {
                        Image("chat60").renderingMode(.template)
                    }
                ProfileView()
                    .tabItem {
                        Image("profile60").renderingMode(.template)
                    }
            }
        }
    
}

#Preview {
    ContentView()
}
