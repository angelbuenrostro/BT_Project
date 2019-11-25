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
    
    
    func getRandomPokemon() {
        
        let moc = CoreDataStack.shared.mainContext
        
        // Return 10 Random Pokemon
        for _ in 0..<10 {
            
            // Gets a random value within the range of existing pokemon ids
            let num = Int.random(in: 1...807)
            
            // Check if a pre-existing pokemon record is in the CoreData store to prevent duplicate saves
            let predicate = NSPredicate(format: "id == %i", num)
            
            let request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
            
            request.predicate = predicate
            
            
            do {
                
                let result = try moc.fetch(request)
                
                if result.count > 0 {
                    
                    return
                    
                } else {
                    
                    // If no pre-existing record is found make a network request and save new object to store
                    fetchPokemon(id: num, name: nil) { (result) in
                        
                        if let pokemonResult = try? result.get() {
                            
                            let _ = Pokemon(name: pokemonResult.name,
                                                     imgURLString: pokemonResult.sprites.frontDefault,
                                                     id: Int16(pokemonResult.id),
                                                     context: moc)
                            
                            do {
                                
                                try moc.save()
                                
                            } catch {
                                
                                print("Error saving managed object context: \(error)")
                                
                            }
                            
                        } else {
                            // Network Request failed
                            print(result)
                            
                        }
                        
                    }
                    
                }
            } catch {
                
                print("Error checking for pre-existing record: \(error)")
                
            }
            
        }
        
    }
    
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
