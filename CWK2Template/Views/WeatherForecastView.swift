//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var body: some View {
        let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)
        let timezone = weatherMapViewModel.weatherDataModel?.timezone ?? ""
        let isNightTime = CommonUtils.isNighttime(for: TimeInterval(timestamp), in: timezone)
        let description = weatherMapViewModel.weatherDataModel?.current.weather
        let isRaining = CommonUtils.isRaining(description: description?.first?.weatherDescription ?? .clearSky)
        
        NavigationView {
            ZStack {
                VStack{
                    ScrollView{
                        VStack(alignment: .center, spacing: 16) {
                            
                            Text("Hourly Forecast")
                                .font(.headline)
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                            
                            if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack(spacing: 10) {
                                        
                                        ForEach(hourlyData) { hour in
                                            HourWeatherView(
                                                weatherDataTimeZone: weatherMapViewModel.weatherDataModel?.timezone ?? "",
                                                isNightTime: isNightTime ,
                                                isRaining: isRaining,
                                                current: hour
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                                .frame(height: 180)
                            }
                            Divider()
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            
                            Text("Daily Forecast")
                                .font(.headline)
                                .foregroundColor(.white)
                                .bold()
                            
                            VStack(alignment: .center, spacing: 10) {
                                ForEach(weatherMapViewModel.weatherDataModel?.daily ?? []) { day in
                                    DailyWeatherView(day: day)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(16)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Image(systemName: isNightTime ? "moon.stars.fill" : "sun.min.fill").foregroundColor(isNightTime || isRaining ? .white : .black)
                                
                                VStack{
                                    Text("Weather Forecast for \(weatherMapViewModel.city)")
                                        .font(.title3)
                                        .foregroundColor(isNightTime || isRaining ? .white : .black)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                }.background(
                    Image(isRaining ? "rainBackground" : isNightTime ? "nightSky" : "sky")
                    .aspectRatio(contentMode: .fill)
                )
            }
        }
    }
}

struct WeatherForcastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView()
    }
}
