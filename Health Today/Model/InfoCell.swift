//
//  InfoCell.swift
//  Health Today
//
//  Created by David Jr on 12/26/20.
//  Copyright © 2020 David Jr. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDescription: UILabel!
    @IBOutlet weak var infoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
