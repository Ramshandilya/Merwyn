//
//  GameRoomsListViewController.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/13/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import UIKit

class GameRoomsListViewController: UIViewController {

    static let kStoryboardIdentifier = "GameRoomsListViewController"

    var gameRooms = [GameRoom]()
    let client = FirebaseClient()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        client.setupGameRoomObservers()
        client.gameRoomDelegate = self
        
        client.fetchRooms { (rooms) in
            self.gameRooms = rooms
            self.tableView.reloadData()
        }
    }
}

extension GameRoomsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        let gameRoom = gameRooms[indexPath.row]
        cell.textLabel?.text = gameRoom.name
        
        return cell
    }
}

extension GameRoomsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension GameRoomsListViewController: FirebaseClientGameRoomDelegate {
    
    func firebaseClient(_ client: FirebaseClient, databaseDidAddGameRoom room: GameRoom) {
        gameRooms.append(room)
        tableView.reloadData()
    }
}
