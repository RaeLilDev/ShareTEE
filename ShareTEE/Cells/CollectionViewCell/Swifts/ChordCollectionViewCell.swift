//
//  ChordCollectionViewCell.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 08/01/2022.
//

import UIKit

class ChordCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var chordNameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var onTapItem: ((String)->Void) = {
        _ in
    }
    
    var data : ChordModel?=nil {
        didSet{
            if let chord = data {
                chordNameLabel.text = chord.chord
                chord.is_selected ? (overlayView.isHidden = false) : (overlayView.isHidden = true)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapItem() {
        onTapItem(data?.chord ?? "")
    }

}
