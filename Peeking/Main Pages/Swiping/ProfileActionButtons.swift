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
            HStack {
                Spacer()
                Button(action: {
                    //Open the pop up
                }, label: {
                    Text("View")
                        .font(.caption2)
                        .fontWeight(.regular)
                        .foregroundColor(Color.black)
                        .padding(5)
                }).background(Color.white).cornerRadius(5)
            }.padding(.trailing, 15)
                
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
