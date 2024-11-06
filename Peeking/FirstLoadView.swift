//
//  FirstLoadView.swift
//  Peeking
//
//  Created by Will kaminski on 11/6/24.
//

import SwiftUI

struct FirstLoadView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                Image("Duck_Body")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding(.all, 120.0)
                    .frame(height: 100)
                Spacer()
                Text("By Peeking LLC").font(.headline)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .italic()
                    .padding(.horizontal, 30.0).padding(.bottom, 15)
            }
        }
    }
}

#Preview {
    FirstLoadView()
}
