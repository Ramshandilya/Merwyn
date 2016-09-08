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

