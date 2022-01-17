//
//  CategoryCollectionViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 15/12/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryView.layer.cornerRadius = 12.0
    }
    
    public func configure(with model: CategoryModel) {
        categoryImageView.image = model.image
        categoryNameLabel.text = model.name
    }

}
