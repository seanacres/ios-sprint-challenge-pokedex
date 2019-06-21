//
//  PokemonController.swift
//  Pokedex
//
//  Created by Sean Acres on 6/21/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case otherError
    case badData
    case noDecode
}

class PokemonController {
    let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    var pokemonList: [Pokemon] = []
    
    func searchForPokemon(named: String, completion: @escaping (Result<Pokemon, NetworkError>) -> ()) {
        
        let searchURL = baseURL.appendingPathComponent("\(named.lowercased())")
        let request = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let pokemon = try jsonDecoder.decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(.noDecode))
            }
            }.resume()
    }
    
    func savePokemonToList(pokemon: Pokemon) {
        pokemonList.append(pokemon)
    }
}
