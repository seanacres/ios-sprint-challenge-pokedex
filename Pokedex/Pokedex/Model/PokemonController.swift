//
//  PokemonController.swift
//  Pokedex
//
//  Created by Sean Acres on 7/12/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import UIKit

class PokemonController {
    enum NetworkError: Error {
        case otherError
        case badData
        case noDecode
        case noEncode
        case badResponse
        case badAuth
        case noAuth
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    var savedPokemon: [Pokemon] = []
    
    // search by name or id
    func searchForPokemon(searchTerm: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent(searchTerm.lowercased())
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check for error
            if let error = error {
                NSLog("error searching: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            // check for response code
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Bad response while searching: \(response)")
                completion(.failure(.badResponse))
                return
            }
            
            // check for data
            guard let data = data else {
                NSLog("No data returned from search")
                completion(.failure(.badData))
                return
            }
            
            // decode data and pass to result
            let jsonDecoder = JSONDecoder()
            do {
                let pokemon = try jsonDecoder.decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                NSLog("failed to decode from search: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    // save pokemon
    func savePokemon(_ pokemon: Pokemon) {
        savedPokemon.append(pokemon)
    }
    
    // remove saved pokemon
    func deletePokemon(_ pokemon: Pokemon) {
        // find pokemon to delete by id and remove from array
        if let index = savedPokemon.firstIndex(where: { $0.id == pokemon.id }) {
            savedPokemon.remove(at: index)
        }
    }
    
    // fetch image from URL
    func fetchImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let imageURL = URL(string: urlString) else  {
            completion(.failure(.otherError))
            return
        }
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.badData))
                return
            }
            
            completion(.success(image))
            }.resume()
    }
}
