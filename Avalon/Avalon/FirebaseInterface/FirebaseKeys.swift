//
//  FirebaseKeys.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/18/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import Foundation

struct FirebaseKeys {
    
    struct GameRoom {
        
        static let kGameRooms = "game_rooms"
        static let kName = "name"
        static let kHostName = "host_name"
        static let kPlayers = "players"
        static let kStarted = "started"
    }
    
    struct Player {
        static let kId = "id"
        static let kDisplayName = "display_name"
        static let kIsHost = "is_host"
    }
    
}
