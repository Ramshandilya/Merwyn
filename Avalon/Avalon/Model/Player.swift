//
//  File.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/13/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import Foundation

class Player {
    
    var id: String?
    var displayName: String?
    var isHost = false
    
    var displayPhotoURL: String?
    
    var character: Character?
    
    weak var gameRoom: GameRoom?
    
     convenience init?(json: JSONDictionary) {
        guard let name = json[FirebaseKeys.Player.kDisplayName] as? String else { return nil }
        
        self.init()
        
        self.displayName = name
        if let isHost = json[FirebaseKeys.Player.kIsHost] as? Bool {
            self.isHost = isHost
        }
        
        if let val = json[FirebaseKeys.Player.kCharacter] as? Int {
            self.character = Character(rawValue: val)
        }
    }
}

extension Player {
    
    func toJSONDictionary() -> JSONDictionary {
        
        var playerData = JSONDictionary()
        playerData[FirebaseKeys.Player.kDisplayName] = displayName
        playerData[FirebaseKeys.Player.kId] = id
        playerData[FirebaseKeys.Player.kIsHost] = isHost
        playerData[FirebaseKeys.Player.kCharacter] = character?.rawValue
        
        return playerData
    }
}
