//
//  TouristPlacesMapView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var locations: [Location] = []
    @State var  mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574), latitudinalMeters: 600, longitudinalMeters: 600)
    
    var body: some View {
        let filteredLocations = locations.filter { $0.cityName == weatherMapViewModel.city }
        
        var isNightTime: Bool {
            let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)
            let timezone = weatherMapViewModel.weatherDataModel?.timezone ?? ""
            return CommonUtils.isNighttime(for: TimeInterval(timestamp), in: timezone)
        }
        
        var isRaining: Bool {
            let description = weatherMapViewModel.weatherDataModel?.current.weather
            return CommonUtils.isRaining(description: description?.first?.weatherDescription ?? .clearSky)
        }
        
        var backgroundImageName: String {
            if isRaining {
                return "rainBackground"
            } else if isNightTime {
                return "nightSky"
            } else {
                return "sky"
            }
        }
        
        NavigationView {
            VStack{
                ScrollView {
                    VStack(spacing: 5) {
                        if weatherMapViewModel.coordinates != nil {
                            VStack(spacing: 10){
                                //Map(coordinateRegion: $mapRegion, showsUserLocation: true)
                                Map {
                                    ForEach(locations.filter { $0.cityName == weatherMapViewModel.city }) { location in
                                        Marker(location.name, coordinate: location.coordinates)
                                    }
                                }
                                .frame(height: UIScreen.main.bounds.height * 0.5)
                                .cornerRadius(20)
                                .padding()
                                
                            }
                        }
                        VStack {
                        
                        if (filteredLocations.isEmpty) {
                            LocationNotFoundView(currentCity: weatherMapViewModel.city)
                        } else {
                            ForEach(filteredLocations) { location in
                                HStack() {
                                    Image(String(location.imageNames.first ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.2)
                                        .clipped()
                                        .cornerRadius(10)
                                        .padding()
                                    
                                    Text(location.name)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(20)
                            }
                        }
                        }.padding(.horizontal)
                        
                    }
                    
                }.navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                VStack{
                                    Text("Tourist Attractions in \(weatherMapViewModel.city)")
                                        .font(.title3)
                                        .bold()
                                }
                            }
                        }
                    }
            }
            .background(
                Image(backgroundImageName)
                    .aspectRatio(contentMode: .fill)
            )
        }
        .onAppear {
            // process the loading of tourist places
            loadDataFromBundle()
        }
    }
    
    func loadDataFromBundle() {
        guard let fileURL = Bundle.main.url(forResource: "places", withExtension: "json")
        else {
            print("Couldn't find the file")
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(Places.self, from: data)
            locations = decodedData.places
        } catch {
            print("could not find the location")
        }
    }
}


//struct TouristPlacesMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        TouristPlacesMapView()
//    }
//}
