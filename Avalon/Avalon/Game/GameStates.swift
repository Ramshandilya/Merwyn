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
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SelectCharactersState.self
    }
}

class SelectCharactersState: GKState {
    
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == GameStartedState.self
    }
}

class GameStartedState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SelectQuestTeamState.self
    }
}

class SelectQuestTeamState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == VoteQuestTeamState.self
    }
}

class VoteQuestTeamState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == QuestBeganState.self) || (stateClass == SelectQuestTeamState.self)
    }
}

class QuestBeganState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == QuestEndedState.self
    }
}

class QuestEndedState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == GameEndedState.self) || (stateClass == SelectQuestTeamState.self)
    }
}

class GameEndedState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SelectCharactersState.self
    }
}

/*******************************/

class GameStateMachine: GKStateMachine {
    
    var numberOfPlayers: Int
    
    private(set) var playingCharacters = [Character]()
    private(set) var currentQuest = 0
    private(set) var score: [QuestResult?] = [nil, nil, nil, nil, nil]
    
    private let rules = GameRules()
    
    init(numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
        
        super.init(states: [PlayersJoiningState(), SelectCharactersState(), GameStartedState(), SelectQuestTeamState(), VoteQuestTeamState(), QuestBeganState(), QuestEndedState(), GameEndedState()])
        
        enter(PlayersJoiningState.self)
    }
    
    func evaluateVotingRound(votes: [VoteToken]) -> Bool {
        let approveCount = votes.filter { (vote) -> Bool in
            return vote == .Approve
        }.count
        
        let rejectCount = votes.count - approveCount
        
        return approveCount > rejectCount
    }
    
    func evaluateQuest(questCards: [QuestCard]) -> QuestResult {
        
        var result: QuestResult
        
        let failCount = questCards.filter { (card) -> Bool in
            return card == .Fail
        }.count
        
        let failsRequired = rules.numberOfFailsRequired(questNumber: currentQuest, totalPlayers: numberOfPlayers)
        
        if failCount >= failsRequired {
            result = QuestResult.Fail(numberOfFails: failCount)
        } else {
            result = QuestResult.Success(numberOfFails: failCount)
        }
        
        score[currentQuest] = result
        
        currentQuest += 1
        
        return result
    }
    
    func evaluateGameResult() -> Team? {
        
        let flatScore = score.flatMap { return $0 }
        
        guard flatScore.count == 5 else { return nil }
        
        var successes = 0
        for result in flatScore {
            switch result {
            case .Success:
                successes += 1
            default:
                break
            }
        }
        
        return (successes >= 3) ? Team.LoyalServantsOfArthur : Team.MinionsOfMordred
    }
    
    func prepareCharacters(preSelected: [Character]?) {
        
        guard let maxMinions = rules.numberOfMinions[numberOfPlayers] else { return }
        
        if let preSelected = preSelected {
            playingCharacters += preSelected
        }
        
        var numberOfMinionsChosen = 0
        var numberOfLoyalsChosen = 0
        
        for character in playingCharacters {
            if  character.isMinionOfMordred() {
                numberOfMinionsChosen += 1
            } else {
                numberOfLoyalsChosen += 1
            }
        }
        
        let numOfMinionsToTake = maxMinions - numberOfMinionsChosen
        let normalMinions: [Character] = [.MinionOfMordred1, .MinionOfMordred2, .MinionOfMordred3, .MinionOfMordred4]
        let minionsToTake = normalMinions[0..<numOfMinionsToTake]
        
        
        let numOfLoyalsToTake = (numberOfPlayers - maxMinions) - numberOfLoyalsChosen
        let normalLoyals: [Character] = [.LoyalServant1, .LoyalServant2, .LoyalServant3, .LoyalServant4]
        let loyalsToTake = normalLoyals[0..<numOfLoyalsToTake]
        
        playingCharacters += minionsToTake + loyalsToTake
    }
    
}

