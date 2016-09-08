//
//  GameStates.swift
//  GameRoom
//
//  Created by Ramsundar Shandilya on 9/7/16.
//  Copyright © 2016 Y Media Labs. All rights reserved.
//

import Foundation

enum GameState: Int {
    case PlayersJoining = 1
    case SelectCharacters
    case GameStarted //Deal characters
    case SelectQuestTeam
    case VoteQuestTeam
    case QuestBegan
    case QuestEnded
    case GameEnded
}

import GameplayKit

class PlayersJoiningState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == SelectCharactersState.self
    }
}

class SelectCharactersState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == GameStartedState.self
    }
}

class GameStartedState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == SelectQuestTeamState.self
    }
}

class SelectQuestTeamState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == VoteQuestTeamState.self
    }
}

class VoteQuestTeamState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return (stateClass == QuestBeganState.self) || (stateClass == SelectQuestTeamState.self)
    }
}

class QuestBeganState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == QuestEndedState.self
    }
}

class QuestEndedState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return (stateClass == GameEndedState.self) || (stateClass == SelectQuestTeamState.self)
    }
}

class GameEndedState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == SelectCharactersState.self
    }
}

/*******************************/

class GameStateMachine: GKStateMachine {
    
    var numberOfPlayers: Int
    
    private(set) var currentQuest = 0
    private(set) var score: [Team?] = [nil, nil, nil, nil, nil]
    
    private let rules = GameRules()
    
    
    init(numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
        
        super.init(states: [PlayersJoiningState(), SelectCharactersState(), GameStartedState(), SelectQuestTeamState(), VoteQuestTeamState(), QuestBeganState(), QuestEndedState(), GameEndedState()])
        
        enterState(PlayersJoiningState.self)
    }
    
    func evaluateVotingRound(votes: [VoteToken]) -> Bool {
        let approveCount = votes.filter { (vote) -> Bool in
            return vote == .Approve
        }.count
        
        let rejectCount = votes.count - approveCount
        
        return approveCount > rejectCount
    }
    
    func evaluateQuest(questCards: [QuestCard]) -> Bool {
        
        var result = true
        
        let failCount = questCards.filter { (card) -> Bool in
            return card == .Fail
        }.count
        
        let failsRequired = rules.numberOfFailsRequired(currentQuest, totalPlayers: numberOfPlayers)
        
        result = failCount >= failsRequired
        
        return result
    }
}

