//
//  CustomAlertView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

// Custom alert for the key to likes status
struct CustomAlertView: View {
    @Binding var showAlert: Bool

    var body: some View {
        // Content
        VStack {
            Text("Status Key")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 10)

            // The key
            VStack(alignment: .leading, spacing: 15) {
                // Success
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                    VStack(alignment: .leading) {
                        Text("Match")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("User has liked you back")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                // Pending
                HStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 30, height: 30)
                    VStack(alignment: .leading) {
                        Text("Not Seen")
                            .font(.headline)
                            .foregroundColor(.yellow)
                        Text("User has yet to see your profile")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                // No
                HStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 30, height: 30)
                    VStack(alignment: .leading) {
                        Text("No Match")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text("User has viewed and swiped past on your profile")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 10)

            // Exit
            Button(action: {
                showAlert = false
            }) {
                Text("OK")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("BottomOrange"))
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

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(showAlert: .constant(true))
    }
}
