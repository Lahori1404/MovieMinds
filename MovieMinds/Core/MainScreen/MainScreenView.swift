//
//  MainScreenView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 06/06/24.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject var viewModel = MainScreenViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.setupComplete != .failure {
                ScrollView (showsIndicators: false) {
                    VStack(spacing: 10) {
                        if !viewModel.filteredTrendingMovies.isEmpty {
                            MoviesHorizontalScrollSectionView(filteredMovies: viewModel.filteredTrendingMovies,
                                                              allMovies: viewModel.trendingMovies,
                                                              sectionType: .trending,
                                                              isTodayEnabled: $viewModel.isTodayEnabled,
                                                              movieLongPressed: { movie in
                                viewModel.selectedMovie = movie
                                viewModel.showUserPlaylistSheet = true })
                        }
                        
                        if !viewModel.filteredNowPlayingMovies.isEmpty {
                            MoviesHorizontalScrollSectionView(filteredMovies: viewModel.filteredNowPlayingMovies,
                                                              allMovies: viewModel.nowPlayingMovies,
                                                              sectionType: .nowPlaying,
                                                              isTodayEnabled: $viewModel.isTodayEnabled,
                                                              movieLongPressed: { movie in
                                viewModel.selectedMovie = movie
                                viewModel.showUserPlaylistSheet = true})
                        }
                        
                        if !viewModel.filteredPopularMovies.isEmpty {
                            MoviesHorizontalScrollSectionView(filteredMovies: viewModel.filteredPopularMovies,
                                                              allMovies: viewModel.popularMovies,
                                                              sectionType: .popular,
                                                              isTodayEnabled: $viewModel.isTodayEnabled,
                                                              movieLongPressed: { movie in
                                viewModel.selectedMovie = movie
                                viewModel.showUserPlaylistSheet = true})
                        }
                        
                        if !viewModel.filteredTopRatedMovies.isEmpty {
                            MoviesHorizontalScrollSectionView(filteredMovies: viewModel.filteredTopRatedMovies,
                                                              allMovies: viewModel.topRatedMovies,
                                                              sectionType: .topRated,
                                                              isTodayEnabled: $viewModel.isTodayEnabled,
                                                              movieLongPressed: { movie in
                                viewModel.selectedMovie = movie
                                viewModel.showUserPlaylistSheet = true})
                        }
                    }
                    .onChange(of: viewModel.isTodayEnabled) { _, _ in
                        viewModel.updateTrendingMovies()
                    }
                    .sheet(isPresented: $viewModel.showUserPlaylistSheet) {
                        PlaylistSheetView(showUserInputDialogue: { viewModel.showUserInputDialogue = true
                            viewModel.showUserPlaylistSheet = false},
                                          userSelectedAPlaylist: { _, _ in
                            viewModel.showUserPlaylistSheet = false
                            viewModel.showConfirmationDialogue = true },
                                          selectedMovie: viewModel.selectedMovie,
                                          isFilterPlaylistSheet: false)
                        .presentationDetents([.medium, .large])
                    }
                }
                .sheet(isPresented: $viewModel.showFilterPlaylistSheet) {
                    PlaylistSheetView(showUserInputDialogue: { viewModel.showUserInputDialogue = true },
                                      userSelectedAPlaylist: { filterType, movieList in  viewModel.filterMoviesByPlaylist(filterType,
                                                                                                                          movieList)},
                                      selectedMovie: nil,
                                      isFilterPlaylistSheet: true)
                    .presentationDetents([.medium, .large])
                }
                .toolbar {
                    if viewModel.setupComplete == .success {
                        ToolbarItem(placement: .topBarTrailing) {
                            FilterIconView()
                                .onTapGesture {
                                    viewModel.showFilterPlaylistSheet = true
                                }
                        }
                    }
                }
            } else {
                VStack {
                    Image(systemName: "iphone.gen1.slash")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.blue.opacity(AppConstants.mediumOpacity))
                    Text("MainScreen.errorStateText".localized())
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
        .task {
            do {
                try await viewModel.setupMainScreen()
                viewModel.setupComplete = .success
            } catch {
                debugPrint("Some Error")
                viewModel.setupComplete = .failure
            }
        }
        .overlay {
            if let movie = viewModel.selectedMovie?.original_title, viewModel.showConfirmationDialogue {
                CustomDialogueView(isActive: $viewModel.showConfirmationDialogue,
                                   action: { _ in },
                                   isUserInputDialogue: false,
                                   movieName: movie)
            }
            
            if viewModel.setupComplete == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                    .scaleEffect(2.0, anchor: .center)
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
    MainScreenView(viewModel: MainScreenViewModel())
}
