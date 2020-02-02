//
//  GlossaryDetailsVC.swift
//  MyMusicBook
//
//  Created by MUSTAFA DOĞUŞ on 23.01.2020.
//  Copyright © 2020 MUSTAFA DOĞUŞ. All rights reserved.
//

import UIKit
import CoreData

class GlossaryDetailsVC: UIViewController, UINavigationControllerDelegate {
    
    var chosenGlossary = ""
    var chosenGlossaryID: UUID?
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenGlossary != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GlossaryItems")
            
            let idString = chosenGlossaryID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        if let description = result.value(forKey: "descriptionOfItem") as? String {
                            descriptionText.text = description
                        }
                    }
                }
            } catch {
                print("Glossary fetch error")
            }
            
        } else {
            
        }
        
        //Gesture recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let appDalagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDalagate.persistentContainer.viewContext
        
        let newGlossaryItem = NSEntityDescription.insertNewObject(forEntityName: "GlossaryItems", into: context)
        
        //Attributes
        newGlossaryItem.setValue(UUID(), forKey: "id")
        newGlossaryItem.setValue(nameText.text, forKey: "name")
        newGlossaryItem.setValue(descriptionText.text, forKey: "descriptionOfItem")
        
        do {
            try context.save()
            print("Glossary item saved")
        } catch {
            print("Glossary item is not saved")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newGlossaryData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
