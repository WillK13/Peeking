//
//  MainView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    //Top Area
                    HStack {
                        
                        HStack(spacing: 10.0) {
                            Image(systemName: "heart.fill").foregroundColor(.red).padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/).padding([.top, .leading, .bottom]).font(.system(size: 35))
                            Text("3").font(.title).padding(.trailing)
                        }.background(RoundedRectangle(cornerRadius: 8)   .foregroundColor(.white)     ).padding([.top, .leading], 20.0)
                        
                        
                        Spacer()
                        Spacer()
                        
                        Image("Duck_Head").resizable().aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/).frame(width: 120).padding(.top, 10.0)
                        
                        
                        Spacer()
                        
                        
                        NavigationLink(destination: EmployeeTierView()) {
                            VStack {
                                Text("Tiers").font(.largeTitle).padding(.top, 5.0)
                                Image(systemName: "bag").font(.system(size: 45)).padding(/*@START_MENU_TOKEN@*/.horizontal, 27.0/*@END_MENU_TOKEN@*/).padding(.bottom, 10.0)
                            } .background(RoundedRectangle(cornerRadius: 8)   .foregroundColor(.white)     ) }
                    }.padding([.top, .trailing], 20.0)
                    
                    //Main Area
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 525)
                            .cornerRadius(10)
                        
                        VStack(alignment: .trailing) {
                            
                            Image(systemName: "bookmark")
                                .resizable()
                                .frame(width: 40, height: 50)
                                .foregroundColor(.black).padding(.top, 10)
                            
                            Spacer()
                            
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.bottom, 10).foregroundColor(.black)
                            
                            
                            Image(systemName: "ellipsis").resizable()
                                .frame(width: 40, height: 9)
                                .padding(.bottom, 10).foregroundColor(.black)
                            
                            
                            
                            
                            HStack() {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("SelectColor"))
                                    .frame(width: 83, height: 20).overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                Spacer()
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("NotSelectedColor"))
                                    .frame(width: 83, height: 20)
                                Spacer()
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("NotSelectedColor"))
                                    .frame(width: 83, height: 20)
                                Spacer()
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("NotSelectedColor"))
                                    .frame(width: 83, height: 20)
                                Spacer()
                            }
                            
                            
                            
                        }
                        .frame(width: 350, height: 500)
                    }.padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/).padding(.bottom, 15.0)
                    
                    //Next Profile
                    ZStack(alignment: .topTrailing) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 20)
                        
                    }.padding(.bottom, 10)
                    
                }}
            .navigationBarHidden(true)
        }
        }
}

#Preview {
    MainView()
}
