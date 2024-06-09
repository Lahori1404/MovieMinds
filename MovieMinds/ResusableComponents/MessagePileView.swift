//
//  MessagePileView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 09/06/24.
//

import SwiftUI

struct MessagePileView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(.blue.opacity(0.4))
            .cornerRadius(10)
            .padding([.top, .trailing], 4)
    }
}

#Preview {
    MessagePileView(text: "2023")
}
