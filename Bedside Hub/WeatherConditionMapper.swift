//
//  WeatherConditionMapper.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import Foundation

struct WeatherConditionMapper {
    
    static func sunOrMoon() -> String {
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        
        if hour > 17 || hour < 6 {
            return "Night/"
        } else { // Between 6 AM and 5 PM
            return "Day/"
        }
    }
    static func mapWeatherCodeToConditionAndIcon(_ weatherCode: Int) -> (condition: String, icon: String) {
        let prefix = sunOrMoon()
        let (icon, conditions) = __mapWeatherCodeToConditionAndIcon(weatherCode)
        return ("\(prefix)\(icon)", conditions)
    }
        

    static func __mapWeatherCodeToConditionAndIcon(_ weatherCode: Int) -> (condition: String, icon: String) {
        switch weatherCode {
        case 0:
            return ("cloud-0", "Clear sky")
        case 1:
            return ("cloud-25", "Clouds dispersing")
        case 2:
            return ("cloud-0", "Sky unchanged")
        case 3:
            return ("cloud-50", "Clouds developing")
        case 4:
            return ("smoke-50", "Smoke")
        case 5:
            return ("haze-50", "Haze")
        case 6:
            return ("dust-50", "Dust in air")
        case 7:
            return ("dust-50", "Dust or sand raised by wind")
        case 8:
            return ("dust-50", "Dust whirls")
        case 9:
            return ("duststorm-50", "Duststorm or sandstorm")
        case 10:
            return ("fog-25", "Mist")
        case 11:
            return ("fog-25", "Fog patches")
        case 12:
            return ("fog-100", "Continuous fog")
        case 13:
            return ("lightning-50", "Lightning without thunder")
        case 14:
            return ("rain-10", "Precipitation not reaching ground")
        case 15:
            return ("rain-10", "Distant precipitation")
        case 16:
            return ("rain-25", "Nearby precipitation")
        case 17:
            return ("thunderstorm-50", "Thunderstorm, no precipitation")
        case 18:
            return ("squalls-50", "Squalls")
        case 19:
            return ("funnel-cloud-50", "Funnel cloud")
        case 20:
            return ("rain-50", "Drizzle or snow grains")
        case 21:
            return ("rain-50", "Rain")
        case 22:
            return ("snow-50", "Snow")
        case 23:
            return ("rain-snow-50", "Rain and snow or ice pellets")
        case 24:
            return ("freezing-rain-50", "Freezing drizzle or rain")
        case 25:
            return ("rain-75", "Shower(s) of rain")
        case 26:
            return ("snow-75", "Shower(s) of snow or rain and snow")
        case 27:
            return ("hail-showers", "Shower(s) of hail or rain and hail")
        case 28:
            return ("fog", "Fog or ice fog")
        case 29:
            return ("thunderstorm", "Thunderstorm")
        case 30:
            return ("duststorm", "Duststorm or sandstorm, decreasing")
        case 31:
            return ("duststorm", "Duststorm or sandstorm, no change")
        case 32:
            return ("duststorm", "Duststorm or sandstorm, increasing")
        case 33:
            return ("severe-duststorm", "Severe duststorm or sandstorm, decreasing")
        case 34:
            return ("severe-duststorm", "Severe duststorm or sandstorm, no change")
        case 35:
            return ("severe-duststorm", "Severe duststorm or sandstorm, increasing")
        case 36:
            return ("blowing-snow-low", "Blowing snow, low")
        case 37:
            return ("heavy-drifting-snow", "Heavy drifting snow")
        case 38:
            return ("blowing-snow-high", "Blowing snow, high")
        case 39:
            return ("heavy-drifting-snow", "Heavy drifting snow")
        case 40:
            return ("distant-fog", "Fog or ice fog at a distance, above observer level")
        case 41:
            return ("patchy-fog", "Fog or ice fog in patches")
        case 42:
            return ("fog-50", "Fog or ice fog thinning, sky visible")
        case 43:
            return ("fog-100", "Fog or ice fog, sky invisible")
        case 44:
            return ("fog-50", "Fog or ice fog, no change, sky visible")
        case 45:
            return ("fog-100", "Fog or ice fog, no change, sky invisible")
        case 46:
            return ("fog-50", "Fog or ice fog thickening, sky visible")
        case 47:
            return ("fog-100", "Fog or ice fog thickening, sky invisible")
        case 48:
            return ("fog-50", "Fog depositing rime, sky visible")
        case 49:
            return ("fog-100", "Fog depositing rime, sky invisible")
        case 50:
            return ("rain-10", "Intermittent drizzle, slight")
        case 51:
            return ("rain-50", "Continuous drizzle")
        case 52:
            return ("rain-50", "Intermittent drizzle, moderate")
        case 53:
            return ("rain-75", "Continuous drizzle, moderate")
        case 54:
            return ("rain-100", "Intermittent drizzle, heavy")
        case 55:
            return ("rain-100", "Continuous drizzle, heavy")
        case 56:
            return ("rain-50", "Freezing drizzle, slight")
        case 57:
            return ("rain-50", "Freezing drizzle, moderate or heavy")
        case 58:
            return ("rain-50", "Drizzle and rain, slight")
        case 59:
            return ("rain-100", "Drizzle and rain, moderate or heavy")
        case 60:
            return ("rain-50", "Intermittent rain, slight")
        case 61:
            return ("rain-100", "Continuous rain")
        case 62:
            return ("rain-25", "Intermittent rain, moderate")
        case 63:
            return ("rain-50", "Continuous rain, moderate")
        case 64:
            return ("rain-100", "Intermittent rain, heavy")
        case 65:
            return ("rain-100", "Continuous rain, heavy")
        case 66:
            return ("rain-10", "Freezing rain, slight")
        case 67:
            return ("rain-50", "Freezing rain, moderate or heavy")
        case 68:
            return ("rain-snow-10", "Rain or drizzle and snow, slight")
        case 69:
            return ("rain-snow-75", "Rain or drizzle and snow, moderate or heavy")
        case 80:
            return ("rain-shower-10", "Rain shower(s), slight")
        case 81:
            return ("rain-shower-moderate-heavy", "Rain shower(s), moderate or heavy")
        case 82:
            return ("rain-shower-violent", "Rain shower(s), violent")
        case 83:
            return ("rain-snow-mixed-shower-slight", "Shower(s) of rain and snow mixed, slight")
        case 84:
            return ("rain-snow-mixed-shower-moderate-heavy", "Shower(s) of rain and snow mixed, moderate or heavy")
        case 85:
            return ("snow-shower-slight", "Snow shower(s), slight")
        case 86:
            return ("snow-shower-moderate-heavy", "Snow shower(s), moderate or heavy")
        case 87:
            return ("snow-pellets-small-hail-shower-slight", "Shower(s) of snow pellets or small hail, slight")
        case 88:
            return ("snow-pellets-small-hail-shower-moderate-heavy", "Shower(s) of snow pellets or small hail, moderate or heavy")
        case 89:
            return ("hail-shower-slight", "Shower(s) of hail, slight, without thunder")
        case 90:
            return ("hail-shower-moderate-heavy", "Shower(s) of hail, moderate or heavy, without thunder")
        case 91:
            return ("rain-thunderstorm-slight", "Slight rain, thunderstorm earlier")
        case 92:
            return ("rain-thunderstorm-moderate-heavy", "Moderate or heavy rain, thunderstorm earlier")
        case 93:
            return ("snow-rain-mixed-slight", "Slight snow, or rain and snow mixed")
        case 94:
            return ("snow-rain-mixed-moderate-heavy", "Moderate or heavy snow, or rain and snow mixed")
        case 95:
            return ("thunderstorm-no-hail-slight-moderate", "Thunderstorm, slight or moderate, without hail")
        case 96:
            return ("thunderstorm-with-hail-slight-moderate", "Thunderstorm with hail, slight or moderate")
        case 97:
            return ("thunderstorm-heavy", "Thunderstorm, heavy, without hail")
        case 98:
            return ("thunderstorm-duststorm-sandstorm", "Thunderstorm with duststorm or sandstorm")
        case 99:
            return ("thunderstorm-heavy-with-hail", "Thunderstorm, heavy, with hail")
        default:
            return ("unknown", "Unknown")
        }
    }
}
