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
    
    var pokemon: Pokemon? {
        didSet {
            updateViews()
        }
    }
    var pokemonController: PokemonController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func savePokemonButtonTapped(_ sender: Any) {
        guard let pokemonController = pokemonController, let pokemon = pokemon else { return }
        pokemonController.savePokemonToList(pokemon: pokemon)
    }
    
    func updateViews() {
        guard let pokemon = pokemon else { return }
        pokemonName.text = pokemon.name.capitalized
        pokemonID.text = "ID: \(pokemon.id)"
        
        var pokemonTypesString = "Types: "
        for x in pokemon.types {
            pokemonTypesString.append("\(x.type.name.capitalized) ")
        }
        pokemonTypes.text = pokemonTypesString
        
        var pokemonAbilitiesString = "Abilities: "
        for x in pokemon.abilities {
            pokemonAbilitiesString.append("\(x.ability.name.capitalized), ")
        }
        pokemonAbilities.text = pokemonAbilitiesString
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
                }
            } else {
                print(result)
            }
        }
    }
}
