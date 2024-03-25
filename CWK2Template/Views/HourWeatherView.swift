//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    var weatherDataTimeZone: String
    var isNightTime: Bool
    var isRaining: Bool
    var current: Current

    var body: some View {
        let formattedDate = DateFormatterUtils.formattedDateWithDay(from: TimeInterval(current.dt), timezoneIdentifier: weatherDataTimeZone )
        VStack {
            Text(String(current.weather.first?.weatherDescription.rawValue.capitalized ?? "- -"))
                .foregroundStyle(.white)
                .font(.subheadline)
                .padding([.all], 10)
            
            VStack(alignment: .center, spacing: 0) { // Center alignment and adjusted spacing
                if let description = current.weather.first {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(description.icon)@4x.png")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80) // Adjusted icon size
                }
                
                Text(convertTemperature(current.temp, toFahrenheit:false))
                    .font(.title3)
                    .foregroundColor(.white)
                    .bold()
                    .padding([.bottom],20)
                
            }
            .background(
                Image(isRaining ? "white-gradient" : isNightTime ? "blue-gradient" : "purple-gradient")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.4))
            .cornerRadius(40)
            
            Text(formattedDate)
                .font(.headline) // Updated font style
                .foregroundColor(.white)
                .shadow(radius: 3) // Added shadow for modern look
                .padding()
        }
    }
}




