//
//  TemperatureUtils.swift
//  CWK2Template
//
//  Created by Miuru on 2024-01-02.
//

import Foundation

func convertTemperature(_ kelvin: Double, toFahrenheit: Bool) -> String {
    if toFahrenheit {
        let fahrenheit = (kelvin - 273.15) * 9/5 + 32
        return String(format: "%.1f °F", fahrenheit)
    } else {
        let celsius = kelvin - 273.15
        return String(format: "%.1f °C", celsius)
    }
}
