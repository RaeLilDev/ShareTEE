//
//  AlbumCollectionViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 27/12/2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumCardView: UIView!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        albumCardView.layer.cornerRadius = 12.0
    }
    
    
    func configure(with model: AlbumModel) {
        albumNameLabel.text = model.album
    }

}
