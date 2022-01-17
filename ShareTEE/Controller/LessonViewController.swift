//
//  LessonViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 19/12/2021.
//

import UIKit
import AVKit
import AVFoundation

class LessonViewController: UIViewController {

    @IBOutlet weak var lessonTableView: UITableView!
    var lessonManager = LessonManager()
    var lessonArray: [LessonModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lessonTableView.dataSource = self
        lessonTableView.delegate = self
        lessonTableView.register(UINib(nibName: "LessonTableViewCell", bundle: nil), forCellReuseIdentifier: "LessonTableViewCell")
        
        lessonManager.delegate = self
        lessonManager.fetchLessons()
        

        // Do any additional setup after loading the view.
    }
}

extension LessonViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let lessons = lessonArray {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LessonTableViewCell", for: indexPath) as! LessonTableViewCell
            cell.configure(with: lessons[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lessons = lessonArray{
            let url = "https://www.sharetee.org/admin/chord_video/\(lessons[indexPath.row].video_name)"
            print(url)
            let player = AVPlayer(url: URL(string: url)!)

                    let vc = AVPlayerViewController()
                    vc.player = player

                    self.present(vc, animated: true) { vc.player?.play() }
        }
    }
    
}

extension LessonViewController: LessonManagerDelegate {
    
    func didUpdateLessons(_ lessonManager: LessonManager, lessons: [LessonModel]) {
        if lessonArray != nil {
            lessonArray! += lessons
        } else {
            lessonArray = lessons
        }
        DispatchQueue.main.async {
            self.lessonTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


