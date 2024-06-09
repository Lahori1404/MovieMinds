//
//  CustomDialogueView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import SwiftUI

struct CustomDialogueView: View {
    
    enum CustomDialogueConstants {
        static let primaryOffset: CGFloat = 600
        static let secondaryOffset: CGFloat = 1000
        static let buttonCornerRadius: CGFloat = 30
        static let buttonPadding: CGFloat = 30
        static let shadowRadius: CGFloat = 20
    }
    
    @Binding var isActive: Bool
    let title: String
    let message: String
    let buttonTitle: String
    let action: (String) -> Void
    let isUserInputDialogue: Bool
    @State private var offset: CGFloat = CustomDialogueConstants.primaryOffset
    @State var playlistName: String = ""
    
    init(isActive: Binding<Bool>,
         action: @escaping (String) -> Void,
         isUserInputDialogue: Bool,
         movieName: String? = nil) {
        self._isActive = isActive
        self.isUserInputDialogue = isUserInputDialogue
        if isUserInputDialogue {
            self.title = "CustomDialogue.userInput.title".localized()
            self.message = "CustomDialogue.userInput.message".localized()
            self.buttonTitle = "CustomDialogue.userInput.confirm".localized()
        } else {
            self.title = "CustomDialogue.confirmation.title".localized()
            self.message = String(format: "CustomDialogue.confirmation.message".localized(), movieName ?? "")
            self.buttonTitle = "CustomDialogue.confirmation.done".localized()
        }
        self.action = action
        self.offset = offset
        self.playlistName = playlistName
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(AppConstants.mediumOpacity)
                .onTapGesture {
                    withAnimation(.spring()) {
                        offset = CustomDialogueConstants.secondaryOffset
                        isActive = false
                    }
                }
            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
                    .padding()
                
                Text(markdown: message)
                    .font(.body)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .tint(.red)
                
                if isUserInputDialogue {
                    TextField("CustomDialogue.userInput.placeholder".localized(),
                              text: $playlistName)
                        .foregroundStyle(.gray)
                    Rectangle()
                        .frame(height: 1, alignment: .bottom)
                        .foregroundStyle(Color.gray.opacity(AppConstants.mediumOpacity))
                }
                
                Button {
                    if !playlistName.isEmpty && isUserInputDialogue {
                        action(playlistName)
                        withAnimation(.spring()) {
                            offset = CustomDialogueConstants.secondaryOffset
                            isActive = false
                        }
                    } else {
                        isActive = false
                    }
                } label: {
                    ZStack {
                        if isUserInputDialogue {
                            RoundedRectangle(cornerRadius: CustomDialogueConstants.buttonCornerRadius)
                                .foregroundColor(!playlistName.isEmpty ? .green : .gray)
                        } else {
                            RoundedRectangle(cornerRadius: CustomDialogueConstants.buttonCornerRadius)
                                .foregroundColor(.pink)
                        }
                        
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: CustomDialogueConstants.buttonCornerRadius))
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation(.spring()) {
                        offset = CustomDialogueConstants.secondaryOffset
                        isActive = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .tint(.black)
                .padding()
            }
            .shadow(radius: CustomDialogueConstants.shadowRadius)
            .padding(CustomDialogueConstants.buttonPadding)
            .offset(x: .zero, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = .zero
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CustomDialogueView(isActive: .constant(true),
                       action: { _ in  },
                       isUserInputDialogue: false,
                       movieName: "Jumanji")
}
