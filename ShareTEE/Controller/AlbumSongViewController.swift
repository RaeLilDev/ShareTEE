//
//  AlbumSongViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 28/12/2021.
//

import UIKit

class AlbumSongViewController: UIViewController {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var albumSongTableView: UITableView!
    
    var selectedAlbum: AlbumModel?
    
    var songArray = [SongModel]()
    
    var songManager = SongManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        albumSongTableView.dataSource = self
        albumSongTableView.delegate = self
        songManager.delegate = self
        albumSongTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
        
        let tapGestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(goToBack))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecogizer)
        
        if let album = selectedAlbum {
            albumNameLabel.text = album.album
            songManager.fetchSongsByAlbumID(albumID: album.album_id)
        }
    }
    
    @objc func goToBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AlbumSongViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        cell.configure(with: songArray[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToAlbumSongDetail", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SongDetailViewController
        if let indexPath = albumSongTableView.indexPathForSelectedRow {
            destinationVC.selectedSong = songArray[indexPath.row]
        }
    }
    
}

extension AlbumSongViewController: SongManagerDelegate {
    func didUpdateSong(_ songManager: SongManager, songs: [SongModel]) {
        songArray += songs
        DispatchQueue.main.async {
            self.albumSongTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
