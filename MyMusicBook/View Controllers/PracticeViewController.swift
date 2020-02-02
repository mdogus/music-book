//
//  PracticeViewController.swift
//  MyMusicBook
//
//  Created by MUSTAFA DOĞUŞ on 19.01.2020.
//  Copyright © 2020 MUSTAFA DOĞUŞ. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var dateArray = [String]()
    var timeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentedControl.removeAllSegments()
        let segments = ["All", "Week", "Month", "Year"]
        for segment in segments {
            segmentedControl.insertSegment(withTitle: segment, at: segments.count, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        dateArray.append("27 Ocak 2020 Pazartesi")
        dateArray.append("28 Ocak 2020 Salı")
        dateArray.append("29 Ocak 2020 Çarşamba")
        timeArray.append("3sa 25dk")
        timeArray.append("3sa 40dk")
        timeArray.append("4sa 05dk")
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "practiceCell", for: indexPath) as! PracticeCell
        
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.timeLabel.text = timeArray[indexPath.row]
        
        
        return cell
    }
    
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toPracticeDetailsVC", sender: nil)
    }

}
