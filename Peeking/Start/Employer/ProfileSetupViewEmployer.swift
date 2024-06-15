//
//  ProfileSetupViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/14/24.
//

import SwiftUI

struct ProfileSetupViewEmployer: View {
    @Binding var isProfileSetupComplete: Bool

    var body: some View {
        VStack {
            // Add your profile setup UI elements here
            Text("Profile Setup")
                .font(.largeTitle)
                .padding()

            // Example profile setup form fields
            TextField("Name", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Button to complete profile setup
            Button(action: {
                // Handle profile setup completion logic here
                isProfileSetupComplete = true
            }) {
                Text("Complete Profile Setup")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ProfileSetupViewEmployer(isProfileSetupComplete: .constant(false))
}
