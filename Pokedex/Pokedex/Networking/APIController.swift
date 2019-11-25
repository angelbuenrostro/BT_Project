//
//  APIController.swift
//  Pokedex
//
//  Created by Angel Buenrostro on 11/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case otherError
    case badData
    case noDecode
}

enum HTTPMethod: String {
    case get = "GET"
}

class APIController {
    
    let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchPokemon(id: Int?, name: String?, completion: @escaping(Result<PokemonResult, NetworkError>) -> Void) {
        
    }
    
}
