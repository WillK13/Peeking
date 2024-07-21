//
//  ContentView.swift
//  Peeking
//
//  Created by Will kaminski on 6/6/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image("tgduck").renderingMode(.template)
                }
            LikedView()
                .tabItem {
                    Image("tgeye").renderingMode(.template)
                }
            HistoryView()
                .tabItem {
                    Image("tgheart").renderingMode(.template)
                }
            MessagesView()
                .tabItem {
                    Image("tgmessages").renderingMode(.template)
                }
            if appViewModel.userType == 0 {
                ProfileViewEmployee()
                    .tabItem {
                        Image("tgprofile").renderingMode(.template)
                    }
            } else if appViewModel.userType == 1 {
                ProfileViewEmployer()
                    .tabItem {
                        Image("tgprofile").renderingMode(.template)
                    }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppViewModel())
    }
}
