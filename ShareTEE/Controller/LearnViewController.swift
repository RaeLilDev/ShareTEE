//
//  LearnViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 18/12/2021.
//

import UIKit

class LearnViewController: UIViewController {

    @IBOutlet weak var lessonView: UIView!
    @IBOutlet weak var chordView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            lessonView.alpha = 1
            chordView.alpha = 0
        } else {
            lessonView.alpha = 0
            chordView.alpha = 1
        }
    }
    

}
