//
//  CircularRatingViewBuilder.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 09/06/24.
//

import SwiftUI

struct CircularRatingView: View {
    let ratingColor: Color
    let rating: Double
    
    init(rating: Double) {
        self.rating = rating
        self.ratingColor = rating >= 7.0 ? .green : .yellow
    }
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 34, height: 34)
            
            Group {
                Circle()
                    .stroke(
                        ratingColor.opacity(0.2),
                        lineWidth: 4
                    )
                Circle()
                    .trim(from: 0, to: rating / 10)
                    .stroke(
                        ratingColor,
                        style: StrokeStyle(
                            lineWidth: 4,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 28, height: 28)
            
            Text("\(rating, specifier: "%.1f")")
                .font(.caption2)
                .fontWeight(.heavy)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    CircularRatingView(rating: 6.8)
}
