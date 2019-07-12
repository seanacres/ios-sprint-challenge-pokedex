//
//  Pokemon.swift
//  Pokedex
//
//  Created by Sean Acres on 7/12/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let abilities: [AbilityElement]
    let types: [TypeElement]
    let image: Sprite
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abilities
        case types
        case image = "sprites"
    }
}

struct AbilityElement: Codable {
    let ability: Ability
}

struct Ability: Codable {
    let name: String
}

struct TypeElement: Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
}

struct Sprite: Codable {
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "front_default"
    }
}
