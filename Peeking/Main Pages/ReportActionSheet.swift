//
//  ReportActionSheet.swift
//  Peeking
//
//  Created by Will kaminski on 10/13/24.
//

import SwiftUI

struct ReportActionSheet: View {
    @Binding var showReportSheet: Bool
        
        var body: some View {
            VStack {
                Spacer()
                
                VStack {
                    Rectangle().frame(width: 50, height: 10).foregroundColor(Color.gray).cornerRadius(5).padding(.top)
                    Button(action: {
                        // Handle the report action
                        print("User reported")
                        showReportSheet = false  // Close the sheet after reporting
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(Color.red)
                                .padding([.top, .leading, .bottom])
                            Text("Report")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .padding([.top, .bottom, .trailing])
                        }
                            .background(Color.white)
                            
                            .cornerRadius(10)
                            .padding(.vertical, 20)
                            .shadow(radius: 1)
                    }
                    
                    Button(action: {
                        // Handle the report action
                        print("User sent")
                        showReportSheet = false  // Close the sheet after reporting
                    }) {
                        HStack {
                            Image(systemName: "paperplane")
                                .foregroundColor(Color.green)
                                .padding([.top, .leading, .bottom])
                            Text("Send Profile")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding([.top, .bottom, .trailing])
                        }
                            .background(Color.white)
                            
                            .cornerRadius(20)
                            .padding(.vertical, 20)
                            .shadow(radius: 1)
                            .padding(.bottom, 20)
                    }.frame(maxWidth: .infinity)
                    
//                    Button(action: {
//                        showReportSheet = false  // Close the sheet
//                    }) {
//                        Text("Cancel")
//                            .font(.headline)
//                            .frame(maxWidth: .infinity)
//                            .fontWeight(.bold)
//                            .foregroundColor(.black)
//                            .padding()
//                            .cornerRadius(10)
//                            .padding(.bottom, 20)
//                            .shadow(radius: 1)
//                    }
                }
//                .padding(.top, 20)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.bottom, -15)
                .gesture(
                                DragGesture().onEnded { gesture in
                                    if gesture.translation.height > 100 { // Adjust the threshold as needed
                                        showReportSheet = false
                                    }
                                }
                            )
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.black.opacity(0.4).onTapGesture {
                showReportSheet = false  // Close the sheet when the background is tapped
            }).padding(.top, -10)
        }
}

#Preview {
    ReportActionSheet(showReportSheet: .constant(true))
}
