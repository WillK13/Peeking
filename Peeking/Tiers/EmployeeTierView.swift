//
//  EmployeeTierView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct EmployeeTierView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack{
                Image("Duck_Head").resizable().aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/).frame(width: 120).padding(.top: )
                Spacer()
            }
            Color.black.opacity(0.65)
                .edgesIgnoringSafeArea(.all)
            
            
            
            
            
            VStack {
                Spacer()
                Text("Hello, World!")
                    .font(.largeTitle)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
        }
        
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
}

#Preview {
    EmployeeTierView()
}
