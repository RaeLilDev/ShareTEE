//
//  ArtistManager.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 25/12/2021.
//

import Foundation

protocol ArtistManagerDelegate {
    
    func didUpdateArtist(_ artistManager: ArtistManager, artists: [ArtistModel])
    
    func didFailWithError(error: Error)
}

struct ArtistManager {
    
    let baseURL = "https://sharetee.org/admin/"
    
    var delegate: ArtistManagerDelegate?
    
    func fetchArtistsByName(pageName: Int, artistName: String) {
        let urlString = "\(baseURL)/getArtistsByPageSearch/\(pageName)/\(artistName)"
        performRequest(with: urlString)
    }
    
    func fetchArtists(pageName: Int) {
        let urlString = "\(baseURL)/getArtistsByPage/\(pageName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let urlModified = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlModified) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                } else {
                    if let safeData = data {
                        if let artists = self.parseJSON(safeData) {
                            delegate?.didUpdateArtist(self, artists: artists)
                        }
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ artistData: Data) -> [ArtistModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([ArtistModel].self, from: artistData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
