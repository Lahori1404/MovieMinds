//
//  MoviesGridView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import SwiftUI

struct MoviesGridView: View {
    
    @StateObject var viewModel: MovieGridViewModel
    
    private let flexibleColumn = [
        GridItem(.flexible(), spacing: 4, alignment: .top),
        GridItem(.flexible(), spacing: 4, alignment: .top),
        GridItem(.flexible(), spacing: 4, alignment: .top)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(viewModel.sectionType.sectionName)
                .font(.title)
                .fontWeight(.bold)
                .padding([.leading, .bottom], 10)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: flexibleColumn, spacing: 16) {
                    ForEach(viewModel.filteredMovies, id: \.self) { movie in
                        MovieCardView(imageURL: movie.imageURL,
                                      movieName: movie.original_title,
                                      movieRating: movie.vote_average,
                                      releaseYear: movie.release_date)
                        .onTapGesture { }
                        .gesture(
                            LongPressGesture(minimumDuration: 0.2)
                                .onEnded { _ in
                                    viewModel.selectedMovie = movie
                                    viewModel.showUserPlaylistSheet = true
                                }
                        )
                    }
                }
                
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $viewModel.showUserPlaylistSheet) {
            PlaylistSheetView(showUserInputDialogue: {
                viewModel.showUserInputDialogue = true
                viewModel.showUserPlaylistSheet = false},
                              userSelectedAPlaylist: { _, _ in
                viewModel.showUserPlaylistSheet = false
                viewModel.showConfirmationDialogue = true },
                              selectedMovie: viewModel.selectedMovie,
                              isFilterPlaylistSheet: false)
            .presentationDetents([.medium,.large])
        }
        .sheet(isPresented: $viewModel.showFilterPlaylistSheet) {
            PlaylistSheetView(showUserInputDialogue: { viewModel.showUserInputDialogue = true },
                              userSelectedAPlaylist: { filterType, movieList in viewModel.filterMoviesByPlaylist(filterType,movieList)},
                              selectedMovie: nil,
                              isFilterPlaylistSheet: true)
            .presentationDetents([.medium, .large])
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FilterIconView()
                .onTapGesture {
                    viewModel.showFilterPlaylistSheet = true
                }
            }
        }
        .overlay {
            if let movie = viewModel.selectedMovie?.original_title, viewModel.showConfirmationDialogue {
                CustomDialogueView(isActive: $viewModel.showConfirmationDialogue,
                                   action: { _ in
                    viewModel.showUserPlaylistSheet = false
                    viewModel.showConfirmationDialogue = true  },
                                   isUserInputDialogue: false,
                                   movieName: movie)
            }
        }
        .overlay {
            if viewModel.showUserInputDialogue {
                CustomDialogueView(isActive: $viewModel.showUserInputDialogue,
                                   action: { playlistName in
                    viewModel.addPlaylist(playlistName: playlistName)
                },
                                   isUserInputDialogue: true)
            }
        }
    }
}

#Preview {
    MoviesGridView(viewModel: MovieGridViewModel(movies: [],
                                                 sectionType: .trending))
}
