//
//  SongViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 16/12/2021.
//

import UIKit

class SongViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var songManager = SongManager()
    
    var page = 0
    var isLastPage = false
    var isLoadingList = false
    var isSearch = false
    var songName = ""
    
    var songArray: [SongModel]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        songTableView.dataSource = self
        songTableView.delegate = self
        songManager.delegate = self
        searchBar.delegate = self
        songTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
        songManager.fetchSongs(pageName: page)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}


extension SongViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - TableView DataSourceMethods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let songs = songArray {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as? SongTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: songs[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToSongDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SongDetailViewController
        if let indexPath = songTableView.indexPathForSelectedRow {
            destinationVC.selectedSong = songArray?[indexPath.row]
        }
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let songs = songArray {
            let lastElement = songs.count - 1
            if indexPath.row == lastElement && !isLoadingList && !isLastPage {
                isLoadingList = true
                page += 1
                if !isSearch {
                    songManager.fetchSongs(pageName: page)
                } else {
                    songManager.fetchSongsByName(pageName: page, songName: songName)
                }
                
                songTableView.tableFooterView = createSpinnerFooter()
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
}

//MARK: - Song Manager Delegate Methods

extension SongViewController: SongManagerDelegate {
    
    func didUpdateSong(_ songManager: SongManager, songs: [SongModel]) {

        if songs[0].song == "0" && songs[0].artist == "0" {
            DispatchQueue.main.async {
                self.isLastPage = true
                self.songTableView.tableFooterView = nil
                if self.isSearch {
                    self.songTableView.reloadData()
                }
            }
        } else {
            if songArray != nil {
                songArray! += songs
                
            } else {
                songArray = songs
            }
            print(songArray!.count)
            DispatchQueue.main.async {
                self.isLoadingList = false
                self.songTableView.reloadData()
                self.songTableView.tableFooterView = nil
            }
        }
        
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.isLastPage = true
            self.songTableView.tableFooterView = nil
        }
        print(error)
    }
}

extension SongViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        songName = searchBar.text!
        if songName != ""{
            page = 0
            songArray?.removeAll()
            isSearch = true
            songManager.fetchSongsByName(pageName: page, songName: songName)
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            page = 0
            songArray?.removeAll()
            songManager.fetchSongs(pageName: page)
            isLastPage = false
            isSearch = false
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}

