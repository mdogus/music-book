//
//  RepDetailsViewController.swift
//  MyMusicBook
//
//  Created by MUSTAFA DOĞUŞ on 20.01.2020.
//  Copyright © 2020 MUSTAFA DOĞUŞ. All rights reserved.
//

import UIKit

class RepDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    

}
