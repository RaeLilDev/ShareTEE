//
//  ArtistSongViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 27/12/2021.
//

import UIKit

class ArtistSongViewController: UIViewController {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistSongTableView: UITableView!
    
    var selectedArtist: ArtistModel?
    
    var songManager = SongManager()
    
    var songArray = [SongModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        artistSongTableView.dataSource = self
        artistSongTableView.delegate = self
        songManager.delegate = self
        artistSongTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToBack))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecognizer)
        
        if let artist = selectedArtist {
            artistNameLabel.text = artist.artist
            songManager.fetchSongsByArtistID(artistID: artist.artist_id)
        }
    }
    
    @objc func goToBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ArtistSongViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        cell.configure(with: songArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToArtistSongDetail", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SongDetailViewController
        if let indexPath = artistSongTableView.indexPathForSelectedRow {
            destinationVC.selectedSong = songArray[indexPath.row]
        }
    }
}


extension ArtistSongViewController: SongManagerDelegate {
    func didUpdateSong(_ songManager: SongManager, songs: [SongModel]) {
        songArray += songs
        DispatchQueue.main.async {
            self.artistSongTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


