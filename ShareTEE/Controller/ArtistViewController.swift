//
//  ArtistViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 25/12/2021.
//

import UIKit

class ArtistViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var artistCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var artistArray = [ArtistModel]()
    
    var artistManager = ArtistManager()
    
    var isLoading = false
    var isLastPage = false
    var isSearch = false
    var currentPage = 0
    var artistName = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        artistCollectionView.dataSource = self
        artistCollectionView.delegate = self
        searchBar.delegate = self
        artistCollectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        artistCollectionView.register(UINib(nibName: "IndicatorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IndicatorCollectionViewCell")
        
        artistManager.delegate = self
        
        artistManager.fetchArtists(pageName: currentPage)

        let tapGestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(backPressed))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecogizer)
    }
    
    @objc func backPressed(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension ArtistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == artistArray.count-1 && isLoading && !isLastPage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndicatorCollectionViewCell", for: indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as? ArtistCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: artistArray[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width-56)/2, height: CGFloat(110))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = artistArray.count - 1
        if indexPath.row == lastElement && isLoading && !isLastPage{
            isLoading = false
            currentPage += 1
            if isSearch {
                artistManager.fetchArtistsByName(pageName: currentPage, artistName: artistName)
            } else {
                print(currentPage)
                artistManager.fetchArtists(pageName: currentPage)
            }
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToArtistSong", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ArtistSongViewController
        if let indexPath = artistCollectionView.indexPathsForSelectedItems {
            destinationVC.selectedArtist = artistArray[indexPath[0].row]
        }
    }
    
}

extension ArtistViewController: ArtistManagerDelegate {
    func didUpdateArtist(_ artistManager: ArtistManager, artists: [ArtistModel]) {
        
        if artists[0].artist == "0" {
            self.isLastPage = true
            DispatchQueue.main.async {
                self.artistCollectionView.reloadData()
            }
        } else {
            artistArray += artists
            DispatchQueue.main.async {
                self.isLoading = true
                self.artistCollectionView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.isLastPage = true
            self.artistCollectionView.reloadData()
        }
    }
}

extension ArtistViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        artistName = searchBar.text!
        if artistName != "" {
            currentPage = 0
            artistArray.removeAll()
            isSearch = true
            artistManager.fetchArtistsByName(pageName: currentPage, artistName: artistName)
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            currentPage = 0
            artistArray.removeAll()
            isLoading = true
            isLastPage = false
            isSearch = false
            artistManager.fetchArtists(pageName: currentPage)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}
