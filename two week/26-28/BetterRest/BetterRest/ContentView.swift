//
//  ContentView.swift
//  BetterRest
//
//  Created by Daria on 24.05.2024.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var bestTimeTitle = ""
    @State private var timeMessage = ""
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp) { _ in calculateBedtime() }
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount) { _ in calculateBedtime() }
                }
                
                Section("Daily coffee in take") {
                    Picker("Daily coffee in take", selection: $coffeeAmount, content: {
                        ForEach(0..<21) { i in
                            i == 1 || i == 0 ? Text("\(i) cup") : Text("\(i) cups")
                        }
                    })
                    .labelsHidden()
                    .onChange(of: coffeeAmount) { _ in calculateBedtime() }
                }
                Section("Daily coffee in take") {
                    Text("\(bestTimeTitle) \(timeMessage)")
                }
            }
            .navigationTitle("BetterRest")
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        .onAppear {
            calculateBedtime()
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            //            alertTitle = "Your ideal bedtime is…"
            //            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            bestTimeTitle = "Your ideal bedtime is"
            timeMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            //            alertTitle = "Error"
            //            alertMessage = "Sorry, there was a problem calculating your bedtime."
            bestTimeTitle = "Error"
            timeMessage = "Sorry, there was a problem calculating your bedtime."
            showingAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
