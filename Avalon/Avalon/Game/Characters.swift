//
//  Characters.swift
//  GameRoom
//
//  Created by Ramsundar Shandilya on 9/7/16.
//  Copyright © 2016 Y Media Labs. All rights reserved.
//

import Foundation

enum Team {
    case loyalServantsOfArthur
    case minionsOfMordred
}

enum Character: Int {
    
    case merlin = 1
    case percival
    case morgana
    case mordred
    case oberon
    case assassin
    case loyalServant1
    case loyalServant2
    case loyalServant3
    case loyalServant4
    case minionOfMordred1
    case minionOfMordred2
    case minionOfMordred3
    case minionOfMordred4
    
    static let allLoyalServants: [Character] = [.merlin, .percival, loyalServant1, loyalServant2, loyalServant3, loyalServant4]
    
    static let allMinionsOfMordred: [Character] = [.mordred, .morgana, .oberon, .assassin, .minionOfMordred1, .minionOfMordred2, .minionOfMordred3, .minionOfMordred4]
    
    static let mandatoryCharacters: [Character] = [.merlin, .assassin]
    
    static let charactersToChoose: [Character] = [.mordred, .morgana, .oberon, .percival]
    
    var name: String {
        var val = ""
        
        switch self {
        case .mordred:
            val = "Mordred"
        case .morgana:
            val = "Morgana"
        case .merlin:
            val = "Merlin"
        case .percival:
            val = "Percival"
        case .oberon:
            val = "Oberon"
        case .assassin:
            val = "Assassin"
        default:
            break
        }
        
        return val
    }
    
    var description: String {
        var val = ""
        
        switch self {
        case .mordred:
            val = "Unknown to Merlin"
        case .morgana:
            val = "Appears as Merlin"
        case .merlin:
            val = "Knows evil"
        case .oberon:
            val = "Unknown to evil"
        default:
            break
        }
        
        return val
    }
    
    var information: String {
        
        var val = ""
        
        switch self {
        case .minionOfMordred1, .minionOfMordred2, .minionOfMordred3, .minionOfMordred4, .assassin, .mordred, .morgana:
            val = "The highlighted characters are the Minions of Mordred."
        case .merlin:
            val = "The highlighted characters are the Minions of Mordred."
        case .percival:
            val = "The highlighted characters are Merlin and Morgana."
        default:
            break
        }
        
        return val
    }
    
    func isMinionOfMordred() -> Bool {
        if Character.allMinionsOfMordred.contains(self) {
            return true
        }
        return false
    }
    
    func charactersToRevealFromCharacters(characters: [Character]) -> [Character]? {
        
        var chars: [Character]?
        
        switch self {
        case .minionOfMordred1, .minionOfMordred2, .minionOfMordred3, .minionOfMordred4, .assassin, .mordred, .morgana:
            
            chars = characters.filter({ (char) -> Bool in
                return char.isMinionOfMordred() && char.rawValue != Character.oberon.rawValue
            })
            
        case .merlin:
            chars = characters.filter({ (char) -> Bool in
                return char.isMinionOfMordred() && char.rawValue != Character.mordred.rawValue
            })
        case .percival:
            chars = characters.filter({ (char) -> Bool in
                return char == .merlin || char == .morgana
            })
        default:
            break
        }
        
        return chars
    }
    
    
}

