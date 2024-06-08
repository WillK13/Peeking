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
    @State private var showPicker = false
    
    private let plans = ["with Floater", "with Glider", "with Diver"]
    
    private let pagesFloater = [
        PlanPage(title: "3 Like Capacity", description: "Refilled every 24 hours", imageName: "heart", iconText: "3"),
        PlanPage(title: "Bookmark", description: "A bookmark for your search", imageName: "bookmark", iconText: "1")
    ]
    
    private let pagesGlider = [
        PlanPage(title: "Recharge", description: "Likes recharge 1 every hour", imageName: "Battery", iconText: ""),
        PlanPage(title: "Roam", description: "Set location anywhere", imageName: "Car", iconText: ""),
        PlanPage(title: "Bookmark +", description: "2 bookmarks for searching", imageName: "bookmark", iconText: "2")
    ]
    
    private let pagesDiver = [
        PlanPage(title: "Liked You", description: "See employers who like you", imageName: "Lookeye", iconText: ""),
        PlanPage(title: "5 Like Capacity", description: "Wake up with 5 likes", imageName: "heart", iconText: "5"),
        PlanPage(title: "Recharge", description: "Likes recharge 1 every hour", imageName: "Battery", iconText: ""),
        PlanPage(title: "Roam", description: "Set location anywhere", imageName: "Car", iconText: ""),
        PlanPage(title: "Bookmark ++", description: "3 bookmarks for searching", imageName: "bookmark", iconText: "3")
    ]
    
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
                    Text(getPlanTitle())
                        .font(.largeTitle)
                        .padding(.top)
                    
                    Button(action: {
                        showPicker.toggle()
                    }) {
                        HStack {
                            Text(selectedPlan)
                                .font(.title2)
                                .foregroundColor(Color.black)
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(getPickerBackgroundColor()))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            if selectedPage > 0 {
                                selectedPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.black)
                                .padding(.leading, 50.0)
                                .font(.largeTitle)
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        VStack {
                            let currentPage = getCurrentPages()[selectedPage]
                            if currentPage.imageName == "Battery" {
                                Image(currentPage.imageName + currentPage.iconText)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, height: 60)
                            } else {
                                Image(currentPage.imageName + currentPage.iconText)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                            }
                            Text(currentPage.title)
                                .font(.title2)
                            
                            Text(currentPage.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                ForEach(Array(getCurrentPages().indices), id: \.self) { index in
                                    Circle()
                                        .fill(index == selectedPage ? Color.black : Color.gray)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            .padding(.top)
                        }.padding(.vertical)
                        
                        Spacer()
                        
                        Button(action: {
                            if selectedPage < getCurrentPages().count - 1 {
                                selectedPage += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.black)
                                .padding(.trailing, 50.0)
                                .font(.largeTitle)
                        }
                        .padding(.trailing)
                    }
                    
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
            
            if showPicker {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showPicker = false
                    }
                
                VStack {
                    Spacer()
                    PickerView(selectedPlan: $selectedPlan, plans: plans, showPicker: $showPicker)
                        .frame(width: 300, height: 200)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 20)
                        .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .onChange(of: selectedPlan) { newPlan, _ in
            selectedPage = 0 // Reset to first page when plan changes
        }
    }
    
    private func getCurrentPages() -> [PlanPage] {
        switch selectedPlan {
        case "with Glider":
            return pagesGlider
        case "with Diver":
            return pagesDiver
        default:
            return pagesFloater
        }
    }
    
    private func getPlanTitle() -> String {
        switch selectedPlan {
        case "with Glider":
            return "Find Matches Faster"
        case "with Diver":
            return "Unlimited Access"
        default:
            return "Just the Basics"
        }
    }
    
    private func getPickerBackgroundColor() -> Color {
        switch selectedPlan {
        case "with Glider":
            return Color.blue.opacity(0.2)
        case "with Diver":
            return Color.purple.opacity(0.2)
        default:
            return Color.gray.opacity(0.2)
        }
    }
}

struct PlanPage {
    let title: String
    let description: String
    let imageName: String
    let iconText: String
}

struct PickerView: View {
    @Binding var selectedPlan: String
    let plans: [String]
    @Binding var showPicker: Bool
    
    var body: some View {
        VStack {
            Picker("Select Plan", selection: $selectedPlan) {
                ForEach(plans, id: \.self) { plan in
                    Text(plan)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            
            Button("Done") {
                showPicker = false
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

#Preview {
    EmployeeTierView()
}
