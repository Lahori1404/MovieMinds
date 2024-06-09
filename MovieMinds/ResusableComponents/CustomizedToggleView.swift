//
//  CustomizedToggleView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 09/06/24.
//

import SwiftUI

struct CustomizedToggleView: View {
    @Binding var isEnabled: Bool
    let textOne: String
    let textTwo: String
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(.gray.opacity(0.2))
            .overlay {
                RoundedRectangle(cornerRadius: 40)
                    .fill(.green.opacity(0.6))
                    .padding(2)
                    .offset(x: isEnabled ? -35 : 30)
                    .frame(width: isEnabled ? 70 : 80)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            }
            .frame(width: 140, height: 30)
            .overlay(alignment: .leading) {
                HStack(spacing: .zero) {
                    Text(textOne)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                    Spacer()
                    Text(textTwo)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 8)
            }
    }
}

#Preview {
    CustomizedToggleView(isEnabled: .constant(true),
                         textOne: "Today",
                         textTwo: "This Week")
}
