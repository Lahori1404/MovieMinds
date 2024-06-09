//
//  MovieGridViewModel.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import Foundation

public class MovieGridViewModel: ObservableObject {
    
    @Published var showUserPlaylistSheet: Bool = false
    @Published var showUserInputDialogue: Bool = false
    @Published var showConfirmationDialogue: Bool = false
    @Published var showFilterPlaylistSheet = false
    @Published var filteredMovies = [MovieModel]()

    @Published var selectedMovie: MovieModel?
    var movies: [MovieModel]
    let sectionType: MainScreenSection
    
    init(movies: [MovieModel], sectionType: MainScreenSection) {
        self.movies = movies
        self.sectionType = sectionType
        filteredMovies = movies
    }
    
    func addPlaylist(playlistName: String) {
        UserPlaylistManager.shared.addPlaylist(playlistName: playlistName,
                                               movie: selectedMovie)
        self.showUserPlaylistSheet = false
        self.showConfirmationDialogue = true
    }
    
    func filterMoviesByPlaylist(_ filterType: FilterType, _ playlistMovieList: [MovieModel]) {
        if filterType == .filter {
            filteredMovies = movies.filter { movie in playlistMovieList.contains { $0.id == movie.id }}
        } else {
            filteredMovies = movies
        }
        showFilterPlaylistSheet = false
    }
    
}
