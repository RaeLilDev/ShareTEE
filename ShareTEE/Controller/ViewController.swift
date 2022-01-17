//
//  ViewController.swift
//  ShareTEE
//
//  Created by Ye Lynn Htet on 15/12/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var pageControlSlider: UIPageControl!
    
    let categories: [CategoryModel] = [
        CategoryModel(image: #imageLiteral(resourceName: "song"), name: "Song"),
        CategoryModel(image: #imageLiteral(resourceName: "artist"), name: "Artist"),
        CategoryModel(image: #imageLiteral(resourceName: "album"), name: "Album"),
        CategoryModel(image: #imageLiteral(resourceName: "hot"), name: "Hot"),
        CategoryModel(image: #imageLiteral(resourceName: "learn"), name: "Learn"),
        CategoryModel(image: #imageLiteral(resourceName: "request"), name: "Request")
        ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        sliderCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sliderCollectionView.self {
            return 3
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderCollectionView.self {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as? SliderCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: categories[indexPath.row])
            return cell
        }
    }
    
    //MARK: - Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sliderCollectionView.self {
            return CGSize(width: collectionView.frame.width, height: (collectionView.frame.width)/2)
        } else {
            return CGSize(width: (collectionView.frame.width - 16)/2, height: CGFloat(110))
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView.self {
            switch indexPath.row {
            case 0:
                print("Song is selected")
                self.performSegue(withIdentifier: "GoToSong", sender: self)
                break
            case 1:
                print("Artist is selected")
                self.performSegue(withIdentifier: "GoToArtist", sender: self)
                break
            case 2:
                print("Album is selected")
                self.performSegue(withIdentifier: "GoToAlbum", sender: self)
                break
            case 3:
                print("Hot is selected")
                self.performSegue(withIdentifier: "GoToHot", sender: self)
                break
            case 4:
                print("Learn is selected")
                self.performSegue(withIdentifier: "GoToLearn", sender: self)
                break
            case 5:
                print("Request is selected")
                break
            default:
                print("Error")
                break
            }
        }
    }
    
    
    //MARK: - Slider Methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControlSlider.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControlSlider.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width)
    }
}

