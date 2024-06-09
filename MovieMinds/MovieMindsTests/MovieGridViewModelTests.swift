//
//  MovieMindsTests.swift
//  MovieMindsTests
//
//  Created by Lahori, Divyansh on 10/06/24.
//

import XCTest

@testable import MovieMinds

class MovieGridViewModelTests: XCTestCase {
    
    var movieGridViewModel: MovieGridViewModel!
    
    override func setUp() {
        super.setUp()
        let movies = [MovieModel(id: 321,
                                 adult: false,
                                 backdrop_path: "",
                                 original_title: "",
                                 overview: "",
                                 popularity: 5460.2,
                                 poster_path: "",
                                 release_date: "",
                                 title: "Dunkirk",
                                 video: false,
                                 vote_average: 7.8,
                                 vote_count: 23451),
                      MovieModel(id: 323,
                                 adult: false,
                                 backdrop_path: "",
                                 original_title: "",
                                 overview: "",
                                 popularity: 5460.2,
                                 poster_path: "",
                                 release_date: "",
                                 title: "Unbeaten",
                                 video: false,
                                 vote_average: 7.8,
                                 vote_count: 23451)]
        
        movieGridViewModel = MovieGridViewModel(movies: movies, sectionType: .trending)
    }
    
    func testAddPlaylist() {
        let playlistName = "Favorite"
        movieGridViewModel.selectedMovie = MovieModel(id: 321,
                                                      adult: false,
                                                      backdrop_path: "",
                                                      original_title: "",
                                                      overview: "",
                                                      popularity: 5460.2,
                                                      poster_path: "",
                                                      release_date: "",
                                                      title: "Dunkirk",
                                                      video: false,
                                                      vote_average: 7.8,
                                                      vote_count: 23451)
        
        movieGridViewModel.addPlaylist(playlistName: playlistName)
        
        XCTAssertFalse(movieGridViewModel.showUserPlaylistSheet)
        XCTAssertTrue(movieGridViewModel.showConfirmationDialogue)
    }
    
    func testFilterMoviesByPlaylist() {
        let playlistMovieList = [MovieModel(id: 321,
                                           adult: false,
                                           backdrop_path: "",
                                           original_title: "",
                                           overview: "",
                                           popularity: 5460.2,
                                           poster_path: "",
                                           release_date: "",
                                           title: "Dunkirk",
                                           video: false,
                                           vote_average: 7.8,
                                           vote_count: 23451)]
        
        movieGridViewModel.filterMoviesByPlaylist(.filter, playlistMovieList)
        
        XCTAssertEqual(movieGridViewModel.filteredMovies.count, 1)
        XCTAssertEqual(movieGridViewModel.filteredMovies.first?.title, "Dunkirk")
        
        movieGridViewModel.filterMoviesByPlaylist(.reset, [])
        
        XCTAssertEqual(movieGridViewModel.filteredMovies.count, 2)
    }
}


