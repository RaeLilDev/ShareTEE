//
//  ChordManager.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 08/01/2022.
//

import Foundation

protocol ChordManagerDelegate {
    
    func didUpdateChords(_ chordManager: ChordManager, chords: [ChordModel])
    
    func didFailWithError(error: Error)
}

struct ChordManager {
    
    let baseURL = "https://www.sharetee.org/admin/"
    
    var delegate: ChordManagerDelegate?
    
    func fetchChordsByGroupID(with chordID: String){
        let url = "\(baseURL)v2/getChordsByGroup/\(chordID)"
        performRequest(with: url)
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
                        if let chords = self.parseJSON(safeData) {
                            delegate?.didUpdateChords(self, chords: chords)
                        }
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [ChordModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([ChordModel].self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
