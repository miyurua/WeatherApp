import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var isLoading = false
    @State private var temporaryCity = ""
    @State private var showFahrenheit = false

    var body: some View {
        let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)
        let timezone = weatherMapViewModel.weatherDataModel?.timezone ?? ""
        let formattedLocalDate = DateFormatterUtils.formattedDateTime(from: TimeInterval(timestamp), timezoneIdentifier: timezone)
        let isNightTime = CommonUtils.isNighttime(for: TimeInterval(timestamp), in: timezone)
        let description = weatherMapViewModel.weatherDataModel?.current.weather
        let isRaining = CommonUtils.isRaining(description: description?.first?.weatherDescription ?? .clearSky)
        
        VStack {
            // Enhanced Search Bar
            VStack {
                HStack {
                    TextField("Enter New Location", text: $temporaryCity)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 40)) // Adjust for internal padding
                        .background(Color(.secondarySystemBackground)) // Background color of the TextField
                        .cornerRadius(30) // Increase the corner radius for a more rounded appearance
                        .shadow(radius: 5)
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.trailing,20)
                            }
                        )
                        .onSubmit {
                            weatherMapViewModel.city = temporaryCity
                            Task {
                                do {
                                    // write code to process user change of location
                                    try await weatherMapViewModel.getCoordinatesForCity(cityName: "\(temporaryCity)")
                                    
                                    _ = try await weatherMapViewModel.loadData(lat: weatherMapViewModel.coordinates?.latitude ??  51.503300, lon: weatherMapViewModel.coordinates?.longitude ?? -0.079400)

                                } catch {
                                    print("Error: \(error)")
                                    isLoading = false
                                }
                            }
                        }
                }
                .padding()
                
                //Spacer()
                
                VStack {
                    //City
                    Text(weatherMapViewModel.city)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                    
                    Text(formattedLocalDate)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .bold()
                }
                
                // Date Display

                
                // Spacer()
                
                HStack {
                    // Weather Description
                    if ((description?.first) != nil) {
                        // Weather icon
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(description?.first?.icon ?? "")@4x.png")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        // Weather description text
                        Text(description?.first?.weatherDescription.rawValue.capitalized ?? "")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(Color.white)
                        
                    } else {
                        Text("Description: N/A")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(Color.white)
                    }
                }
            }
        
            // Weather Information Section
            VStack {
                
                HStack {
                    WeatherInfoCardView(
                        title: "Temperature",
                        value: convertTemperature(weatherMapViewModel.weatherDataModel?.current.temp ?? 0, toFahrenheit: showFahrenheit),
                        iconName: "thermometer",
                        onTap: {
                            showFahrenheit.toggle()
                        }
                    )
                    
                    WeatherInfoCardView(
                        title: "Humidity",
                        value: "\(weatherMapViewModel.weatherDataModel?.current.humidity ?? 0) %",
                        iconName: "humidity.fill"
                    )
                }
                
                HStack {
                    WeatherInfoCardView(title: "Pressure",
                                    value: "\(weatherMapViewModel.weatherDataModel?.current.pressure ?? 0) hPa",
                                    iconName: "barometer"
                    )
                    
                    WeatherInfoCardView(title: "Wind Speed",
                                    value: "\(weatherMapViewModel.weatherDataModel?.current.windSpeed ?? 0) mph",
                                    iconName: "wind"
                    )
                }
            }
            .padding()
            
            Spacer()

        }
        .background(
            Image(isRaining ? "rainBackground" : isNightTime ? "nightSky": "sky")
//                .resizable()
                .aspectRatio(contentMode: .fill)
        )
    }

}

struct WeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNowView().environmentObject(WeatherMapViewModel())
    }
}
