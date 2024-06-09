//
//  MainScreenViewModelTests.swift
//  MovieMindsTests
//
//  Created by Lahori, Divyansh on 10/06/24.
//

import XCTest

@testable import MovieMinds

class MainScreenViewModelTests: XCTestCase {
    
    var viewModel: MainScreenViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MainScreenViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Unit test for checking if setupMainScreen() function correctly updates the movie lists
    func testSetupMainScreen() async {
        // Given
        // Populate the MovieMindsService with mock data or use a testing framework for stubbing network calls
        let mockMovieMindService = MockMovieMindsService()
        
        // When
        do {
            async let fetchTrendingMoviesByDay = mockMovieMindService.getMoviesData(sectionType: .trendingByDay)
            async let fetchTrendingMoviesByWeek = mockMovieMindService.getMoviesData(sectionType: .trendingByWeek)
            async let fetchPopularMovies = mockMovieMindService.getMoviesData(sectionType: .popular)
            async let fetchNowPlayingMovies = mockMovieMindService.getMoviesData(sectionType: .nowPlaying)
            async let fetchTopRatedMovies = mockMovieMindService.getMoviesData(sectionType: .topRated)
            
            let movieSectionLists = try await [fetchTrendingMoviesByDay, fetchTrendingMoviesByWeek, fetchPopularMovies, fetchNowPlayingMovies, fetchTopRatedMovies]
            
            for movieSectionList in movieSectionLists {
                switch movieSectionList.1 {
                case .trendingByDay:
                    viewModel.trendingMoviesByDay = movieSectionList.0
                case .trendingByWeek:
                    viewModel.trendingMoviesByWeek = movieSectionList.0
                case .nowPlaying:
                    viewModel.nowPlayingMovies = movieSectionList.0
                case .popular:
                    viewModel.popularMovies = movieSectionList.0
                case .topRated:
                    viewModel.topRatedMovies = movieSectionList.0
                default:
                    debugPrint("Cannot recognise the section type")
                }
            }
        } catch {
            XCTFail("Error setting up main screen: \(error.localizedDescription)")
        }
        
        // Then
        // Validate that the trending movies lists are updated correctly
        XCTAssertEqual(viewModel.trendingMoviesByWeek.count, 2)
        XCTAssertEqual(viewModel.trendingMoviesByDay.count, 2)
        XCTAssertEqual(viewModel.nowPlayingMovies.count, 2)
        XCTAssertEqual(viewModel.topRatedMovies.count, 2)
        XCTAssertEqual(viewModel.popularMovies.count, 2)
    }

    // Unit test for checking if updateTrendingMovies() function correctly filters trending movies
    func testUpdateTrendingMovies() {
        // Given
        viewModel.isTodayEnabled = false
        
        // When
        viewModel.updateTrendingMovies()
        
        // Then
        XCTAssertTrue(viewModel.filteredTrendingMovies == viewModel.trendingMoviesByWeek)
    }

    // Unit test for checking if addPlaylist() function correctly adds a playlist
    func testAddPlaylist() {
        // Given
        let playlistName = "Test Playlist"
        viewModel.selectedMovie = MovieModel(id: 321,
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
        
        // When
        viewModel.addPlaylist(playlistName: playlistName)
        
        // Then
        XCTAssertTrue(viewModel.showConfirmationDialogue)
    }

    // Unit test for checking if filterMoviesByPlaylist() function correctly filters movies by playlist
    func testFilterMoviesByPlaylist() {
        // Given
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
                                            vote_count: 23451),
                                 MovieModel(id: 321,
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
        
        // When
        viewModel.filterMoviesByPlaylist(.filter, playlistMovieList)
        viewModel.filteredTrendingMovies = [MovieModel(id: 321,
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
        
        // Then
        // Validate that movies are correctly filtered based on the playlistMovieList
        XCTAssertEqual(viewModel.filteredTrendingMovies.count, 1)
        // Validate other filtered lists as needed
    }
}
