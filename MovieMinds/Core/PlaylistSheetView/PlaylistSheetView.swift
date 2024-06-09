//
//  PlaylistSheetView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import SwiftUI

struct PlaylistSheetView: View {
    
    let showUserInputDialogue: () -> Void
    let userSelectedAPlaylist: (FilterType, [MovieModel]) -> Void
    let selectedMovie: MovieModel?
    let isFilterPlaylistSheet: Bool
    let infoText: String
    let emptyPlaylistText: String
    
    init(showUserInputDialogue: @escaping () -> Void,
         userSelectedAPlaylist: @escaping (FilterType, [MovieModel]) -> Void,
         selectedMovie: MovieModel?,
         isFilterPlaylistSheet: Bool) {
        self.showUserInputDialogue = showUserInputDialogue
        self.userSelectedAPlaylist = userSelectedAPlaylist
        self.selectedMovie = selectedMovie
        self.isFilterPlaylistSheet = isFilterPlaylistSheet
        infoText = isFilterPlaylistSheet ? "PlaylistSheetView.filter.infoText".localized() : "PlaylistSheetView.addPlaylist.infoText".localized()
        emptyPlaylistText = isFilterPlaylistSheet ? "PlaylistSheetView.filter.emptyPlaylistMessage".localized() : "PlaylistSheetView.addPlaylist.emptyPlaylistMessage".localized()
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            if UserPlaylistManager.shared.userPlaylists.isEmpty {
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "tray.fill")
                        .resizable()
                        .frame(width: 60, height: 50)
                        .foregroundStyle(.pink)
                    
                    Text(markdown: emptyPlaylistText)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else {
                
                HStack(alignment: .bottom) {
                    Text("PlaylistSheetView.yourPlaylists".localized())
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black.opacity(0.6))
                    Spacer()
                    if isFilterPlaylistSheet {
                        Text("PlaylistSheetView.resetFilters".localized())
                            .font(.caption)
                            .underline()
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue.opacity(0.8))
                            .onTapGesture {
                                userSelectedAPlaylist(.reset, [])
                            }
                    }
                }
                .padding(.horizontal, AppConstants.standardPaddingMedium)
                .padding(.bottom, 6)
                
                HStack(spacing: .zero) {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .padding(.trailing, 4)
                    Text(infoText)
                        .font(.caption)
                    Spacer()
                }
                .padding([.horizontal, .bottom], AppConstants.standardPaddingMedium)
                .foregroundStyle(.gray)
                
                Divider()
                    .foregroundStyle(.gray.opacity(AppConstants.mediumOpacity))
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .zero) {
                        ForEach(UserPlaylistManager.shared.userPlaylists, id: \.self) { item in
                            if let playlist = item.first {
                                Button {
                                    if isFilterPlaylistSheet {
                                        userSelectedAPlaylist(.filter, item.first?.value ?? [])
                                    } else {
                                        UserPlaylistManager.shared.updateUserPlaylists(playlistName: playlist.key,
                                                                                       movie: selectedMovie)
                                        userSelectedAPlaylist(.reset, [])
                                    }
                                } label: {
                                    playlistButtonRowView(name: playlist.key)
                                }
                            }
                        }
                    }
                }
            }
            
            if !isFilterPlaylistSheet {
                Button {
                    showUserInputDialogue()
                } label: {
                    addToPlaylistButtonView()
                }
            }
        }
        .padding(.top, 30)
    }
    
    func playlistButtonRowView(name: String) -> some View {
        VStack(spacing: .zero) {
            HStack {
                Text(name)
                    .font(.callout)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.leading, AppConstants.standardPaddingMedium)
            .background(.clear)
            Divider()
                .foregroundStyle(.gray.opacity(AppConstants.mediumOpacity))
        }
    }
    
    func addToPlaylistButtonView() -> some View {
        HStack {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 16, height: 16)
            Text("PlaylistSheetView.addAPlaylist".localized())
                .font(.callout)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.leading, AppConstants.standardPaddingMedium)
        .foregroundStyle(.gray)
    }
}

#Preview {
    PlaylistSheetView(showUserInputDialogue: {  },
                      userSelectedAPlaylist: { _,_  in  },
                      selectedMovie: nil,
                      isFilterPlaylistSheet: true)
}
