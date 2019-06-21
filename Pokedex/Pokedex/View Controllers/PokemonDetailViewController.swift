//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Sean Acres on 6/21/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pokemonID: UILabel!
    @IBOutlet weak var pokemonTypes: UILabel!
    @IBOutlet weak var pokemonAbilities: UILabel!
    @IBOutlet weak var savePokemonButton: UIButton!
    
    var pokemon: Pokemon?
    var pokemonController: PokemonController?
    var isSearch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
 
        pokemonName.text = ""
        pokemonID.text = ""
        pokemonTypes.text = ""
        pokemonAbilities.text = ""
        savePokemonButton.isHidden = true
        
        updateViews()
    }
    
    @IBAction func savePokemonButtonTapped(_ sender: Any) {
        guard let pokemonController = pokemonController, let pokemon = pokemon else { return }
        pokemonController.savePokemonToList(pokemon: pokemon)
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard let pokemon = pokemon, let pokemonController = pokemonController else { return }
        
        if !isSearch {
            searchBar.isHidden = true
            savePokemonButton.isHidden = true
        } else {
            savePokemonButton.isHidden = false
        }
        
        pokemonName.text = pokemon.name.capitalized
        pokemonID.text = "ID: \(pokemon.id)"
        
        var pokemonTypesString = "Types: "
        for (index, y) in pokemon.types.enumerated() {
            if index == pokemon.types.endIndex-1 {
                pokemonTypesString.append("\(y.type.name.capitalized)")
            } else {
                pokemonTypesString.append("\(y.type.name.capitalized), ")
            }
        }
        pokemonTypes.text = pokemonTypesString
        
        var pokemonAbilitiesString = "Abilities: "
        for (index, y) in pokemon.abilities.enumerated() {
            if index == pokemon.abilities.endIndex-1 {
                pokemonAbilitiesString.append("\(y.ability.name.capitalized)")
            } else {
                pokemonAbilitiesString.append("\(y.ability.name.capitalized), ")
            }
        }
        pokemonAbilities.text = pokemonAbilitiesString
        
        pokemonController.fetchImage(at: pokemon.sprites.imageURL) { (result) in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print(result)
            }
        }
        
    }
}

extension PokemonDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let pokemonController = pokemonController,
            let searchTerm = searchBar.text,
            searchBar.text != "" else { return }
        pokemonController.searchForPokemon(named: searchTerm) { (result) in
            if let pokemon = try? result.get() {
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                    self.updateViews()
                }
            } else {
                print(result)
            }
        }
    }
}
