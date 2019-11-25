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
        
        var urlPlus = baseURL
        
        if let id = id {
            // fetch by id
            let idString = String(id)
            urlPlus = urlPlus.appendingPathComponent(idString)
        } else if let name = name {
            // fetch by name
            urlPlus = urlPlus.appendingPathComponent(name)
        }
        
        var request = URLRequest(url: urlPlus)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let pokemonResult = try decoder.decode(PokemonResult.self, from: data)
                completion(.success(pokemonResult))
            } catch {
                completion(.failure(.noDecode))
            }
            
        }.resume()
    }
    
}
