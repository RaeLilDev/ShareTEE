//
//  NotificationViewController.swift
//  ShareTEE
//
//  Created by MacBook Pro on 26/01/2022.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }

}
