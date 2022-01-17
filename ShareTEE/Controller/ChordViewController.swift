//
//  ChordViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 19/12/2021.
//

import UIKit

class ChordViewController: UIViewController {

    @IBOutlet weak var chordCollectionView: UICollectionView!
    
    var chordGroupArray = [ChordGroupModel]()
    var chordGroupManager = ChordGroupManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordCollectionView.dataSource = self
        chordCollectionView.delegate = self
        chordCollectionView.register(UINib(nibName: "ChordGroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChordGroupCollectionViewCell")
        
        chordGroupManager.delegate = self
        
        chordGroupManager.fetchChordGroups()
    }

}

extension ChordViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return chordGroupArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChordGroupCollectionViewCell", for: indexPath) as! ChordGroupCollectionViewCell
        
        cell.configure(with: chordGroupArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat((collectionView.frame.width-56)/2), height: 56)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToChordDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChordDetailViewController
        if let indexPath = chordCollectionView.indexPathsForSelectedItems {
            destinationVC.selectedChordGroup = chordGroupArray[indexPath[0].row]
        }
    }
}

extension ChordViewController: ChordGroupManagerDelegate {
    func didUpdateChordGroups(_ chordGroupManager: ChordGroupManager, chordGroups: [ChordGroupModel]) {
        
        chordGroupArray += chordGroups
        
        DispatchQueue.main.async {
            
            self.chordCollectionView.reloadData()
            
        }
    }
    
    func didFailWithError(error: Error) {
        
        print(error)
        
    }
    
    
}
