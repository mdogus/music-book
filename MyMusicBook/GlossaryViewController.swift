//
//  GlossaryViewController.swift
//  MyMusicBook
//
//  Created by MUSTAFA DOĞUŞ on 23.01.2020.
//  Copyright © 2020 MUSTAFA DOĞUŞ. All rights reserved.
//

import UIKit
import CoreData

class GlossaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var glossaryNameArray = [String]()
    var descriptionArray = [String]()
    var glossaryIDs = [UUID]()
    
    var selectedGlossary = ""
    var selectedGlossaryID: UUID?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        getGlossaryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getGlossaryData), name: NSNotification.Name("newGlossaryData"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return glossaryIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "glossaryCell", for: indexPath) as! GlossaryCell
        
        cell.nameLabel.text = glossaryNameArray[indexPath.row]
        cell.descriptionLabel.text = descriptionArray[indexPath.row]
        
        cell.nameLabel.lineBreakMode = .byWordWrapping
        cell.nameLabel.numberOfLines = 0
        cell.descriptionLabel.lineBreakMode = .byWordWrapping
        cell.descriptionLabel.numberOfLines = 0
        
        return cell
    }
    
    @objc func addButtonClicked() {
        selectedGlossary = ""
        performSegue(withIdentifier: "toGlossaryDetailsVC", sender: nil)
    }
    
    @objc func getGlossaryData() {
        glossaryNameArray.removeAll(keepingCapacity: false)
        descriptionArray.removeAll(keepingCapacity: false)
        glossaryIDs.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GlossaryItems")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    self.glossaryNameArray.append(name)
                }
                if let description = result.value(forKey: "descriptionOfItem") as? String {
                    self.descriptionArray.append(description)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.glossaryIDs.append(id)
                }
            }
        } catch {
            print("Fetch error")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGlossary = glossaryNameArray[indexPath.row]
        selectedGlossaryID = glossaryIDs[indexPath.row]
        performSegue(withIdentifier: "toGlossaryDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGlossaryDetailsVC" {
            let destination = segue.destination as! GlossaryDetailsVC
            destination.chosenGlossary = selectedGlossary
            destination.chosenGlossaryID = selectedGlossaryID
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GlossaryItems")
            
            let idString = glossaryIDs[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == glossaryIDs[indexPath.row] {
                                context.delete(result)
                                glossaryIDs.remove(at: indexPath.row)
                                glossaryNameArray.remove(at: indexPath.row)
                                descriptionArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    print("Error")
                                }
                                
                                break
                            }
                        }
                    }
                }
            } catch {
                print("Fetch error")
            }
        }
    }
}
