//
//  CharacterSelectionViewModel.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/11/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import Foundation

class CharacterRow {
    var character: Character
    var selectable: Bool
    var selected: Bool
    
    init(character: Character, selectable: Bool, selected: Bool) {
        self.character = character
        self.selectable = selectable
        self.selected = selected
    }
}

class CharacterSelectionViewModel {
    
    var rows = [CharacterRow]()
    var players: [Player]!

    init() {
        
        for character in Character.mandatoryCharacters {
            let row = CharacterRow(character: character, selectable: false, selected: true)
            rows.append(row)
        }
        
        for character in Character.charactersToChoose {
            let row = CharacterRow(character: character, selectable: true, selected: false)
            rows.append(row)
        }
    }
    
    func selectedCharacters() -> [Character] {
        
        var chars = [Character]()
        
        for row in rows {
            if row.selected {
                chars.append(row.character)
            }
        }
        
        return chars
    }
}
