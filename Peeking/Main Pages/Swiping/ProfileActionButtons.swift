//
//  ProfileActionButtons.swift
//  Peeking
//
//  Created by Will kaminski on 7/19/24.
//

import SwiftUI

import SwiftUI

struct ProfileActionButtons: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    // Bookmark action
                }) {
                    Image(systemName: "bookmark")
                        .resizable()
                        .frame(width: 32, height: 40)
                        .foregroundColor(.black)
                }
                .padding([.top, .trailing])
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // Heart action
                }) {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 40)
            }
            HStack {
                Spacer()
            Button(action: {
                // Ellipsis action
            }) {
                Image(systemName: "ellipsis")
                    .resizable()
                    .frame(width: 40, height: 9)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 30)
        }
        }
    }
}


#Preview {
    ProfileActionButtons()
}
