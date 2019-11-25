//
//  PokemonResult.swift
//  Pokedex
//
//  Created by Angel Buenrostro on 11/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation

struct PokemonResult: Codable {
    
    let name: String
    let id: Int
    var sprites: Sprites
    
}

struct Sprites: Codable {
    
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        
        case frontDefault = "front_default"
        
    }
}
