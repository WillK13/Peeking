//
//  LikeHistoryItemView.swift
//  Peeking
//
//  Created by Will kaminski on 8/17/24.
//

import SwiftUI

struct LikeHistoryItemView: View {
    var photoURL: String
    var status: Int

    var body: some View {
        VStack(spacing: 10) {
            // Image Box
            AsyncImage(url: URL(string: photoURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 180)  // Adjusted size for 2-column layout
                    .cornerRadius(10)
            } placeholder: {
                Color.gray
                    .frame(width: 140, height: 180)  // Adjusted size for 2-column layout
                    .cornerRadius(10)
            }

            // Status Box
            Text(statusText)
                .foregroundColor(.black)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(statusColor)
                )
        }
    }

    private var statusText: String {
        switch status {
        case 0:
            return "Pending"
        case 1:
            return "Not seen"
        case 2:
            return "Match"
        default:
            return "Unknown"
        }
    }

    private var statusColor: Color {
        switch status {
        case 0:
            return Color.yellow
        case 1:
            return Color.red
        case 2:
            return Color.green
        default:
            return Color.gray
        }
    }
}

#Preview {
    LikeHistoryItemView(photoURL: "Hi", status: 0)
}
