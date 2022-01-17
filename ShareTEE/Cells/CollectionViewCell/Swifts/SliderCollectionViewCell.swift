//
//  SliderCollectionViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 15/12/2021.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sliderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sliderImage.layer.cornerRadius = 12.0
    }

}
