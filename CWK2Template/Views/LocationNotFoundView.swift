//
//  LocationNotFoundView.swift
//  CWK2Template
//
//  Created by Miuru Abeysiriwardana on 2024-01-07.
//

import SwiftUI

struct LocationNotFoundView: View {
    var currentCity: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("location-notfound")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.5 , height: UIScreen.main.bounds.width * 0.4, alignment: .center)
            
            Text("No Tourist attractions found in \(currentCity)")
                .font(.subheadline)
                .foregroundColor(.primary)
                .bold()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
    }
}
