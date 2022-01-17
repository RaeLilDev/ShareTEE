//
//  AlbumManager.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 27/12/2021.
//

import Foundation

protocol AlbumManagerDelegate {
    
    func didUpdateAlbums(_ albumManager: AlbumManager, albums: [AlbumModel])
    
    func didFailWithError(error: Error)
}

struct AlbumManager {
    
    let baseURL = "https://www.sharetee.org/admin/"
    
    
    var delegate: AlbumManagerDelegate?
    
    func fetchAlbums(pageName: Int) {
        let url = "\(baseURL)getAlbumsByPage/\(pageName)"
        performRequest(with: url)
    }
    
    func fetchAlbumsByName(pageName: Int, albumName: String) {
        let url = "\(baseURL)getAlbumsByPageSearch/\(pageName)/\(albumName)"
        performRequest(with: url)
    }
    
    
    func performRequest(with urlString: String) {
        if let urlModified = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlModified) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    delegate?.didFailWithError(error: error!)
                    
                } else {
                    if let safeData = data {
                        if let albums = self.parseJSON(safeData) {
                            delegate?.didUpdateAlbums(self, albums: albums)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [AlbumModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([AlbumModel].self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
