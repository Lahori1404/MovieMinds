//
//  MoviesHorizontalScrollSectionView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import SwiftUI

struct MoviesHorizontalScrollSectionView: View {
    
    @Binding var isTodayEnabled: Bool
    let filteredMovies: [MovieModel]
    let allMovies: [MovieModel]
    let sectionType: MainScreenSection
    let movieLongPressed: (MovieModel) -> Void
    
    init(filteredMovies: [MovieModel],
         allMovies: [MovieModel],
         sectionType: MainScreenSection,
         isTodayEnabled: Binding<Bool>,
         movieLongPressed: @escaping (MovieModel) -> Void) {
        self.filteredMovies = filteredMovies
        self.allMovies = allMovies
        self.sectionType = sectionType
        self._isTodayEnabled = isTodayEnabled
        self.movieLongPressed = movieLongPressed
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text(sectionType.sectionName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                if sectionType == .trending {
                    CustomizedToggleView(isEnabled: $isTodayEnabled,
                                         textOne: "HorizontalScrollView.today".localized(),
                                         textTwo: "HorizontalScrollView.thisWeek".localized())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isTodayEnabled.toggle()
                            }
                        }
                } else  {
                    NavigationLink(destination: MoviesGridView(viewModel: MovieGridViewModel(movies: allMovies,
                                                                                             sectionType: sectionType))) {
                        HStack {
                            Text("HorizontalScrollView.all".localized())
                                .font(.caption)
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 6, height: 6)
                                .bold()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                        .foregroundStyle(.black)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)
            .padding(.bottom, 24)
            
            ScrollView(.horizontal,
                       showsIndicators: false) {
                HStack(alignment: .top,
                       spacing: 8) {
                    ForEach(filteredMovies) { movie in
                        MovieCardView(imageURL: movie.imageURL,
                                      movieName: movie.original_title,
                                      movieRating: movie.vote_average,
                                      releaseYear: movie.release_date)
                        .onTapGesture { }
                        .gesture(
                            LongPressGesture(minimumDuration: 0.2)
                                .onEnded { _ in movieLongPressed(movie) }
                        )
                    }
                }
                       .padding(.horizontal, 10)
            }
            Spacer()
        }
        .modifier(HorizontalScrollViewModifier(sectionType: sectionType))
    }
}

#Preview {
    MoviesHorizontalScrollSectionView(filteredMovies: [],
                                      allMovies: [],
                                      sectionType: .trending,
                                      isTodayEnabled: .constant(false),
                                      movieLongPressed: { _ in  })
}
