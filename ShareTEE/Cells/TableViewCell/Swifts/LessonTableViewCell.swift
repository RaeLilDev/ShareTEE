//
//  LessonTableViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 19/12/2021.
//

import UIKit
import Alamofire
import AlamofireImage

class LessonTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: LessonModel) {
        titleLabel.text = model.title
        dateLabel.text = model.created_date
        let thumbnailURL = "https://sharetee.org/admin/thumbnail_folder/\(model.thumbnail)"
        setImage(from: thumbnailURL)
    }
    
    
    func setImage(from url: String) {
        
        let url = URL(string: url)!
        let placeholderImage = UIImage(named: "ShareTee")

        thumbnailImage.af.setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.2))
    }
}
