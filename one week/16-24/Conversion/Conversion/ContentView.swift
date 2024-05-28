//
//  ContentView.swift
//  Conversion
//
//  Created by Daria on 20.05.2024.
//

import SwiftUI

enum TemperatureScale: String, CaseIterable, Identifiable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
    
    var id: String { self.rawValue }
}

enum LengthScale: String, CaseIterable, Identifiable {
    case meters = "Meters"
    case kilometers = "Kilometers"
    case feet = "Feet"
    case yards = "Yards"
    case miles = "Miles"
    
    var id: String { self.rawValue }
}

enum TimeScale: String, CaseIterable, Identifiable {
    case seconds = "Seconds"
    case minutes = "Minutes"
    case hours = "Hours"
    case days = "Days"
    
    var id: String { self.rawValue }
}

enum VolumeScale: String, CaseIterable, Identifiable {
    case milliliters = "Milliliters"
    case liters = "Liters"
    case cups = "Cups"
    case pints = "Pints"
    case gallons = "Gallons"
    
    var id: String { self.rawValue }
}

struct ContentView: View {
    @State private var temperature = 0.0
    @State private var length = 0.0
    @State private var time = 0.0
    @State private var volume = 0.0
    
    @State private var selectedInputTemperatureScales: TemperatureScale = .celsius
    @State private var selectedConversionTemperatureScale: TemperatureScale = .fahrenheit
    
    @State private var selectedInputLengthScales: LengthScale = .meters
    @State private var selectedConversionLengthScale: LengthScale = .kilometers
    
    @State private var selectedInputTimeScales: TimeScale = .seconds
    @State private var selectedConversionTimeScale: TimeScale = .minutes
    
    @State private var selectedInputVolumeScales: VolumeScale = .milliliters
    @State private var selectedConversionVolumeScale: VolumeScale = .liters
    
    var convertedTemperature: Double {
        return convertTemperature(temperature, from: selectedInputTemperatureScales, to: selectedConversionTemperatureScale)
    }
    
    var convertedLength: Double {
        return convertLength(length, from: selectedInputLengthScales, to: selectedConversionLengthScale)
    }
    
    var convertedTime: Double {
        return convertTime(time, from: selectedInputTimeScales, to: selectedConversionTimeScale)
    }
    
    var convertedVolume: Double {
        return convertVolume(volume, from: selectedInputVolumeScales, to: selectedConversionVolumeScale)
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        NavigationStack {
            Form {
                // Temperature
                Section("Temperature conversion") {
                    TextField("Degrees", value: $temperature, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    
                    Picker("Input options", selection: $selectedInputTemperatureScales) {
                        ForEach(TemperatureScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Picker("Conversion options", selection: $selectedConversionTemperatureScale) {
                        ForEach(TemperatureScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Text("\(String(format: "%.2f", convertedTemperature))  \(selectedConversionTemperatureScale.rawValue)")
                }
                
                //Length
                Section("Length conversion") {
                    TextField("Length", value: $length, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    
                    Picker("Input options", selection: $selectedInputLengthScales) {
                        ForEach(LengthScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Picker("Conversion options", selection: $selectedConversionLengthScale) {
                        ForEach(LengthScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Text("\(String(format: "%.3f", convertedLength))  \(selectedConversionLengthScale.rawValue)")
                }
                
                //Time
                Section("Time conversion") {
                    TextField("Time", value: $time, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    
                    Picker("Input options", selection: $selectedInputTimeScales) {
                        ForEach(TimeScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Picker("Conversion options", selection: $selectedConversionTimeScale) {
                        ForEach(TimeScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Text("\(String(format: "%.2f", convertedTime))  \(selectedConversionTimeScale.rawValue)")
                }
                
                //volume
                Section("volume conversion") {
                    TextField("Volume", value: $volume, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    
                    Picker("Input options", selection: $selectedInputVolumeScales) {
                        ForEach(VolumeScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Picker("Conversion options", selection: $selectedConversionVolumeScale) {
                        ForEach(VolumeScale.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    
                    Text("\(String(format: "%.3f", convertedVolume))  \(selectedConversionVolumeScale.rawValue)")
                }
            }
            .navigationTitle("Conversion")
        }
    }
    func convertTemperature(_ value: Double, from inputScale: TemperatureScale, to outputScale: TemperatureScale) -> Double {
        var celsiusValue: Double
        switch inputScale {
        case .celsius:
            celsiusValue = value
        case .fahrenheit:
            celsiusValue = (value - 32) * 5 / 9
        case .kelvin:
            celsiusValue = value - 273.15
        }
        
        switch outputScale {
        case .celsius:
            return celsiusValue
        case .fahrenheit:
            return celsiusValue * 9 / 5 + 32
        case .kelvin:
            return celsiusValue + 273.15
        }
    }
    
    func convertLength(_ value: Double, from inputScale: LengthScale, to outputScale: LengthScale) -> Double {
        var metersValue: Double
        switch inputScale {
        case .meters:
            metersValue = value
        case .kilometers:
            metersValue = value * 1000
        case .feet:
            metersValue = value * 0.3048
        case .yards:
            metersValue = value * 0.9144
        case .miles:
            metersValue = value * 1609.34
        }
        
        switch outputScale {
        case .meters:
            return metersValue
        case .kilometers:
            return metersValue / 1000
        case .feet:
            return metersValue / 0.3048
        case .yards:
            return metersValue / 0.9144
        case .miles:
            return metersValue / 1609.34
        }
    }
    
    func convertTime(_ value: Double, from inputScale: TimeScale, to outputScale: TimeScale) -> Double {
        var secondValue: Double
        switch inputScale {
        case .seconds:
            secondValue = value
        case .minutes:
            secondValue = value * 60
        case .hours:
            secondValue = value * 3600
        case .days:
            secondValue = value * 86400
        }
        
        switch outputScale {

        case .seconds:
            return secondValue
        case .minutes:
            return secondValue / 60
        case .hours:
            return secondValue / 3600
        case .days:
            return secondValue / 86400
        }
    }
    
    func convertVolume(_ value: Double, from inputScale: VolumeScale, to outputScale: VolumeScale) -> Double {
        var millilitersValue: Double
        switch inputScale {
        case .milliliters:
            millilitersValue = value
        case .liters:
            millilitersValue = value * 1000
        case .cups:
            millilitersValue = value * 240
        case .pints:
            millilitersValue = value * 473.2
        case .gallons:
            millilitersValue = value * 3785
        }
        
        switch outputScale {
        case .milliliters:
            return millilitersValue
        case .liters:
            return millilitersValue / 1000
        case .cups:
            return millilitersValue / 240
        case .pints:
            return millilitersValue / 473.2
        case .gallons:
            return millilitersValue / 3785
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
