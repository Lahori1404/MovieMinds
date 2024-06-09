//
//  UserDefaultsManager.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import Foundation

final class UserDefaultsManager {
    
    static var shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    public enum UserDefaultKeyConstants {
        static let playListDataKey = "myPlaylists"
    }
    
    var userPlaylists: [[String: [MovieModel]]] {
        get {
            if let data = userDefaults.object(forKey: UserDefaultKeyConstants.playListDataKey) as? Data,
               let category = try? JSONDecoder().decode([[String: [MovieModel]]].self, from: data) {
                return category
            }
            return []
        }
        set(updateUserPlaylist) {
            if let encoded = try? JSONEncoder().encode(updateUserPlaylist) {
                userDefaults.set(encoded, forKey: UserDefaultKeyConstants.playListDataKey)
            }
            userDefaults.synchronize()
        }
    }
}

