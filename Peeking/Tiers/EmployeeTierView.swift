//
//  EmployeeTierView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct EmployeeTierView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedPage = 0
    @State private var selectedPlan = "with Floater"
    
    private let pages = [
        PlanPage(title: "3 Like Capacity", description: "Refilled every 24 hours", imageName: "heart", iconText: "3"),
        PlanPage(title: "Bookmark", description: "One bookmark for your search", imageName: "bookmark", iconText: "1X")
    ]
    
    private let plans = ["with Floater", "Plan 2", "Plan 3"]
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("Duck_Head").resizable().aspectRatio(contentMode: .fit).frame(width: 120).padding(.top, 30)
                Spacer()
            }
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 373, height: 650)
                .padding(.top, 140)
            
            
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text("Billing disclaimer")
                    .font(.title2)
                    .foregroundColor(Color.white)
                
                Text("Upon purchase payment will be charged to your Apple account, and your subscription will automatically renew until you cancel in settings. Upon purchase, you agree to our Terms of Agreement and Privacy Policy.")
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(Color("UnimportantText"))
                    .multilineTextAlignment(.center)
                    .frame(width: 300.0)
                
                Spacer()
                
                VStack {
                    Text("Just the Basics")
                        .font(.largeTitle)
                        .padding(.top)
                    
                    Picker("Plan", selection: $selectedPlan) {
                        ForEach(plans, id: \.self) { plan in
                            Text(plan)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                    
                    HStack {
                        Button(action: {
                            if selectedPage > 0 {
                                selectedPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: pages[selectedPage].imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                            
                            Text(pages[selectedPage].iconText)
                                .font(.title)
                                .padding(.bottom, 2)
                            
                            Text(pages[selectedPage].title)
                                .font(.title2)
                            
                            Text(pages[selectedPage].description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Circle()
                                    .fill(selectedPage == 0 ? Color.black : Color.gray)
                                    .frame(width: 10, height: 10)
                                
                                Circle()
                                    .fill(selectedPage == 1 ? Color.black : Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                            .padding(.top)
                        }.padding(.top)
                        
                        Spacer()
                        
                        Button(action: {
                            if selectedPage < pages.count - 1 {
                                selectedPage += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.largeTitle)
                        }
                        .padding(.trailing)
                    }
                    
                    Spacer()
                    
                    
                    
                    
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 0) {
                                           VStack {
                                               Image("Infinity").resizable().aspectRatio(contentMode: .fill).frame(width: 50)
                                               
                                               Text("Months")
                                                   .font(.title2)
                                                   .padding(.top, -20.0)
                                           }
                                           .frame(height: 80)
                                           .background(Color.white)
                                           
                                           VStack {
                                               Text("Free")
                                                   .font(.title)
                                                   .padding(.top, 2)
                                                   .padding(.bottom, 20)
                                           }
                                           .frame(width: 100.0, height: 60)
                                           .background(Color.gray.opacity(0.2))
                                           .overlay(
                                               Rectangle()
                                                   .frame(height: 1)
                                                   .foregroundColor(Color.black),
                                               alignment: .top
                                           )
                                           .padding(.top, 10)
                                       }
                                       .frame(width: 100, height: 150)
                                       .overlay(
                                           RoundedRectangle(cornerRadius: 8)
                                               .stroke(Color.black, lineWidth: 1)
                                       )
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    Spacer()
                    
                    
                        Text("All users get full access")
                            .font(.title2)
                            .foregroundColor(Color.black)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 100).fill(Color("FadedTopOrange")))

                    .padding(.top, 10)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Exit")
                            .font(.title2)
                            .padding()
                            .foregroundColor(Color("UnimportantText"))
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
}

struct PlanPage {
    let title: String
    let description: String
    let imageName: String
    let iconText: String
}

#Preview {
    EmployeeTierView()
}
