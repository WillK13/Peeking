//
//  LoadingView.swift
//  Peeking
//
//  Created by Will kaminski on 7/6/24.
//

import SwiftUI

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                Text("Please wait while we load your profile.")
            }
        }
    }
}

#Preview {
    LoadingView()
}
