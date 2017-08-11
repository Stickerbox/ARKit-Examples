//
//  VCTableViewCell.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit

class VCTableViewCell: UITableViewCell {
    
    static let reuseID = "VCCell"
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(from data: ARExample) {
        title.text = data.title
        subtitle.text = data.subtitle
    }

}
