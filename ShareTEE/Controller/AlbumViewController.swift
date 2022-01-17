//
//  AlbumViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 27/12/2021.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    var albumArray = [AlbumModel]()
    var albumManager = AlbumManager()
    
    var isLoading = false
    var isLastPage = false
    var isSearch = false
    
    var currentPage = 0
    var albumName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        albumManager.delegate = self
        searchBar.delegate = self
        albumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        albumCollectionView.register(UINib(nibName: "IndicatorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IndicatorCollectionViewCell")
        
        albumManager.fetchAlbums(pageName: currentPage)
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(goToBack))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func goToBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == albumArray.count-1 && isLoading && !isLastPage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndicatorCollectionViewCell", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
            cell.configure(with: albumArray[indexPath.row])
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 56)/2, height: CGFloat(110))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = albumArray.count-1
        if indexPath.row == lastElement && isLoading && !isLastPage {
            isLoading = false
            currentPage += 1
            if isSearch {
                albumManager.fetchAlbumsByName(pageName: currentPage, albumName: albumName)
            } else {
                albumManager.fetchAlbums(pageName: currentPage)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToAlbumSong", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AlbumSongViewController
        if let indexPath = albumCollectionView.indexPathsForSelectedItems {
            destinationVC.selectedAlbum = albumArray[indexPath[0].row]
        }
    }
    
}

extension AlbumViewController: AlbumManagerDelegate {
    
    func didUpdateAlbums(_ albumManager: AlbumManager, albums: [AlbumModel]) {
        if albums[0].album == "0" {
            self.isLastPage = true
        } else {
            albumArray += albums
            
        }
        DispatchQueue.main.async {
            self.isLoading = true
            self.albumCollectionView.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.isLastPage = true
            self.albumCollectionView.reloadData()
        }
    }
}

extension AlbumViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        albumName = searchBar.text!
        if albumName != "" {
            currentPage = 0
            isSearch = true
            isLastPage = false
            albumArray.removeAll()
            albumManager.fetchAlbumsByName(pageName: currentPage, albumName: albumName)
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            currentPage = 0
            isSearch = false
            isLastPage = false
            albumArray.removeAll()
            albumManager.fetchAlbums(pageName: currentPage)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}
