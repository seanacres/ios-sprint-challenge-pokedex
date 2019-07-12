//
//  PokemonTableViewController.swift
//  Pokedex
//
//  Created by Sean Acres on 7/12/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class PokemonTableViewController: UITableViewController {

    let pokemonController = PokemonController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonController.savedPokemon.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)

        let pokemon = pokemonController.savedPokemon[indexPath.row]
        cell.textLabel?.text = pokemon.name.capitalized
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get the correct pokemon to delete
            let pokemon = pokemonController.savedPokemon[indexPath.row]
            pokemonController.deletePokemon(pokemon)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pokemonDetailVC = segue.destination as? PokemonDetailViewController else { return }
        
        if segue.identifier == "ShowPokemon" {
            guard let index = tableView.indexPathForSelectedRow else { return }
            pokemonDetailVC.pokemonController = pokemonController
            pokemonDetailVC.pokemon = pokemonController.savedPokemon[index.row]
            pokemonDetailVC.isSearch = false
        } else if segue.identifier == "SearchPokemon" {
            pokemonDetailVC.pokemonController = pokemonController
            pokemonDetailVC.isSearch = true
        }
    }
}
