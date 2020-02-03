//
//  RepertoireViewController.swift
//  MyMusicBook
//
//  Created by MUSTAFA DOĞUŞ on 19.01.2020.
//  Copyright © 2020 MUSTAFA DOĞUŞ. All rights reserved.
//

import UIKit
import CoreData

class RepertoireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dataArray = [Data]()
    var imageArray = [UIImage]()
    var pieceNameArray = [String]()
    var opusArray = [String]()
    var formArray = [String]()
    var composerArray = [String]()
    var repertoireIDs = [UUID]()
    
    var selectedRepertoire = ""
    var selectedRepertoireID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repertoireTableView.delegate = self
        repertoireTableView.dataSource = self
        self.repertoireTableView.reloadData()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        getRepertoireData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getRepertoireData), name: NSNotification.Name("newData"), object: nil)
    }
    
    @IBOutlet weak var repertoireTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repertoireIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RepertoireCell
        
        cell.composerCellImage.image = imageArray[indexPath.row]
        cell.pieceNameCellLabel.text = pieceNameArray[indexPath.row]
        if !formArray.isEmpty {
            cell.opusCellLabel.text = "\(opusArray[indexPath.row]) · \(formArray[indexPath.row])"
        } else {
            cell.opusCellLabel.text = opusArray[indexPath.row]
        }
        cell.composerCellLabel.text = composerArray[indexPath.row]
        
        //Making lines multiple
        cell.pieceNameCellLabel.lineBreakMode = .byWordWrapping
        cell.pieceNameCellLabel.numberOfLines = 0
        cell.opusCellLabel.lineBreakMode = .byWordWrapping
        cell.opusCellLabel.numberOfLines = 0
        cell.composerCellLabel.lineBreakMode = .byWordWrapping
        cell.composerCellLabel.numberOfLines = 0
        
        return cell
    }
    
    @objc func addButtonClicked() {
        selectedRepertoire = ""
        performSegue(withIdentifier: "toRepDetailsVC", sender: nil)
    }
    
    @objc func getRepertoireData() {
        //Remove all from arrays
        imageArray.removeAll(keepingCapacity: false)
        pieceNameArray.removeAll(keepingCapacity: false)
        dataArray.removeAll(keepingCapacity: false)
        opusArray.removeAll(keepingCapacity: false)
        formArray.removeAll(keepingCapacity: false)
        composerArray.removeAll(keepingCapacity: false)
        repertoireIDs.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Repertoires")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let pieceName = result.value(forKey: "pieceName") as? String {
                    self.pieceNameArray.append(pieceName)
                }
                if let opus = result.value(forKey: "opus") as? String {
                    self.opusArray.append(opus)
                }
                if let composer = result.value(forKey: "composer") as? String {
                    self.composerArray.append(composer)
                }
                if let form = result.value(forKey: "form") as? String {
                    self.formArray.append(form)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.repertoireIDs.append(id)
                }
                if let data = result.value(forKey: "image") as? Data {
                    self.imageArray.append(UIImage(data: data)!)
                }
            }
        } catch {
            print("Fetch error")
        }   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRepertoire = pieceNameArray[indexPath.row]
        selectedRepertoireID = repertoireIDs[indexPath.row]
        performSegue(withIdentifier: "toRepDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRepDetailsVC" {
            let destination = segue.destination as! RepDetailsViewController
            destination.chosenRepertoire = selectedRepertoire
            destination.chosenRepertoireID = selectedRepertoireID
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Repertoires")
            
            let idString = repertoireIDs[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == repertoireIDs[indexPath.row] {
                                context.delete(result)
                                repertoireIDs.remove(at: indexPath.row)
                                pieceNameArray.remove(at: indexPath.row)
                                formArray.remove(at: indexPath.row)
                                opusArray.remove(at: indexPath.row)
                                composerArray.remove(at: indexPath.row)
                                imageArray.remove(at: indexPath.row)
                                
                                self.repertoireTableView.reloadData()
                                
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
