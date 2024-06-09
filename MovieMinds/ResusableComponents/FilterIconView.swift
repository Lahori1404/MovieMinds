//
//  FilterIconView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 09/06/24.
//

import SwiftUI

struct FilterIconView: View {
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .resizable()
                .frame(width: 15, height: 15)
            Text("Filter")
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding(2)
        .padding(.horizontal, 8)
        .background(.blue.opacity(0.5))
        .cornerRadius(20)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}

#Preview {
    FilterIconView()
}
