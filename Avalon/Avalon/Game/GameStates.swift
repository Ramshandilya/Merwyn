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
    case GameStarted
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
    
    override func willExitWithNextState(nextState: GKState) {
        guard let stateMachine = stateMachine as? GameStateMachine else { return }
        
        stateMachine.incrementQuestCounter()
    }
}

class GameEndedState: GKState {
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == SelectCharactersState.self
    }
}

/*******************************/

class GameStateMachine: GKStateMachine {
    
    private(set) var questsCompleted = 0
    
    
    func incrementQuestCounter() {
        questsCompleted += 1
    }
}
