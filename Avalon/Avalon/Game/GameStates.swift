//
//  GameStates.swift
//  GameRoom
//
//  Created by Ramsundar Shandilya on 9/7/16.
//  Copyright © 2016 Y Media Labs. All rights reserved.
//

import Foundation

enum GameState: Int {
    case selectCharacters = 1
    case gameStarted //Deal characters
    case selectQuestTeam
    case voteQuestTeam
    case questBegan
    case questEnded
    case gameEnded
}

import GameplayKit

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
    
    private(set) var players: [Player]!
    private(set) var playingCharacters = [Character]()
    
    private(set) var currentQuest = 0
    private(set) var score: [QuestResult] = [.unknown, .unknown, .unknown, .unknown, .unknown]
    
    private let rules = GameRules()
    
    init(numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
        
        super.init(states: [SelectCharactersState(), GameStartedState(), SelectQuestTeamState(), VoteQuestTeamState(), QuestBeganState(), QuestEndedState(), GameEndedState()])
        
        enter(SelectCharactersState.self)
    }
    
    func evaluateVotingRound(votes: [VoteToken]) -> Bool {
        let approveCount = votes.filter { (vote) -> Bool in
            return vote == .approve
        }.count
        
        let rejectCount = votes.count - approveCount
        
        return approveCount > rejectCount
    }
    
    func evaluateQuest(questCards: [QuestCard]) -> QuestResult {
        
        var result: QuestResult
        
        let failCount = questCards.filter { (card) -> Bool in
            return card == .fail
        }.count
        
        let failsRequired = rules.numberOfFailsRequired(questNumber: currentQuest, totalPlayers: numberOfPlayers)
        
        if failCount >= failsRequired {
            result = QuestResult.fail(numberOfFails: failCount)
        } else {
            result = QuestResult.success(numberOfFails: failCount)
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
            case .success:
                successes += 1
            default:
                break
            }
        }
        
        return (successes >= 3) ? Team.loyalServantsOfArthur : Team.minionsOfMordred
    }
    
    private func prepareCharacters(preSelected: [Character]?) {
        
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
        let normalMinions: [Character] = [.minionOfMordred1, .minionOfMordred2, .minionOfMordred3, .minionOfMordred4]
        let minionsToTake = normalMinions[0..<numOfMinionsToTake]
        
        
        let numOfLoyalsToTake = (numberOfPlayers - maxMinions) - numberOfLoyalsChosen
        let normalLoyals: [Character] = [.loyalServant1, .loyalServant2, .loyalServant3, .loyalServant4]
        let loyalsToTake = normalLoyals[0..<numOfLoyalsToTake]
        
        playingCharacters += minionsToTake + loyalsToTake
    }
    
    func assignCharacters(toPlayers players:[Player], preSelectedCharacters preSelected: [Character]) {
        prepareCharacters(preSelected: preSelected)
        
        guard let shuffledCharacters = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: playingCharacters) as? [Character] else {
            return
        }
        
        guard players.count == shuffledCharacters.count else {
            return //TODO: Throw error
        }
        
        for (index, player) in players.enumerated() {
            player.character = shuffledCharacters[index]
        }
    }
}

