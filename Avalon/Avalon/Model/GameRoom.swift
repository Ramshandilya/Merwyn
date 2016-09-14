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
    
    init?(json: JSONDictionary) {
        guard let name = json["name"] as? String else { return nil }
        
        self.name = name
    }
}