//
//  SongTableViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 16/12/2021.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageContainerView.layer.cornerRadius = 16.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model: SongModel) {
        songNameLabel.text = model.song
        artistNameLabel.text = model.artist
    }
    
    
    
}
