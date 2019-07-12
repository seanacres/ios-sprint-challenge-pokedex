//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Sean Acres on 7/12/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonTypesLabel: UILabel!
    @IBOutlet weak var pokemonAbilitiesLabel: UILabel!
    @IBOutlet weak var savePokemonButton: UIButton!
    
    var pokemonController: PokemonController?
    var pokemon: Pokemon?
    var isSearch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        updateViews()
    }
    
    @IBAction func savePokemonButtonTapped(_ sender: Any) {
        guard let pokemon = pokemon,
            let pokemonController = pokemonController else { return }
        
        pokemonController.savePokemon(pokemon)
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        if let pokemon = pokemon {
            title = pokemon.name.capitalized
            pokemonNameLabel.text = pokemon.name.capitalized
            pokemonIDLabel.text = "ID: \(pokemon.id)"
            
            // set up types label
            pokemonTypesLabel.text = "Types: "
            for (index, element) in pokemon.types.enumerated() {
                // only add comma if not the last element
                if index == pokemon.abilities.endIndex-1 {
                    pokemonTypesLabel.text?.append("\(element.type.name.capitalized)")
                } else {
                    pokemonTypesLabel.text?.append("\(element.type.name.capitalized), ")
                }
            }
            
            // set up abilties label
            pokemonAbilitiesLabel.text = "Abilties: "
            for (index, element) in pokemon.abilities.enumerated() {
                // only add comma if not the last element
                if index == pokemon.abilities.endIndex-1 {
                    pokemonAbilitiesLabel.text?.append("\(element.ability.name.capitalized)")
                } else {
                    pokemonAbilitiesLabel.text?.append("\(element.ability.name.capitalized), ")
                }
            }
            
            savePokemonButton.isHidden = false
            // hide search bar and save button if isSearch is false
            if !isSearch {
                savePokemonButton.isHidden = true
                searchBar.isHidden = true
            }
        } else {
            pokemonNameLabel.text = ""
            pokemonIDLabel.text = ""
            pokemonTypesLabel.text = ""
            pokemonAbilitiesLabel.text = ""
            savePokemonButton.isHidden = true
        }
    }
}

extension PokemonDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let pokemonController = pokemonController,
            let searchTerm = searchBar.text,
            !searchTerm.isEmpty else { return }
        
        // search for pokemon and set pokemon var if successful
        pokemonController.searchForPokemon(searchTerm: searchTerm) { (result) in
            if let pokemon = try? result.get() {
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                    self.updateViews()
                    self.searchBar.endEditing(true)
                }
            }
        }
    }
}
