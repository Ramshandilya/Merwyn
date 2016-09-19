//
//  GameRoom.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/13/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import Foundation

class GameRoom {
    
    var name: String
    var players = [Player]()
    var host: String?
    var started = false
    
    init(name: String) {
        self.name = name
    }
    
    convenience init?(json: JSONDictionary) {
        guard let name = json[FirebaseKeys.GameRoom.kName] as? String else { return nil }
        
        self.init(name: name)
        
        self.host = json[FirebaseKeys.GameRoom.kHostName] as? String
        
        if let playersJSON = json[FirebaseKeys.GameRoom.kPlayers] as? [JSONDictionary]{
            
            for json in playersJSON {
                if let player = Player(json: json) {
                    players.append(player)
                }
            }
        }

        if let started = json[FirebaseKeys.GameRoom.kStarted] as? Bool {
            self.started = started
        }
    }
}

extension GameRoom {
    
    func toJSONDictionary() -> JSONDictionary {
        
        var roomJSON = JSONDictionary()
        
        roomJSON[FirebaseKeys.GameRoom.kName] = name
        roomJSON[FirebaseKeys.GameRoom.kHostName] = host
        
        var playersJSON = [JSONDictionary]()
        
        for player in players {
            let json = player.toJSONDictionary()
            playersJSON.append(json)
        }
        roomJSON[FirebaseKeys.GameRoom.kPlayers] = playersJSON
        
        return roomJSON
    }
}
