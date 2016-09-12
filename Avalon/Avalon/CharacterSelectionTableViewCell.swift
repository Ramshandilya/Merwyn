//
//  CharacterSelectionTableViewCell.swift
//  Avalon
//
//  Created by Ramsundar Shandilya on 9/11/16.
//  Copyright © 2016 Merwyn Games. All rights reserved.
//

import UIKit

class CharacterSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    static let kCellReuseIdentifier = "CharacterSelectionTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func toggleSelection(selected: Bool) {
        tickImageView.hidden = !selected
    }
    
}
