//
//  WordCell.swift
//  VocaNote
//
//  Created by 宮本琳太郎 on 2016/08/06.
//  Copyright © 2016年 rintaro. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell {
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
