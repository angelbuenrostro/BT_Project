//
//  PokemonTableViewController.swift
//  Pokedex
//
//  Created by Angel Buenrostro on 11/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit
import CoreData

class PokemonTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let apiController = APIController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Pokemon> = {
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        
        
        do {
            
            try frc.performFetch()
            
        } catch {
            
            print("Could not perform fetch: \(error)")
            
        }
        
        
        return frc
        
    }()
    

    // MARK: - Actions
    
    @IBAction func fetchPokemonButtonTapped(_ sender: UIButton) {
        
        self.apiController.getRandomPokemon()
        
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.rowHeight = 150
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell", for: indexPath) as! PokemonTableViewCell

        let pokemon = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = pokemon.name?.capitalized
        
        cell.idLabel.text = "ID: \(String(pokemon.id))"
        
        
        if let imgURLString = pokemon.imgURLString {
            
            cell.pokemonImageView.loadImageUsingCache(withUrl: imgURLString)
            
        }
        

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            let pokemon = fetchedResultsController.object(at: indexPath)
            
            let moc = CoreDataStack.shared.mainContext
            
            moc.delete(pokemon)
            
            
            do {
                
                try moc.save()
                
            } catch {
                
                moc.reset()
                
                print("Error saving managed object context: \(error)")
                
            }
            
            
        }
    }

}

// MARK: - Extensions

extension PokemonTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        
        switch (type) {
        case .insert:
            self.tableView?.insertSections(IndexSet(integer: sectionIndex), with: .automatic);
            break;
        case .delete:
            self.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .automatic);
            break;
        default:
            break;
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
        
    }
    
}


