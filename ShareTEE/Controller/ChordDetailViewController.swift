//
//  ChordDetailViewController.swift
//  ShareTEE
//  Created by Ye Lynn Htet on 03/01/2022.

import UIKit

class ChordDetailViewController: UIViewController {

    var selectedChordGroup: ChordGroupModel?
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var chordsCollectionView: UICollectionView!
    
    var chordManager = ChordManager()
    var chordList = [ChordModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        chordsCollectionView.dataSource = self
        chordsCollectionView.delegate = self
        chordsCollectionView.register(UINib(nibName: "ChordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChordCollectionViewCell")
        
        chordManager.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToBack))
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(tapGestureRecognizer)
        
        if let chordGroup = selectedChordGroup {
            groupNameLabel.text = chordGroup.family_name
            chordManager.fetchChordsByGroupID(with: chordGroup.id)
        }
        
    }
    
    @objc func goToBack() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}


extension ChordDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChordCollectionViewCell", for: indexPath) as? ChordCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.data = chordList[indexPath.row]
        cell.onTapItem = { chordName in
            self.chordList.forEach{(chordModel) in
                if chordName == chordModel.chord {
                    chordModel.is_selected = true
                } else {
                    chordModel.is_selected = false
                }
            }
            self.chordsCollectionView.reloadData()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthOfString(text: chordList[indexPath.row].chord, font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)), height: CGFloat(45))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func widthOfString(text: String, font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        return CGFloat(textSize.width + 32)
    }
    
}

extension ChordDetailViewController: ChordManagerDelegate {
    
    func didUpdateChords(_ chordManager: ChordManager, chords: [ChordModel]) {
        chordList += chords
        DispatchQueue.main.async {
            self.chordsCollectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
