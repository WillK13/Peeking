//
//  LoadingView.swift
//  Peeking
//
//  Created by Will kaminski on 7/6/24.
//

import SwiftUI

struct LoadingView: View {
   @State private var selectedTip = 0
   @State private var timer: Timer? = nil
   private let tips = [
       "Be true to yourself for the most compatible matches.",
       "Play with your search settings to see what’s out there!",
       "Be patient while we load your profile.",
       "Customize your profile to attract more matches."
   ]
   @State private var currentTipIndex = 0
   @State private var downloadAmount = 0.0
   let timer1 = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect() // Slower animation

   var body: some View {
       ZStack {
        BackgroundView()
           VStack {
               Image("Duck_Body")
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .padding(.all, 120.0)
                   .frame(height: 100)

               Text(tips[currentTipIndex])
                   .font(.title2)
                   .foregroundColor(Color.white)
                   .multilineTextAlignment(.center)
                   .padding(.top, 70.0)
                   .italic()
                   .padding(.horizontal, 30.0)

               ZStack(alignment: .leading) {
                   RoundedRectangle(cornerRadius: 10)
                       .foregroundColor(Color.white.opacity(0.3)) // Lighter background for the progress bar
                       .frame(height: 20) // Adjust height as needed

                   RoundedRectangle(cornerRadius: 10)
                       .foregroundColor(.white) // White color for the progress bar
                       .frame(width: CGFloat(downloadAmount) * 3, height: 20) // Adjust width multiplier for thickness
                       .cornerRadius(10) // Rounded corners

                   LinearGradient(gradient: Gradient(colors: [.clear, Color.white.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                       .frame(height: 20)
                       .mask(
                           RoundedRectangle(cornerRadius: 10)
                               .frame(width: CGFloat(downloadAmount) * 3, height: 20) // Match the progress bar width
                       )
               }
               .padding(.horizontal, 50.0) // Adjust horizontal padding
               .onReceive(timer1) { _ in
                   withAnimation {
                       if downloadAmount < 100 {
                           downloadAmount += 1.5 // Slower increment for smoother animation
                       } else {
                           downloadAmount = 0 // Reset when complete
                       }
                   }
               }
           }
       }
       .onAppear {
           startTimer()
       }
       .onDisappear {
           stopTimer()
       }
   }

   private func startTimer() {
       timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
           withAnimation {
               currentTipIndex = (currentTipIndex + 1) % tips.count
           }
       }
   }

   private func stopTimer() {
       timer?.invalidate()
       timer = nil
   }
}

struct LoadingView_Previews: PreviewProvider {
   static var previews: some View {
       LoadingView()
   }
}
