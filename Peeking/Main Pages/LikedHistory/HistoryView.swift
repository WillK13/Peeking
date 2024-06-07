//
//  Historyiew.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct HistoryView: View {
    @State private var showAlert = false
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center) {
                
                
                HStack{
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 120, height: 110)
                        .foregroundColor(.white).padding(.bottom, 5.0).padding(.top, 30.0)
                    Spacer()
                    Spacer()
                    Button(action: {
                                    showAlert = true
                    }) {
                        Image(systemName: "questionmark.circle.fill").resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white).padding([.top, .trailing], 30)
                    
                    }
                }
                
                
                
                Text("Like History").font(.largeTitle).padding(.bottom, 10.0)
            
                HStack(spacing: 20) {
                               VStack(spacing: 10) {
                                   RoundedRectangle(cornerRadius: 10)
                                       .fill(Color.white)
                                       .frame(width: 150, height: 200)
                                   
                                   Text("status")
                                       .foregroundColor(.black)
                                       .padding(10)
                                       .background(
                                           RoundedRectangle(cornerRadius: 15)
                                               .fill(Color.white)
                                       )
                               }
                               
                               VStack(spacing: 10) {
                                   RoundedRectangle(cornerRadius: 10)
                                       .fill(Color.white)
                                       .frame(width: 150, height: 200)
                                   
                                   Text("status")
                                       .foregroundColor(.black)
                                       .padding(10)
                                       .background(
                                           RoundedRectangle(cornerRadius: 15)
                                               .fill(Color.white)
                                       )
                               }
                           }
                           .padding(.top, 15)
                
                
                
                HStack(spacing: 20) {
                             
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(width: 150, height: 120)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(Color.clear, lineWidth: 0)
                                                .background(
                                                    Rectangle()
                                                        .fill(Color.clear)
                                                        .frame(height: 2)
                                                        .border(Color.black, width: 1)
                                                        .offset(y: 60)
                                                )
                                        )
                                    
                                    
                   
                                
                               
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(width: 150, height: 120)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(Color.clear, lineWidth: 0)
                                                .background(
                                                    Rectangle()
                                                        .fill(Color.clear)
                                                        .frame(height: 2)
                                                        .border(Color.black, width: 1)
                                                        .offset(y: 60)
                                                )
                                        )
                            }
                            .padding(.top, 15)
                
                
                Spacer()
               
            }
            if showAlert {
                            Color.black.opacity(0.4)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showAlert = false
                                }
                            
                            CustomAlertView(showAlert: $showAlert)
                                .transition(.scale)
                        }
                    }
                    .animation(.easeInOut, value: showAlert)
    }
}


#Preview {
    HistoryView()
}
