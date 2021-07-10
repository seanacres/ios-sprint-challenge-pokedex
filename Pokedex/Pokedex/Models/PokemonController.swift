//
//  PokemonController.swift
//  Pokedex
//
//  Created by Sean Acres on 6/21/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import UIKit

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
    
    func fetchImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
        let imageURL = URL(string: urlString)!
        let request = URLRequest(url: imageURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let image = UIImage(data: data)!
            completion(.success(image))
            }.resume()
    }
    
    func stringAbilties(from pokemon: Pokemon) -> String {
        var pokemonAbilitiesString = "Abilities: "
        for (index, y) in pokemon.abilities.enumerated() {
            if index == pokemon.abilities.endIndex-1 {
                pokemonAbilitiesString.append("\(y.ability.name.capitalized)")
            } else {
                pokemonAbilitiesString.append("\(y.ability.name.capitalized), ")
            }
        }
        return pokemonAbilitiesString
    }
    
    func stringTypes(from pokemon: Pokemon) -> String {
        var pokemonTypesString = "Types: "
        for (index, y) in pokemon.types.enumerated() {
            if index == pokemon.types.endIndex-1 {
                pokemonTypesString.append("\(y.type.name.capitalized)")
            } else {
                pokemonTypesString.append("\(y.type.name.capitalized), ")
            }
        }
        return pokemonTypesString
    }
    
    func savePokemonToList(pokemon: Pokemon) {
        pokemonList.append(pokemon)
    }
}
