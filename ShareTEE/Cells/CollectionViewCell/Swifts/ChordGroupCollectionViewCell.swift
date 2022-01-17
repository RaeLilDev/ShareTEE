//
//  ChordGroupCollectionViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 03/01/2022.
//

import UIKit

class ChordGroupCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var chordGroupContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chordGroupContainer.layer.cornerRadius = 16.0
    }
    
    func configure(with model: ChordGroupModel) {
        groupNameLabel.text = model.family_name
    }

}
