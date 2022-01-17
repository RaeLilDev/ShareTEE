//
//  ChordModel.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 08/01/2022.
//

import Foundation

class ChordModel: Codable {
    var chord: String
    var chord_image: String
    var is_selected = false
    
    init(chord: String, chord_image: String, is_selected: Bool) {
        self.chord = chord
        self.chord_image = chord_image
        self.is_selected = is_selected
    }
}
