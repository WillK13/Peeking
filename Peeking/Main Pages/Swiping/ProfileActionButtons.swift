//
//  ProfileActionButtons.swift
//  Peeking
//
//  Created by Will kaminski on 7/19/24.
//

import SwiftUI

struct ProfileActionButtons: View {
    @Binding var user_id: String
    @Binding var currentStep: Int // Add binding for currentStep
    @State private var isHeartClicked = false
    @State private var heartAnimationAmount: CGFloat = 1.0
    @State private var heartOffset: CGSize = .zero

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
                .padding(.top)
                .padding(.trailing, 10)
            }
            HStack {
                Spacer()
                Button(action: {
                    // Open the pop-up
                }, label: {
                    Image("eyebookmark")
                        .padding(5)
                })
            }.padding(.trailing, 10)
                
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if !isHeartClicked {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            heartAnimationAmount = 1.3
                            isHeartClicked = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                heartOffset = CGSize(width: 0, height: -1000)
                                heartAnimationAmount = 2.0
                            }
                        }
                    }
                }) {
                    Image(systemName: isHeartClicked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 45, height: 35)
                        .foregroundColor(isHeartClicked ? .red : .black)
                        .scaleEffect(heartAnimationAmount)
                        .offset(heartOffset)
                }
                .padding(.bottom, 25)
            }.padding(.trailing, 10)
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
            }.padding(.trailing, 10)
            // Add slider buttons here
            HStack {
                Spacer()
                ForEach(0..<5) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(index == currentStep ? Color("SelectColor") : Color("NotSelectedColor"))
                        .frame(width: 65, height: 15)
                        .onTapGesture {
                            currentStep = index
                        }
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    ProfileActionButtons(user_id: .constant("example_user_id"), currentStep: .constant(0))
}
