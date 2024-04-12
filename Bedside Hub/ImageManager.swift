//
//  ImageManager.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import UIKit
import OrderedCollections

class ImageManager : ObservableObject {
    
    var categories: OrderedDictionary<String, ImageCategory> = [:]
    private var currentIndex = 0
    
    init() {
        configureCategories()
    }
    
    private func configureCategories() {
        categories["Nature"] = ImageCategory(name: "Nature", imageNames: ["MountainMoon", "BeachMoon", "MistyMountain", "Seascape", "Forest", "Bamboo", "ZenGarden", "GalaxyTree", "NorthernLights"])
        categories["Cities"] = ImageCategory(name: "Cities", imageNames: ["CityRiver", "CityWatercolor", "CityScape", "RainWindow", "SnowVillage"])
        categories["Fantasy"] = ImageCategory(name: "Fantasy", imageNames: ["Planetscape", "StrawberryKid", "Planetscape2", "Forest", "FloatingIslands", "Aurora", "SnowAurora"])
        categories["Abstract"] = ImageCategory(name: "Abstract", imageNames: ["Gradient", "BronzeFace", "WavyBlack", "Gradient2", "Watercolor", "Carnival"])
        categories["Animal"] = ImageCategory(name: "Animal", imageNames: ["Elephant", "BirdEdu", "FluffyDog", "PotterCat", "PotterCat2"])

        categories["System Default (all)"] = ImageCategory(name: "All", imageNames:
            Array(categories.values
                .flatMap({ (category) -> [String] in
                    category.imageNames.map({ (imageName) -> String in
                        "BackgroundImage/\(category.name)/\(imageName)"
                    })
                })
            )
        )
        print("Done loading images")
    }
    
    func nextImage(forCategory categoryName: String) -> String? {
        var categorySize = 0
        var imageName : String = "BackgroundImage/Nature/MountainMoon"
        if let category = categories[categoryName] {
            print("Looking up image for \(categoryName) with currentIndex \(currentIndex) and \(categorySize)")
            if category.name == "All" {
                imageName = category.imageNames[currentIndex]
            } else {
                imageName = "BackgroundImage/\(category.name)/\(category.imageNames[currentIndex])"
            }
            categorySize = category.imageNames.count
        } else {
            imageName = ""
        }
        currentIndex = (currentIndex + 1) % categorySize
        print("set Currentindex to \(currentIndex) with categorySize \(categorySize) for \(categoryName)")
        return imageName
    }
}

struct ImageCategory {
    let name: String
    var imageNames: [String]

    init(name: String, imageNames: [String]) {
        self.name = name
        self.imageNames = imageNames
    }
}
