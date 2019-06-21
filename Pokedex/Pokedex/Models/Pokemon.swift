//
//  Pokemon.swift
//  Pokedex
//
//  Created by Sean Acres on 6/21/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let id: String
    let abilties: [PokemonAbilities]
    let types: [PokemonTypes]
}

struct PokemonAbilities: Codable {
    let ability: [PokemonAbility]
}

struct PokemonAbility: Codable {
    let name: String
}

struct PokemonTypes: Codable {
    let type: [PokemonType]
}

struct PokemonType: Codable {
    let name: String
}