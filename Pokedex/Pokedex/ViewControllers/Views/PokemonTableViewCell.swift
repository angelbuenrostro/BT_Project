//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Angel Buenrostro on 11/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
