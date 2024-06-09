//
//  ImageDownloadView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 09/06/24.
//

import SwiftUI

struct ImageDownloadView: View {
    let imageURL: URL?
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
            
        } placeholder: {
            placeHolderImageViewBuilder()
        }
    }
    
    @ViewBuilder
    func placeHolderImageViewBuilder() -> some View {
        Rectangle().fill(.gray)
            .opacity(0.3)
            .overlay {
                Image(systemName: "movieclapper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
            }
    }
}

#Preview {
    ImageDownloadView(imageURL: nil)
}
