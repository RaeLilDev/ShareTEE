//
//  ArtistCollectionViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 25/12/2021.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var artistCardView: UIView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artistCardView.layer.cornerRadius = 12.0
    }
    
    public func configure(with modelData: ArtistModel) {
        artistNameLabel.text = modelData.artist
    }

}
