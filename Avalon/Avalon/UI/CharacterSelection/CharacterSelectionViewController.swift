//
//  ViewController.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/7/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import UIKit

class CharacterSelectionViewController: UIViewController {

    static let kStoryboardIdentifier = "CharacterSelectionViewController"
    
    let viewModel = CharacterSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startGame(sender: AnyObject) {
        let characters = viewModel.selectedCharacters()
        print(characters)
        
        let gameStateMachine = GameStateMachine(numberOfPlayers: viewModel.players.count)
        gameStateMachine.assignCharacters(toPlayers: viewModel.players, preSelectedCharacters: characters)
        
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: GameViewController.kStoryboardIdentifier) as? GameViewController else { return }
        
        navigationController?.pushViewController(gameVC, animated: true)
    }
}

extension CharacterSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterSelectionTableViewCell.kCellReuseIdentifier, for: indexPath) as! CharacterSelectionTableViewCell
        
        let row = viewModel.rows[indexPath.row]
        
        cell.toggleSelection(row.selected)
        cell.nameLabel.text = row.character.name
        
        return cell
    }
}

extension CharacterSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = viewModel.rows[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! CharacterSelectionTableViewCell
        
        if row.selectable {
            row.selected = !row.selected
            cell.toggleSelection(row.selected)
        }
    }
}

