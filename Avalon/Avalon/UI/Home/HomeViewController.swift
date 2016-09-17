//
//  HomeViewController.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/13/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            let request = user?.profileChangeRequest()
            request?.displayName = UIDevice.current.name
            
            request?.commitChanges(completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        })
        
    }
}

extension HomeViewController {
    
    @IBAction func hostGame(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Enter Room Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Room Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let enterAction = UIAlertAction(title: "Enter", style: .default) {[weak self] (action) in
            
            if let textField = alertController.textFields?.first,
                let roomName = textField.text {
                self?.createRoom(name: roomName)
            }
        }
        alertController.addAction(enterAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func createRoom(name: String) {
        
        let client = FirebaseClient()
        client.createRoom(withName: name)
        
        guard let roomVC = storyboard?.instantiateViewController(withIdentifier: GameRoomViewController.kStoryboardIdentifier) as? GameRoomViewController else { return }
        
        navigationController?.pushViewController(roomVC, animated: true)
    }

}

extension HomeViewController {
    
    @IBAction func joinGame(_ sender: AnyObject) {
        
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: GameRoomsListViewController.kStoryboardIdentifier) as? GameRoomsListViewController else { return }
        
        navigationController?.pushViewController(listVC, animated: true)
    }
}
