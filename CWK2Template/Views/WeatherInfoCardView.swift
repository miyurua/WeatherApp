//
//  WeatherInfoCardView.swift
//  CWK2Template
//
//  Created by Miuru Abeysiriwardana  on 2024-01-07.
//

import SwiftUI

struct WeatherInfoCardView: View {
    var title: String
    var value: String
    var iconName: String
    var onTap: (() -> Void)?

    var body: some View {
        HStack {
            Image(systemName: iconName)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.title3)
            }
        }
        .onTapGesture {
            onTap?()
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
