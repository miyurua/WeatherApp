//
//  CommonUtils.swift
//  CWK2Template
//
//  Created by Apple  on 2024-01-07.
//

import Foundation

class CommonUtils {
    static func isNighttime(for timestamp: TimeInterval, in timezoneIdentifier: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        dateFormatter.dateFormat = "HH"
        let hourString = dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
        if let hour = Int(hourString) {
            return hour < 6 || hour >= 18 //6AM to 6PM
        }
        return false
    }
    
    static func isRaining(description: Description) -> Bool {
        switch description {
        case .lightRain, .moderateRain, .heavyIntensityRain, .veryHeavyRain, .extremeRain, .freezingRain,
             .lightIntensityDrizzleRain, .drizzleRain, .heavyIntensityDrizzleRain, .showerRainAndDrizzle,
             .heavyShowerRainAndDrizzle, .showerDrizzle, .lightIntensityShowerRain, .showerRain,
             .heavyIntensityShowerRain, .raggedShowerRain, .thunderstormWithLightRain, .thunderstormWithRain,
             .thunderstormWithHeavyRain, .thunderstormWithLightDrizzle, .thunderstormWithDrizzle,
             .thunderstormWithHeavyDrizzle:
            return true
        default:
            return false
        }
    }
}
