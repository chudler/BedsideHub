//
//  SoundsView.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import SwiftUI

struct SoundSelectionView: View {
    @ObservedObject var viewModel: SoundSelectionViewModel

    var body: some View {
        List {
            ForEach(viewModel.categories.keys.sorted(), id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(viewModel.categories[category] ?? [], id: \.name) { sound in
                        HStack {
                            Text(sound.name)
                            Spacer()
                            Image(systemName: sound.isSelected ? "checkmark.square" : "square")
                                .onTapGesture {
                                    viewModel.toggleSound(for: category, soundName: sound.name)
                                }
                        }
                    }
                    .onTapGesture {
                        if let areAllSelected = viewModel.categories[category]?.allSatisfy({ $0.isSelected }), areAllSelected {
                            viewModel.toggleCategory(category, isSelected: false)
                        } else {
                            viewModel.toggleCategory(category, isSelected: true)
                        }
                    }
                }
            }
        }
    }
}



//
//// AuxiliaryMenuView is expanded to include sound selection functionality
//struct SoundsView: View {
//    
//    @ObservedObject var viewModel: SoundSelectionViewModel
//    // Stub data for demonstration purposes
////    private let soundCategories = ["Nature", "Urban", "Melodies", "Texture"]
////    // This dictionary is a placeholder. You would populate it based on your app's data.
////    private let soundsByCategory: [String: [String]] = [
////        "Nature": ["LightRain", "Forest", "Ocean"],
////        "Urban": ["Traffic", "City Park", "Subway"],
////        "Melodies": ["Piano", "Guitar", "Flute"]
////    ]
//
//    var body: some View {
//        VStack {
//                List {
//                    ForEach(soundCategories, id: \.self) { category in
//                        Section(header: Text(category)) {
//                            ForEach(soundsByCategory[category] ?? [], id: \.self) { sound in
//                                Button(sound) {
//                                    // Handle sound selection
//                                    print("Selected sound: \(sound)")
//                                }
//                            }
//                        }
//                    }
//                }
//        }
//        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300, maxHeight: .infinity)
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(10)
//        .shadow(radius: 5)
//    }
//}
