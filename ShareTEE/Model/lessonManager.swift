//
//  lessonManager.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 19/12/2021.
//

import Foundation

protocol LessonManagerDelegate {
    
    func didUpdateLessons(_ lessonManager: LessonManager, lessons: [LessonModel])
    
    func didFailWithError(error: Error)
}

struct LessonManager {
    let baseURL = "https://sharetee.org/admin/lessonsVideo"
    
    
    var delegate: LessonManagerDelegate?
    
    func fetchLessons() {
        if let url = URL(string: baseURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                } else {
                    if let safeData = data {
                        if let lessons = self.parseJSON(safeData) {
                            self.delegate?.didUpdateLessons(self, lessons: lessons)
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ lessonData: Data) -> [LessonModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([LessonModel].self, from: lessonData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
