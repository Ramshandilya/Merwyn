//
//  FirebaseClient.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/13/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import Foundation
import Firebase

typealias JSONDictionary = Dictionary<String, Any>

private let kFirebaseURL = "https://merwyn-446f7.firebaseio.com/"

protocol FirebaseClientGameRoomDelegate: class {
    func firebaseClient(_ client: FirebaseClient, databaseDidAddGameRoom room: GameRoom)
}

class FirebaseClient {
    
    let databseRef = FIRDatabase.database().reference()
    
    var gameRoomRef: FIRDatabaseReference {
        return databseRef.child("game_rooms")
    }
    weak var gameRoomDelegate: FirebaseClientGameRoomDelegate?
    var gameRoomRefHandle: FIRDatabaseHandle!
    
    
    deinit {
        gameRoomRef.removeObserver(withHandle: gameRoomRefHandle)
    }
}

//GameRoom
extension FirebaseClient {
    
    func createRoom(withName name: String) {
        
        let playerName = FIRAuth.auth()?.currentUser?.displayName
        
        var mdata = JSONDictionary()
        
        mdata["name"] = name
        mdata["host_name"] = playerName
        mdata["players"] = [playerName]
        
        databseRef.child("game_rooms").childByAutoId().setValue(mdata)
    }
    
    func setupGameRoomObservers() {
        
        gameRoomRefHandle = gameRoomRef.observe(FIRDataEventType.childAdded, with: {[weak self] (snapshot) in
            if let strongSelf = self,
                let snapshotJSON = snapshot.value as? JSONDictionary,
                let gameRoom = GameRoom(json: snapshotJSON) {
                
                strongSelf.gameRoomDelegate?.firebaseClient(strongSelf, databaseDidAddGameRoom: gameRoom)
            }
        })
    }
    
    func fetchRooms(completion: @escaping ([GameRoom]) -> Void) {
        gameRoomRef.observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            
            var rooms = [GameRoom]()
            
            for item in snapshot.children {
                
                if let snapshotJSON = (item as? FIRDataSnapshot)?.value as? JSONDictionary,
                    let gameRoom = GameRoom(json: snapshotJSON) {
                    
                    rooms.append(gameRoom)
                }
            }
            
            completion(rooms)
        })
    }
}

