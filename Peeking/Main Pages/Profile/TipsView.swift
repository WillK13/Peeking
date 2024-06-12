//
//  TipsView.swift
//  Peeking
//
//  Created by Will kaminski on 6/9/24.
//

import SwiftUI

struct TipsView: View {
    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Text("Tips")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.85))
                            .frame(width: 350, height: 100)
                        
                        Text("Be true to yourself for the most compatible matches.")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, -40.0)
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.85))
                            .frame(width: 350, height: 100)
                        
                        Text("Employers only see you if you heavily meet their requirements.")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.85))
                            .frame(width: 350, height: 100)
                        
                        Text("Job-Seekers only see you if you heavily meet their requirements.")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.85))
                            .frame(width: 350, height: 100)
                        
                        Text("Play with your search settings to see what’s out there!")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .padding()
                            
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}

#Preview {
    TipsView()
}
