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
                        Image("Duck_Icon").renderingMode(.template).resizable().aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    }
                LikedView()
                    .tabItem {
                        Image(systemName: "eye.slash").resizable()
                            .frame(width: 100, height: 100)
                    }
                HistoryView()
                    .tabItem {
                        Image(systemName: "suit.heart")
                    }
                MessagesView()
                    .tabItem {
                        Image(systemName: "message")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                    }
            }
        }
    
}

#Preview {
    ContentView()
}
