//
//  SongManager.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 16/12/2021.
//

import Foundation

protocol SongManagerDelegate {
    
    func didUpdateSong(_ songManager: SongManager, songs: [SongModel])
    
    func didFailWithError(error: Error)
    
}

struct SongManager {
    
    let baseURL = "https://sharetee.org/admin/"
    
    var delegate: SongManagerDelegate?
    
    
    func fetchSongs(pageName: Int) {
        let urlString = "\(baseURL)getSongsByPage/\(pageName)"
        performRequest(with: urlString)
    }
    
    func fetchSongsByName(pageName: Int, songName: String) {
        print("Called Me")
        let urlString = "\(baseURL)getSongsByPageSearch/\(pageName)/\(songName)"
        performRequest(with: urlString)
    }
    
    func fetchSongsByArtistID(artistID: String){
        let urlString = "\(baseURL)v2/getSongsByArtist/\(artistID)"
        performRequest(with: urlString)
    }
    
    func fetchSongsByAlbumID(albumID: String) {
        let urlString = "\(baseURL)v2/getSongsByAlbum/\(albumID)"
        performRequest(with: urlString)
    }
    
    func fetchHotSongs() {
        let urlString = "\(baseURL)v2/getPopularSongs"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let urlModified = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlModified) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, resopnse, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                } else {
                    if let safeData = data {
                        if let song = self.parseJSON(safeData) {
                            delegate?.didUpdateSong(self, songs: song)
                        }
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func parseJSON(_ songData: Data) -> [SongModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([SongModel].self, from: songData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
