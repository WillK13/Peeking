//
//  MainView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct TopCornersRounded: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct MainView: View {
    @State private var showEmployeeTier = false
    @State private var showSearchSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    //Top Area
                    HStack {
                        HStack() {
                            Image(systemName: "heart.fill").foregroundColor(.red).padding(.all, 5.0).font(.system(size: 25))
                            Text("3").font(.title).padding(.trailing, 5.0)
                        }
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
                        .padding(.leading, 27.0).padding(.top, 70)
                        
                        Spacer()
                        
                        Image("Duck_Head").resizable().aspectRatio(contentMode: .fit).frame(width: 120).padding(.top, 10.0)
                        
                        
                        VStack {
                            Button(action: {
                                showEmployeeTier.toggle()
                            }) {
                                Image(systemName: "bag").foregroundColor(Color.white).font(.system(size: 45)).padding(.horizontal, 27.0).padding(.bottom, 10.0)
                            }
                            
                            Button(action: {
                                showSearchSettings.toggle()
                            }) {
                                Image("adjust")
                            }
                                
                        }
                    }.padding(.trailing, 20.0)
                    
                    //Main Area
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 395, height: 545)
                            .cornerRadius(10).padding(.top, -20)

                        
                        VStack(alignment: .trailing) {
                            Image(systemName: "bookmark")
                                .resizable()
                                .frame(width: 40, height: 50)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding([.bottom, .trailing], 10).foregroundColor(.black)
                            
                            Image(systemName: "ellipsis").resizable()
                                .frame(width: 40, height: 9)
                                .padding([.bottom, .trailing], 10).foregroundColor(.black)
                            
                            HStack {
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
                    }.padding([.top, .leading, .trailing]).padding(.bottom, 5)
                    
                    //Next Profile
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 20)
                        .clipShape(TopCornersRounded(radius: 10))
                    
                    Spacer()
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showEmployeeTier) {
                EmployeeTierView()
            }
            .sheet(isPresented: $showSearchSettings) {
                ToggleView()
            }
        }
    }
}

#Preview {
    MainView()
}
