//
//  Characters.swift
//  GameRoom
//
//  Created by Ramsundar Shandilya on 9/7/16.
//  Copyright © 2016 Y Media Labs. All rights reserved.
//

import Foundation

enum Team {
    case LoyalServantsOfArthur
    case MinionsOfMordred
}

enum Character: Int {
    
    case Merlin = 1
    case Percival
    case Morgana
    case Mordred
    case Oberon
    case Assassin
    case LoyalServant1
    case LoyalServant2
    case LoyalServant3
    case LoyalServant4
    case MinionOfMordred1
    case MinionOfMordred2
    case MinionOfMordred3
    case MinionOfMordred4
    
    static let allLoyalServants: [Character] = [.Merlin, .Percival, LoyalServant1, LoyalServant2, LoyalServant3, LoyalServant4]
    
    static let allMinionsOfMordred: [Character] = [.Mordred, .Morgana, .Oberon, .Assassin, .MinionOfMordred1, .MinionOfMordred2, .MinionOfMordred3, .MinionOfMordred4]
    
    var name: String {
        var val = ""
        
        switch self {
        case .Mordred:
            val = "Mordred"
        case .Morgana:
            val = "Morgana"
        case .Merlin:
            val = "Merlin"
        case .Percival:
            val = "Percival"
        case .Oberon:
            val = "Oberon"
        case .Assassin:
            val = "Assassin"
        default:
            break
        }
        
        return val
    }
    
    var description: String {
        var val = ""
        
        switch self {
        case .Mordred:
            val = "Unknown to Merlin"
        case .Morgana:
            val = "Appears as Merlin"
        case .Merlin:
            val = "Knows evil"
        case .Oberon:
            val = "Unknown to evil"
        default:
            break
        }
        
        return val
    }
    
    var information: String {
        
        var val = ""
        
        switch self {
        case .MinionOfMordred1, .MinionOfMordred2, .MinionOfMordred3, .MinionOfMordred4, .Assassin, .Mordred, .Morgana:
            val = "The highlighted characters are the Minions of Mordred."
        case .Merlin:
            val = "The highlighted characters are the Minions of Mordred."
        case .Percival:
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
        case .MinionOfMordred1, .MinionOfMordred2, .MinionOfMordred3, .MinionOfMordred4, .Assassin, .Mordred, .Morgana:
            
            chars = characters.filter({ (char) -> Bool in
                return char.isMinionOfMordred() && char.rawValue != Character.Oberon.rawValue
            })
            
        case .Merlin:
            chars = characters.filter({ (char) -> Bool in
                return char.isMinionOfMordred() && char.rawValue != Character.Mordred.rawValue
            })
        case .Percival:
            chars = characters.filter({ (char) -> Bool in
                return char == .Merlin || char == .Morgana
            })
        default:
            break
        }
        
        return chars
    }
    
    
}

