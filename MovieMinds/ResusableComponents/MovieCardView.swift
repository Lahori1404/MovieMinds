//
//  SwiftUIView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 06/06/24.
//

import SwiftUI

struct MovieCardView: View {
    
    enum MovieCardConstants {
        static let standardCardWidth: CGFloat = (AppConstants.screenWidth/3 - AppConstants.standardPaddingMedium)
        static let standardCardHeight: CGFloat = 160
        static let cardCornerRadius: CGFloat = 10
        static let ratingXOffset: CGFloat = 10
        static let ratingYOffset: CGFloat = 12
    }
    
    let imageURL: URL?
    let movieName: String
    let movieRating: Double
    let releaseYear: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            movieThumbnailViewBuilder()
                .padding(.bottom, AppConstants.standardPaddingMedium)
            
            Text(movieName)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .frame(width: MovieCardConstants.standardCardWidth)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    func movieThumbnailViewBuilder() -> some View {
        VStack(spacing: .zero) {
            ImageDownloadView(imageURL: imageURL)
        }
        .frame(width: MovieCardConstants.standardCardWidth,
               height: MovieCardConstants.standardCardHeight)
        .clipShape(RoundedRectangle(cornerRadius: MovieCardConstants.cardCornerRadius))
        .overlay(alignment: .bottomLeading) {
            CircularRatingView(rating: movieRating)
                .offset(x: MovieCardConstants.ratingXOffset,
                        y: MovieCardConstants.ratingYOffset)
        }
        .overlay(alignment: .topTrailing) {
            MessagePileView(text: String(releaseYear.prefix(4)))
        }
    }
}

#Preview {
    MovieCardView(imageURL: nil,
                  movieName: "Jumanji is back with more adventures",
                  movieRating: 6.7,
                  releaseYear: "2006")
}
