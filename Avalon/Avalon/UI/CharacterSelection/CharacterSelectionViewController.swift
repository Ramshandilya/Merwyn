//
//  ViewController.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/7/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import UIKit

class CharacterSelectionViewController: UIViewController {

    let viewModel = CharacterSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startGame(sender: AnyObject) {
        let characters = viewModel.selectedCharacters()
        print(characters)
    }
}

extension CharacterSelectionViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CharacterSelectionTableViewCell.kCellReuseIdentifier, forIndexPath: indexPath) as! CharacterSelectionTableViewCell
        
        let row = viewModel.rows[indexPath.row]
        
        cell.toggleSelection(row.selected)
        cell.nameLabel.text = row.character.name
        
        return cell
    }
}

extension CharacterSelectionViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = viewModel.rows[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CharacterSelectionTableViewCell
        
        if row.selectable {
            row.selected = !row.selected
            cell.toggleSelection(row.selected)
        }
    }
}

