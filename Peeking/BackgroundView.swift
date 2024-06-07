//
//  BackgroundView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("TopOrange"), Color("BottomOrange")]), 
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
        }
    }
}

#Preview {
    BackgroundView()
}
