//
//  MoviesModel.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 06/06/24.
//

import Foundation

// MARK: - MoviesModel
struct MovieListModel: Decodable, Hashable, Encodable {
    let results: [MovieModel]
}

// MARK: - Result
struct MovieModel: Identifiable, Decodable, Hashable, Encodable {
    let id: Int
    let adult: Bool
    let backdrop_path: String
    let original_title, overview: String
    let popularity: Double
    let poster_path, release_date, title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    var imageURL: URL? {
        let baseURL = URL(string: AppConstants.imageBaseUrl)
        return baseURL?.appending(path: backdrop_path)
    }
    
    init(id: Int, adult: Bool, backdrop_path: String, original_title: String, overview: String, popularity: Double, poster_path: String, release_date: String, title: String, video: Bool, vote_average: Double, vote_count: Int) {
        self.id = id
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.release_date = release_date
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
}
