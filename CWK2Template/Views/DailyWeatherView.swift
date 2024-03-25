//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    var day: Daily
    var body: some View {
        let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt))

        HStack {
            if let description = day.weather.first {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(description.icon)@4x.png")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80) // Adjusted icon size
            }

            Spacer()

            VStack {
                Text(day.weather.first?.weatherDescription.rawValue.capitalized ?? "- -")
                    .font(.subheadline)
                
                Text(formattedDate)
                    .font(.subheadline)
                    .bold()
            }

            Spacer()

            VStack {
                Text(convertTemperature(day.temp.min, toFahrenheit: false))
                    .font(.caption)
                Text(convertTemperature(day.temp.max, toFahrenheit: false))
                    .font(.caption)
            }.padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity) // Make HStack take full width
        .background(Color.white.opacity(0.5)) // Light background color with opacity
        .cornerRadius(20) // Rounded corners
        .padding(.vertical, 5) // Optional padding around the HStack
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var day = WeatherMapViewModel().weatherDataModel!.daily
    static var previews: some View {
        DailyWeatherView(day: day[0])
    }
}
