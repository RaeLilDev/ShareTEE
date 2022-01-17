//
//  SongDetailViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 16/12/2021.
//

import UIKit

class SongDetailViewController: UIViewController {
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var chordImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    var selectedSong: SongModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        songNameLabel.text = selectedSong?.song
        artistNameLabel.text = selectedSong?.artist
        setImage(from: "https://sharetee.org/admin/song_file/\(selectedSong!.song_chord)")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecognizer)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func tapImage() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setImage(from url: String) {
        
        guard let imageURL = URL(string: url) else { return }
       
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            let ratio = image!.size.width / image!.size.height
            DispatchQueue.main.async {
                let newHeight = self.chordImageView.frame.width / ratio
                self.constraintHeight.constant = newHeight
                self.chordImageView.image = image
            }
        }
    }
    


}
