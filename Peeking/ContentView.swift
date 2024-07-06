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
        ContentView()
    }
}
