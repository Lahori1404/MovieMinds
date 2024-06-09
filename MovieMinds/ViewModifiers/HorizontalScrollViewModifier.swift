//
//  HorizontalScrollViewModifier.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 07/06/24.
//

import Foundation
import SwiftUI

struct HorizontalScrollViewModifier: ViewModifier {
    let sectionType: MainScreenSection
    func body(content: Content) -> some View {
        if sectionType != .trending {
            content
                .background(.blue.opacity(0.2))
                .border(Color.blue.opacity(0.3))
                .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 6, bottomLeading: 6)))
                .padding(.leading, 10)
        } else {
            content
        }
    }
}
