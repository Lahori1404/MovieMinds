//
//  MainScreenViewModel.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 06/06/24.
//

import Foundation

class MainScreenViewModel: ObservableObject {
    
    @Published var trendingMoviesByWeek = [MovieModel]()
    @Published var trendingMoviesByDay = [MovieModel]()
    @Published var nowPlayingMovies = [MovieModel]()
    @Published var trendingMovies = [MovieModel]()
    @Published var popularMovies = [MovieModel]()
    @Published var topRatedMovies  = [MovieModel]()
    @Published var selectedMovie: MovieModel?
    @Published var userPlaylists = [[String: [MovieModel]]]()
    @Published var isTodayEnabled = true
    @Published var showUserInputDialogue: Bool = false
    @Published var showConfirmationDialogue: Bool = false
    @Published var showUserPlaylistSheet = false
    @Published var showFilterPlaylistSheet = false
    @Published var showAllMoviesGrid = false
    @Published var setupComplete: LoadState = .loading
    
    @Published var filteredNowPlayingMovies = [MovieModel]()
    @Published var filteredTrendingMovies = [MovieModel]()
    @Published var filteredPopularMovies = [MovieModel]()
    @Published var filteredTopRatedMovies  = [MovieModel]()
        
    @MainActor
    func setupMainScreen() async throws {
        
        async let fetchTrendingMoviesByDay = MovieMindsService.shared.getMoviesData(sectionType: .trendingByDay)
        async let fetchTrendingMoviesByWeek = MovieMindsService.shared.getMoviesData(sectionType: .trendingByWeek)
        async let fetchPopularMovies = MovieMindsService.shared.getMoviesData(sectionType: .popular)
        async let fetchNowPlayingMovies = MovieMindsService.shared.getMoviesData(sectionType: .nowPlaying)
        async let fetchTopRatedMovies = MovieMindsService.shared.getMoviesData(sectionType: .topRated)
        
        let movieSectionLists = try await [fetchTrendingMoviesByDay, fetchTrendingMoviesByWeek, fetchPopularMovies, fetchNowPlayingMovies, fetchTopRatedMovies]
        
        for movieSectionList in movieSectionLists {
            switch movieSectionList.1 {
            case .trendingByDay:
                self.trendingMoviesByDay = movieSectionList.0
            case .trendingByWeek:
                self.trendingMoviesByWeek = movieSectionList.0
            case .nowPlaying:
                self.nowPlayingMovies = movieSectionList.0
            case .popular:
                self.popularMovies = movieSectionList.0
            case .topRated:
                self.topRatedMovies = movieSectionList.0
            default:
                debugPrint("Cannot recognise the section type")
            }
        }
        
        trendingMovies = isTodayEnabled ? trendingMoviesByDay : trendingMoviesByWeek
        filteredTrendingMovies = trendingMovies
        filteredPopularMovies = popularMovies
        filteredNowPlayingMovies = nowPlayingMovies
        filteredTopRatedMovies = topRatedMovies
    }
    
    func updateTrendingMovies() {
        filteredTrendingMovies = isTodayEnabled ? trendingMoviesByDay : trendingMoviesByWeek
    }
    
    func addPlaylist(playlistName: String) {
        UserPlaylistManager.shared.addPlaylist(playlistName: playlistName,
                                               movie: selectedMovie)
        self.showUserPlaylistSheet = false
        self.showConfirmationDialogue = true
    }
    
    func filterMoviesByPlaylist(_ filterType: FilterType, _ playlistMovieList: [MovieModel]) {
        if filterType == .filter {
            filteredTrendingMovies = trendingMovies.filter { movie in playlistMovieList.contains { $0.id == movie.id }}
            filteredPopularMovies = popularMovies.filter { movie in playlistMovieList.contains { $0.id == movie.id }}
            filteredNowPlayingMovies = nowPlayingMovies.filter { movie in playlistMovieList.contains { $0.id == movie.id }}
            filteredTopRatedMovies = topRatedMovies.filter { movie in playlistMovieList.contains { $0.id == movie.id }}
        } else {
            filteredTrendingMovies = trendingMovies
            filteredPopularMovies = popularMovies
            filteredNowPlayingMovies = nowPlayingMovies
            filteredTopRatedMovies = topRatedMovies
        }
        showFilterPlaylistSheet = false
    }
}

public enum LoadState {
    case loading
    case success
    case failure
}

public enum MainScreenSection {
    case trendingByDay
    case trendingByWeek
    case trending
    case nowPlaying
    case popular
    case topRated
    
    var sectionName: String {
        switch self {
        case .trending:
            return "Trending"
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .trendingByDay:
            return "Trending"
        case .trendingByWeek:
            return "Trending"
        }
    }
}

public enum FilterType {
    case reset
    case filter
}
