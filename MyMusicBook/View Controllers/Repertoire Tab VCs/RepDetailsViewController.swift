//
//  RepDetailsViewController.swift
//  MyMusicBook
//
//  Created by MUSTAFA DOĞUŞ on 20.01.2020.
//  Copyright © 2020 MUSTAFA DOĞUŞ. All rights reserved.
//

import UIKit
import CoreData

class RepDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var chosenRepertoire = ""
    var chosenRepertoireID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if chosenRepertoire != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Repertoires")
            
            let idString = chosenRepertoireID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "pieceName") as? String {
                            pieceNameText.text = name
                        }
                        if let form = result.value(forKey: "form") as? String {
                            formText.text = form
                        }
                        if let opus = result.value(forKey: "opus") as? String {
                            opusText.text = opus
                        }
                        if let composer = result.value(forKey: "composer") as? String {
                            composerText.text = composer
                        }
                        if let notes = result.value(forKey: "notes") as? String {
                            notesText.text = notes
                        }
                        if let birthYear = result.value(forKey: "birthYear") as? String {
                            birthYearText.text = String(birthYear)
                        }
                        if let deathYear = result.value(forKey: "deathYear") as? String {
                            deathYearText.text = String(deathYear)
                        }
                        if let compositionYear = result.value(forKey: "compositionYear") as? String {
                            compositionYearText.text = String(compositionYear)
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            composerImage.image = image
                        }
                        
                    }
                }
            } catch {
                print("Repertoire fetch error")
            }
            
        } else {
            
        }
        
        //Gesture recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        composerImage.isUserInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        composerImage.addGestureRecognizer(imageTapGesture)
    }
    
    @IBOutlet weak var composerImage: UIImageView!
    @IBOutlet weak var pieceNameText: UITextField!
    @IBOutlet weak var formText: UITextField!
    @IBOutlet weak var opusText: UITextField!
    @IBOutlet weak var composerText: UITextField!
    @IBOutlet weak var birthYearText: UITextField!
    @IBOutlet weak var deathYearText: UITextField!
    @IBOutlet weak var compositionYearText: UITextField!
    @IBOutlet weak var notesText: UITextField!
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDalagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDalagate.persistentContainer.viewContext
        
        let newRepertoire = NSEntityDescription.insertNewObject(forEntityName: "Repertoires", into: context)
        
        //Attributes
        newRepertoire.setValue(UUID(), forKey: "id")
        
        let imageData = composerImage.image!.jpegData(compressionQuality: 0.5)
        newRepertoire.setValue(imageData, forKey: "image")
        
        newRepertoire.setValue(pieceNameText.text, forKey: "pieceName")
        newRepertoire.setValue(formText.text, forKey: "form")
        newRepertoire.setValue(opusText.text, forKey: "opus")
        newRepertoire.setValue(composerText.text, forKey: "composer")
        
        if let birthYear = Int(birthYearText.text!) {
            newRepertoire.setValue(birthYear, forKey: "birthYear")
        }
        if let deathYear = Int(deathYearText.text!) {
            newRepertoire.setValue(deathYear, forKey: "deathYear")
        }
        if let compositionYear = Int(compositionYearText.text!) {
            newRepertoire.setValue(compositionYear, forKey: "deathYear")
        }
        
        newRepertoire.setValue(notesText.text, forKey: "notes")
        
        do {
            try context.save()
            print("Repertoire saved")
        } catch {
            print("Repertoire not saved")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        composerImage.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
