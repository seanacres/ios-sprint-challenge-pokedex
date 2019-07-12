//
//  PokemonTableViewController.swift
//  Pokedex
//
//  Created by Sean Acres on 7/12/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class PokemonTableViewController: UITableViewController {

    @IBOutlet weak var sortControl: UISegmentedControl!
    
    let pokemonController = PokemonController()
    var sortedPokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonController.loadFromPersistentStore()
        sortPokemon()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sortPokemon()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPokemon.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)

        let pokemon = sortedPokemon[indexPath.row]
        cell.textLabel?.text = pokemon.name.capitalized
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get the correct pokemon to delete
            let pokemon = sortedPokemon[indexPath.row]
            pokemonController.deletePokemon(pokemon)
            sortedPokemon.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func sortPokemon() {
        if sortControl.selectedSegmentIndex == 0 {
            sortedPokemon = pokemonController.savedPokemon.sorted(by: {$0.name < $1.name})
        } else {
            sortedPokemon = pokemonController.savedPokemon.sorted(by: {$0.id < $1.id})
        }
        
        tableView.reloadData()
    }

    @IBAction func sortSelectionChanged(_ sender: Any) {
        sortPokemon()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pokemonDetailVC = segue.destination as? PokemonDetailViewController else { return }
        
        if segue.identifier == "ShowPokemon" {
            guard let index = tableView.indexPathForSelectedRow else { return }
            pokemonDetailVC.pokemonController = pokemonController
            pokemonDetailVC.pokemon = sortedPokemon[index.row]
            pokemonDetailVC.isSearch = false
        } else if segue.identifier == "SearchPokemon" {
            pokemonDetailVC.pokemonController = pokemonController
            pokemonDetailVC.isSearch = true
        }
    }
}
