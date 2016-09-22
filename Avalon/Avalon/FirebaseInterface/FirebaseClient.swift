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

protocol FirebaseClientPlayerDelegate: class {
    func firebaseClient(_ client: FirebaseClient, playerDidJoin player: Player)
    func firebaseClient(_ client: FirebaseClient, playerDidLeave player: Player)
}

class FirebaseClient {
    
    let databseRef = FIRDatabase.database().reference()
    
    var gameRoomRef: FIRDatabaseReference {
        return databseRef.child(FirebaseKeys.GameRoom.kGameRooms)
    }
    
    weak var gameRoomDelegate: FirebaseClientGameRoomDelegate?
    weak var playerDelegate: FirebaseClientPlayerDelegate?
    
    var gameRoomRefHandle: FIRDatabaseHandle?
    var playerRefHandle: FIRDatabaseHandle?
    
    func playerRef(forGameRoom gameRoom: GameRoom) -> FIRDatabaseReference? {
        
        guard let id = gameRoom.id else {
            return nil
        }
        
        let ref = gameRoomRef.child("\(id)/\(FirebaseKeys.GameRoom.kPlayers))")
        
        return ref
    }
    
    deinit {
        
        if let handle = gameRoomRefHandle {
           gameRoomRef.removeObserver(withHandle: handle)
        }
        
        if let handle = playerRefHandle {
            gameRoomRef.removeObserver(withHandle: handle)
        }
    }
}

//GameRoom
extension FirebaseClient {
    
    func createRoom(withName name: String) {
        
        let host = Player()
        host.displayName = FIRAuth.auth()?.currentUser?.displayName
        host.isHost = true
        
        let room = GameRoom(name: name)
        room.players = [host]
        
        let roomData = room.toJSONDictionary()
        gameRoomRef.childByAutoId().setValue(roomData)
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
            
            DispatchQueue.main.async {
                completion(rooms)
            }
        })
    }
}

//Player
extension FirebaseClient {
    
    func setupPlayerObservers(forGameRoom gameRoom: GameRoom) {
        
        
        playerRefHandle = playerRef(forGameRoom: gameRoom)?.observe(FIRDataEventType.childAdded, with: {[weak self] (snapshot) in
            
            if let strongSelf = self,
                let snapshotJSON = snapshot.value as? JSONDictionary,
                let player = Player(json: snapshotJSON) {
                
                strongSelf.playerDelegate?.firebaseClient(strongSelf, playerDidJoin: player)
            }
            
            })
        
        playerRefHandle = playerRef(forGameRoom: gameRoom)?.observe(FIRDataEventType.childRemoved, with: {[weak self] (snapshot) in
            
            if let strongSelf = self,
                let snapshotJSON = snapshot.value as? JSONDictionary,
                let player = Player(json: snapshotJSON) {
                
                strongSelf.playerDelegate?.firebaseClient(strongSelf, playerDidLeave: player)
            }
            
            })
    }
    
    func fetchPlayers(forGameRoom gameRoom: GameRoom, completion: @escaping ([Player]) -> Void) {
        playerRef(forGameRoom: gameRoom)?.observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            
            var players = [Player]()
            
            for item in snapshot.children {
                
                if let snapshotJSON = (item as? FIRDataSnapshot)?.value as? JSONDictionary,
                    let player = Player(json: snapshotJSON) {
                    
                    players.append(player)
                }
            }
            
            DispatchQueue.main.async {
                completion(players)
            }
        })
    }
    
}
