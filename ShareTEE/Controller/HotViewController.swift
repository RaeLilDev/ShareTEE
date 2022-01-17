//
//  HotViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 03/01/2022.
//

import UIKit

class HotViewController: UIViewController {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var hotTableView: UITableView!
    
    var songArray = [SongModel]()
    var songManager = SongManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hotTableView.dataSource = self
        hotTableView.delegate = self
        hotTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
        songManager.delegate = self

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapRecognizer)
        
        songManager.fetchHotSongs()
        
    }
    
    @objc func goToBack() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension HotViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: songArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToHotSongDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SongDetailViewController
        if let indexPath = hotTableView.indexPathForSelectedRow {
            destinationVC.selectedSong = songArray[indexPath.row]
        }
    }
    
}

extension HotViewController: SongManagerDelegate {
    func didUpdateSong(_ songManager: SongManager, songs: [SongModel]) {
        songArray += songs
        DispatchQueue.main.async {
            self.hotTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


