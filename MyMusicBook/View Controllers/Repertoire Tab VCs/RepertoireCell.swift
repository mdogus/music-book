//
//  RepertoireCell.swift
//  MyMusicBook
//
//  Created by MUSTAFA DOĞUŞ on 20.01.2020.
//  Copyright © 2020 MUSTAFA DOĞUŞ. All rights reserved.
//

import UIKit

class RepertoireCell: UITableViewCell {

    @IBOutlet weak var composerCellImage: UIImageView!
    @IBOutlet weak var pieceNameCellLabel: UILabel!
    @IBOutlet weak var opusCellLabel: UILabel!
    @IBOutlet weak var composerCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
