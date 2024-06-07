//
//  CustomAlertView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var showAlert: Bool
    var body: some View {
        VStack {
            Text("Status Key")
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text("Match")
                            .font(.headline)
                        Text("User has liked you back")
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yellow)
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text("Not Seen")
                            .font(.headline)
                        Text("User has yet to see your profile")
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text("Unlikely")
                            .font(.headline)
                        Text("User has swiped past, very low chance they will see your profile again")
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            
            Button(action: {
                showAlert = false
            }) {
                Text("OK")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 20)
        .padding(40)
    }
}

