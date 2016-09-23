//
//  GameRules.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/7/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import Foundation

enum VoteToken: Int {
    case reject
    case approve
}

enum QuestCard: Int {
    case fail
    case success
}

enum QuestResult {
    case unknown
    case success (numberOfFails: Int?)
    case fail (numberOfFails: Int)
}

class GameRules {
    
    let minimumNumberOfPlayers = 5
    let maximumNumberOfPlayers = 10
    
    let numberOfMinions = [5: 2, 6: 2, 7: 3, 8: 3, 9: 4, 10: 4]
    
    private let playersForQuest: [Int: [Int]] =
        [5: [2, 3, 2, 3, 3],
         6: [2, 3, 4, 3, 4],
         7: [2, 3, 3, 4, 4],
         8: [3, 4, 4, 5, 5],
         9: [3, 4, 4, 5, 5],
         10: [3, 4, 4, 5, 5]]
    
    func numberOfPlayersForQuest(questNumber: Int, totalPlayers: Int) -> Int {
        
        guard questNumber < 5 && totalPlayers >= minimumNumberOfPlayers && totalPlayers <= maximumNumberOfPlayers else { return 0 }
        
        guard let game = playersForQuest[totalPlayers] else { return 0 }
        
        return game[questNumber]
    }
    
    func numberOfFailsRequired(questNumber: Int, totalPlayers: Int) -> Int {
        
        if totalPlayers >= 7 && questNumber == 3 {
            return 2
        }
        return 1
    }
}




