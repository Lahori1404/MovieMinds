//
//  UserPlaylistManager.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import Foundation

class UserPlaylistManager {
    
    @Published var userPlaylists = [[String : [MovieModel]]]()
    
    static let shared = UserPlaylistManager()
    
    init() {
        loadUserPlaylists()
    }
    
    func loadUserPlaylists() {
        let loadedPlaylists = UserDefaultsManager.shared.userPlaylists as [[String: [MovieModel]]]
        userPlaylists = loadedPlaylists
    }
    
    func addPlaylist(playlistName: String, movie: MovieModel?) {
        guard let movie = movie else { return }
        
        // Don't create playlist if it already exists in the local storage
        if userPlaylists.contains(where: { $0.keys.contains { $0 == playlistName } }) {
            // TODO: Some Alert or popup can be rendered to notify this to user.
            debugPrint("Playlist Already Exists")
        } else {
            userPlaylists.append([playlistName: [movie]])
            UserDefaultsManager.shared.userPlaylists = userPlaylists
        }
    }
    
    func updateUserPlaylists(playlistName: String?, movie: MovieModel?) {
        guard let movie = movie, let playlistName = playlistName else { return }
        
        // Extracted the target playlist that needs to be updated.
        let userPlaylist = userPlaylists.first(where: { $0.keys.contains { $0 == playlistName } })
        var movieList = userPlaylist?.first?.value
        
        // Added movie to playlist only if it doesn't already exist in the playlist.
        if var movieList = movieList, !movieList.contains(where: { $0.id == movie.id }) {
            movieList.append(movie)
            
            // Filtered out the target playlist that needs to be updated.
            userPlaylists = userPlaylists.filter { dict in
                return dict.keys.contains { $0 != playlistName }
            }
            
            // Replaced the updated with older one.
            userPlaylists.append([playlistName: movieList])
        }
        
        // Stored the updated playlist again into the Local Storage.
        UserDefaultsManager.shared.userPlaylists = userPlaylists
    }
}
