//
//  SearchForItemResultsTableViewCell.swift
//  TestML
//
//  Created by Tomas on 05/06/2021.
//

import UIKit

class SearchForItemResultsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var labelItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}