//
//  LikedView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct LikedView: View {
    //Variable for the popup, make dynamic so I don't need unlocked?
    @State private var showPopup = false
    
    var body: some View {
        //Background
        ZStack {
            BackgroundView()
            //Content
            VStack(alignment: .center) {
                Image(systemName: "eye.slash")
                    .resizable()
                    .frame(width: 120, height: 100)
                    .foregroundColor(.white)
                    .padding(.vertical, 30)
                
                VStack(spacing: 20) {
                    //Heart icon and text
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text("54")
                            .font(.title)
                        Text("Liked You")
                            .font(.title)
                    }
                    
                    //Grid of rectangles, need to make profiles, blurred.
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 150, height: 200)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 150, height: 200)
                        }
                        HStack(spacing: 20) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 150, height: 200)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 150, height: 200)
                        }
                    }
                    .padding(.bottom, 15)
                    //Cut out rectangles, need to have a profile too.
                    HStack(spacing: 20) {
                        //First cut-off rectangle
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white)
                                .frame(width: 150, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            
                            Rectangle()
                                .fill(Color.orange)
                                .frame(width: 150, height: 2)
                                .offset(y: 1)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 150, height: 2)
                                .offset(y: 1)
                        }
                        
                        //Second cut-off rectangle
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white)
                                .frame(width: 150, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            
                            Rectangle()
                                .fill(Color.orange)
                                .frame(width: 150, height: 2)
                                .offset(y: 1)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 150, height: 2)
                                .offset(y: 1)
                        }
                    }
                    .padding(.bottom, 10.0)
                    
                    Spacer()
                }
                
                Spacer()
            }
            //Popup, need to make dynamic with payment?
            if showPopup {
                Color.black.opacity(0.15)
                    .edgesIgnoringSafeArea(.top).padding(.bottom, 45.0)
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 250, height: 250)
                        
                        VStack {
                            Text("Upgrade Tier to Unlock")
                                .font(.title2)
                                .padding(.bottom, 20)
                            
                            Image(systemName: "bag")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                    
                   
                }
//                .onTapGesture {
//                    showPopup = false
//                }
            }
        }
        //.onTapGesture {
         //   if showPopup {
        //        showPopup = false
        //    }
       // }
        .onAppear {
            showPopup = true
        }
    }
}

#Preview {
    LikedView()
}
