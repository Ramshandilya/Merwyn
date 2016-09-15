//
//  FirebaseClient.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/13/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import Foundation
import Firebase

typealias JSONDictionary = Dictionary<String, AnyObject>

private let kFirebaseURL = "https://merwyn-446f7.firebaseio.com/"

protocol GameRoomDelegate: class {
    func firebaseClient(client: FirebaseClient, databaseDidAddGameRoom room: GameRoom)
}

class FirebaseClient {
    
    let databseRef = FIRDatabase.database().reference()
    
    weak var gameRoomDelegate: GameRoomDelegate?
    
    var gameRoomRefHandle: FIRDatabaseHandle!
}

extension FirebaseClient {
    
    func setupGameRoomObservers() {
        
        gameRoomRefHandle = databseRef.child("game_rooms").observe(FIRDataEventType.childAdded, with: {[weak self] (snapshot) in
            if let strongSelf = self,
                let snapshotJSON = snapshot.value as? JSONDictionary,
                let gameRoom = GameRoom(json: snapshotJSON) {
                
                strongSelf.gameRoomDelegate?.firebaseClient(client: strongSelf, databaseDidAddGameRoom: gameRoom)
            }
        })
    }
}

