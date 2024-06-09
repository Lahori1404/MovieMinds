//
//  MovieMindsService.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 06/06/24.
//

import Foundation

class MovieMindsService {
    
    static let shared = MovieMindsService()
    
    func getMoviesData(sectionType: MainScreenSection) async throws -> ([MovieModel], MainScreenSection) {
        let request = getServiceRequest(sectionType: sectionType)
        let result = try await RESTRequestService.run(request, responseModel: MovieListModel.self)
        return (result.results, sectionType)
    }
    
    func getServiceRequest(sectionType: MainScreenSection) -> MovieMindsRequests {
        switch sectionType {
        case .trendingByDay:
            return MovieMindsRequests.getTrendingMoviesByDay
        case .trendingByWeek:
            return MovieMindsRequests.getTrendingMoviesByWeek
        case .nowPlaying:
            return MovieMindsRequests.getNowPlayingMovies
        case .popular:
            return MovieMindsRequests.getPopularMovies
        case .topRated:
            return MovieMindsRequests.getTopRatedMovies
        default:
            return MovieMindsRequests.getTrendingMoviesByDay
        }
    }
}
