//
//  PlayersJoiningViewController.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/12/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import UIKit

class GameRoomViewController: UIViewController {

    static let kStoryboardIdentifier = "GameRoomViewController"
    
    var gameRoom: GameRoom!
    var players = [Player]()
    var isHost: Bool = false
    
    let client = FirebaseClient()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = gameRoom.name
        
        client.setupPlayerObservers(forGameRoom: gameRoom)
        client.playerDelegate = self
        
        client.fetchPlayers(forGameRoom: gameRoom) { (players) in
            self.players = players
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
}

extension GameRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        let player = players[indexPath.row]
        cell.textLabel?.text = player.displayName
        
        return cell
    }
}

extension GameRoomViewController: FirebaseClientPlayerDelegate {
    func firebaseClient(_ client: FirebaseClient, playerDidJoin player: Player) {
        players.append(player)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func firebaseClient(_ client: FirebaseClient, playerDidLeave player: Player) {
        if let index = players.index(where: { (p) -> Bool in
            return p === player
        }) {
            players.remove(at: index)
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }        
    }
}
