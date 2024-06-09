//
//  MovieMindsRequest+Protocol.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import Foundation

protocol MovieMindsRequestProtocol {
    var host: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var urlParams: [String: String]? { get }
    var requestType: RequestType { get }
}

extension MovieMindsRequestProtocol {
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if let param = urlParams, !param.isEmpty {
            components.queryItems = param.map {
                URLQueryItem(name: $0, value: $1)
            }
        }

        guard let url = components.url
        else { throw RESTRequestError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if let headers = headers, !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        urlRequest.setValue("application/json",
                            forHTTPHeaderField: "Content-Type")

        if let params = params, !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: params)
        }
        return urlRequest
    }
}

enum MovieMindsRequests: MovieMindsRequestProtocol {
    
    case getTrendingMoviesByDay
    case getTrendingMoviesByWeek
    case getNowPlayingMovies
    case getTopRatedMovies
    case getPopularMovies

    private enum Constants {
        static let getTrendingMoviesByDayPath = "/3/trending/movie/day"
        static let getTrendingMoviesByWeekPath = "/3/trending/movie/week"
        static let getNowPlayingMoviesPath = "/3/movie/now_playing"
        static let getTopRatedMoviesPath = "/3/movie/top_rated"
        static let getPopularMoviesPath = "/3/movie/popular"
        static let apiHeaderKey = "api_key"
    }

    var host: String {
        switch self {
        case .getTrendingMoviesByDay, .getTrendingMoviesByWeek, .getNowPlayingMovies, .getTopRatedMovies, .getPopularMovies:
            return AppConstants.mainBaseUrl
        }
    }

    var path: String {
        switch self {
        case .getTrendingMoviesByDay:
            Constants.getTrendingMoviesByDayPath
        case .getTrendingMoviesByWeek:
            Constants.getTrendingMoviesByWeekPath
        case .getNowPlayingMovies:
            Constants.getNowPlayingMoviesPath
        case .getTopRatedMovies:
            Constants.getTopRatedMoviesPath
        case .getPopularMovies:
            Constants.getPopularMoviesPath
        }
    }

    var headers: [String: String]? {
        nil
    }

    var params: [String: Any]? {
        nil
    }

    var urlParams: [String: String]? {
        switch self {
        case .getTrendingMoviesByDay, .getTrendingMoviesByWeek, .getNowPlayingMovies, .getTopRatedMovies, .getPopularMovies:
            return [Constants.apiHeaderKey: AppConstants.apiKey]
        }
    }

    var requestType: RequestType {
        .get
    }
}

enum RESTRequestError: Error {
    case invalidURL
    case invalidServerResponse
    case decode
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown
    case notConnectedToInternet

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}

enum RequestType: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


