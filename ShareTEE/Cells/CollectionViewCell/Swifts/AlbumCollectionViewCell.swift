//
//  AlbumCollectionViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 27/12/2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumCardView: UIView!
    @IBOutlet weak var albumNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(with model: AlbumModel) {
        albumNameLbl.text = model.album
    }

}
