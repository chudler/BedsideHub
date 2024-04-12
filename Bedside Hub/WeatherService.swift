//
//  WeatherService.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import Foundation
import OpenMeteoSdk
//
//struct WeatherData {
//    let currentTemperature: Double
//    let highTemperature: Double
//    let lowTemperature: Double
//    let currentCondition: String
//    let conditionIcon: String // Typically an identifier to an image resource
//}
//

struct WeatherData {
    let current: Current
    let hourly: Hourly
    let daily: Daily

    struct Current {
        let time: Date
        let temperature2m: Float
        let weatherCode: Float
        let icon: String
        let condition: String
    }
    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
        let weatherCode: [Float]
    }
    struct Daily {
        let time: [Date]
        let weatherCode: [Float]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
    }
}

class WeatherService {
    
    private var currentCode = 0
    private var debug = false
    
    func fetchCurrentWeather() async -> WeatherData? {
        // api.open-meteo.com
        // Alsip is at 41.6689° N, 87.7387° W
        let urlString = "https://api.open-meteo.com/v1/gfs?latitude=41.66&longitude=-87.73&current=temperature_2m,weather_code&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timezone=America%2FChicago&forecast_days=3&format=flatbuffers"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        if debug {
            return WeatherService.stubWeatherData()
        } else {
            do {
                let data = try await WeatherApiResponse.fetch(url: url)
                if let parsedData = parseWeatherData(data: data) {
                    return parsedData
                } else {
                    print("Failed to parse weather data")
                    return nil
                }
            } catch {
                print("Failed to fetch weather data: \(error)")
                return nil
            }

        }
    }
    
    static func stubWeatherData() -> WeatherData {
        let (condition, icon) = WeatherConditionMapper.mapWeatherCodeToConditionAndIcon(Int(1))
        return __stubWeatherData(condition: condition, icon: icon)

    }
    static func __stubWeatherData(condition: String, icon: String) -> WeatherData {
        print("Loading weather data with icon \(icon)")
        return WeatherData(
            current: .init(
                time: Date(),
                temperature2m: 31,
                weatherCode: 1,
                icon: icon,
                condition: condition
            ),
            hourly: .init(
                time: [Date()],
                temperature2m: [45],
                weatherCode: [1]
            ),
            daily: .init(
                time: [Date()],
                weatherCode: [3],
                temperature2mMax: [45],
                temperature2mMin: [36]
            )
        )
    }
    
    func replaceConditions(condition: String, icon: String) -> WeatherData {
        return WeatherService.__stubWeatherData(condition: condition, icon: icon)
    }
    
    private func parseWeatherData(data: [WeatherApiResponse]) -> WeatherData? {
        let response = data[0]
        
        /// Attributes for timezone and location
        let utcOffsetSeconds = response.utcOffsetSeconds
        //            let timezone = response.timezone
        //            let timezoneAbbreviation = response.timezoneAbbreviation
        let latitude = response.latitude
        let longitude = response.longitude
        print("LAT: \(latitude) LONG: \(longitude)")
        
        let current = response.current!
        let hourly = response.hourly!
        let daily = response.daily!
        
        let (icon, condition) = WeatherConditionMapper.mapWeatherCodeToConditionAndIcon(Int(response.current!.variables(at: 1)!.value))
        
        /// Note: The order of weather variables in the URL query and the `at` indices below need to match!
        let data = WeatherData(
            current: .init(
                time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                temperature2m: current.variables(at: 0)!.value,
                weatherCode: current.variables(at: 1)!.value,
                icon: icon,
                condition: condition
            ),
            hourly: .init(
                time: hourly.getDateTime(offset: utcOffsetSeconds),
                temperature2m: hourly.variables(at: 0)!.values,
                weatherCode: hourly.variables(at: 1)!.values
            ),
            daily: .init(
                time: daily.getDateTime(offset: utcOffsetSeconds),
                weatherCode: daily.variables(at: 0)!.values,
                temperature2mMax: daily.variables(at: 1)!.values,
                temperature2mMin: daily.variables(at: 2)!.values
            )
        )
        
        return data
    }
    
    func updateIcon() -> (String, String) {
        currentCode = (currentCode + 1) % 100
        print("Setting weather code to \(currentCode)")
        return WeatherConditionMapper.mapWeatherCodeToConditionAndIcon(currentCode)
    }
    }
