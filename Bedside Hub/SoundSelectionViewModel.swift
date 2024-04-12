//
//  SoundSelectionViewModel.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/4/24.
//

import Foundation
import OrderedCollections

//struct SoundCategory {
//    let name: String
//    var soundNames: [String]
//}

struct SoundSelection {
    var isSelected: Bool
    let name: String
}

class SoundSelectionViewModel: ObservableObject {
    @Published var categories: [String: [SoundSelection]] = [:]

    init(categories: OrderedDictionary<String, SoundCategory>) {
        for (category, sounds) in categories {
            self.categories[category] = sounds.soundNames.map { SoundSelection(isSelected: false, name: $0) }
        }
    }

    func toggleCategory(_ category: String, isSelected: Bool) {
        guard let sounds = categories[category] else { return }
        categories[category] = sounds.map { SoundSelection(isSelected: isSelected, name: $0.name) }
    }

    func toggleSound(for category: String, soundName: String) {
        guard let sounds = categories[category] else { return }
        categories[category] = sounds.map { sound in
            var modifiedSound = sound
            if sound.name == soundName {
                modifiedSound.isSelected = !sound.isSelected
            }
            return modifiedSound
        }
    }

    var selectedSounds: [String] {
        categories.values.flatMap { $0.filter { $0.isSelected }.map { $0.name } }
    }

}
