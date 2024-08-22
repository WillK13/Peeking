//
//  testfile.swift
//  Peeking
//
//  Created by Will kaminski on 8/19/24.
//

import SwiftUI

struct testfile: View {
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.gray.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Title
                Text("Pick Your Route")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.orange)
                    .padding(.top, 100)
                    .padding(.bottom, 50)

                Spacer()
                
                // Buttons
                VStack(spacing: 25) {
                    RouteButton(title: "Job Seeker", systemImage: "briefcase.fill", backgroundColor: .orange)
                    RouteButton(title: "Employer", systemImage: "building.2.fill", backgroundColor: .gray)
                }
                
                Spacer()
                
                // Bottom Decoration
                HStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 20, height: 20)
                        .offset(y: -10)
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 3)
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 20, height: 20)
                        .offset(y: -10)
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 30)
            }
        }
    }
}

struct RouteButton: View {
    var title: String
    var systemImage: String
    var backgroundColor: Color
    
    var body: some View {
        Button(action: {
            // Action for button press
        }) {
            HStack {
                Image(systemName: systemImage)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 10)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(15)
            .shadow(color: backgroundColor.opacity(0.5), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    testfile()
}
