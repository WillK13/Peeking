//
//  newposition.swift
//  Peeking
//
//  Created by Will kaminski on 6/20/24.
//

import SwiftUI

struct newposition: View {
    @Binding var isProfileSetupComplete: Bool
    
    var gradientBackground: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    HStack {
                        NavigationLink(destination: Welcome()) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 25))
                                .padding()
                        }
                        Spacer()
                    }
                    .padding(.top)
                    Spacer()
                    VStack(spacing: 20) {
                        Spacer()
                        NavigationLink(destination: ProfileSetupViewEmployer()) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Create New position")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .padding(.vertical)
                                }
                            }
                            .padding(30)
                            .background(gradientBackground)
                            .cornerRadius(15) // Increased corner radius
                        }
                        Spacer()
                        //Maybe get rid of
                        NavigationLink(destination: ProfileSetupViewEmployer()) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Create New position")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .padding(.vertical)
                                }
                            }
                            .padding(30)
                            .background(gradientBackground)
                            .cornerRadius(15).opacity(0.4)
                            // Increased corner radius
                        }
                        
                        Spacer()
                        //Maybe get rid of
                        NavigationLink(destination: ProfileSetupViewEmployer()) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Create New position")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                        .padding(.vertical)
                                }
                            }
                            .padding(30)
                            .background(gradientBackground)
                            .cornerRadius(15).opacity(0.4) // Increased corner radius
                        }
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                }
                .padding()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    newposition(isProfileSetupComplete: .constant(false))
}
