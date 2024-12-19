//
//  newposition.swift
//  Peeking
//
//  Created by Will Kaminski on 6/20/24.
//

import SwiftUI

struct newposition: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Use your BackgroundView
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Navigation Back Button
                    HStack {
                        NavigationLink(destination: Welcome()) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                    }
                    .padding(.top, 40)
                    
                    Spacer()

                    // Title
//                    Text("Create Your Position")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                        .padding(.bottom, 20)

                    // Buttons Section
                    VStack(spacing: 20) {
                        // Main Button
                        NavigationLink(destination: ProfileSetupViewEmployer(fromEditProfile: false)) {
                            Text("Create New Position")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.vertical, 50)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 10)
                        }

                        // Disabled Buttons
                        ForEach(1..<3) { _ in
                            Button(action: {}) {
                                Text("Create New Position")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 50)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(15)
                            }
                            .disabled(true)
                        }
                    }
                    .padding(.horizontal, 30)

                    Spacer()

                    // Duck-Themed Bottom Decoration
                    HStack {
                        Spacer()
                        VStack {
                            Text("Peeking")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .italic()
                            Image("Duck_Head") // Replace with your duck image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .opacity(0.8)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    newposition()
}
