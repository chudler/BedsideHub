//
//  WeatherView.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/18/24.
//

import SwiftUI

struct WeatherConditionsView: View {
    @Binding var weatherData: WeatherData
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text("\(weatherData.current.temperature2m, specifier: "%.0f")°")
                .font(.system(size: 50))
                .fontWeight(.light)
                .foregroundColor(.white)
            HStack {
                Text("H:\(weatherData.daily.temperature2mMax[0], specifier: "%.0f")")
                    .font(.system(size: 20))
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                Text("L:\(weatherData.daily.temperature2mMin[0], specifier: "%.0f")")
                    .font(.system(size: 20))
                    .fontWeight(.thin)
                    .foregroundColor(.white)
            }
            Text(weatherData.current.condition)
                           .font(.system(size: 25))
                           .fontWeight(.thin)
                           .foregroundColor(.white)
                           .lineLimit(1)
                           .truncationMode(.tail) // Truncate at the end if needed
                           .minimumScaleFactor(0.5) // Allows the text to scale down to 50% of its original size
                           .padding(.bottom, 3)
                   }
        .padding(.horizontal, 0)
    }
}

struct WeatherStatusView: View {
    let currentDate: String
    @Binding var weatherData: WeatherData
    
    var body: some View {
        HStack {
            // Left aligned text
                        VStack(alignment: .leading) {
                            DateView(currentDate: currentDate)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        WeatherIconView(weatherIcon: weatherData.current.icon)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            WeatherConditionsView(weatherData: $weatherData)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.trailing, 10)
        }
    }
}

struct WeatherIconView: View {
    let weatherIcon: String

    var body: some View {
        Group {
            Image("WeatherImage/\(weatherIcon)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: 512, maxHeight: 512)
        .padding(.bottom, -77)
    }
}
