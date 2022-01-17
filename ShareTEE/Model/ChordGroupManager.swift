//
//  ChordGroupManager.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 03/01/2022.
//

import Foundation

protocol ChordGroupManagerDelegate {
    
    func didUpdateChordGroups(_ chordGroupManager: ChordGroupManager, chordGroups: [ChordGroupModel])
    
    func didFailWithError(error: Error)
    
}

struct ChordGroupManager {
    
    let baseURL = "https://www.sharetee.org/admin/"
    
    var delegate: ChordGroupManagerDelegate?
    
    func fetchChordGroups() {
        let url = "\(baseURL)v2/getChordFamily"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let modifiedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: modifiedURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    delegate?.didFailWithError(error: error!)
                    return
                } else {
                    if let safeData = data {
                        if let chordGroups = self.parseJSON(safeData) {
                            delegate?.didUpdateChordGroups(self, chordGroups: chordGroups)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [ChordGroupModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([ChordGroupModel].self, from: data)
            print(decodedData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
