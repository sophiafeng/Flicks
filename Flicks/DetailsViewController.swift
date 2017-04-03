//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Sophia on 3/31/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        if let posterPath = movie["poster_path"] as? String {
            posterImageView.setImageWith(NSURL(string: BASE_IMAGE_URL + LARGE_IMAGE_SIZE_PARAM + posterPath)! as URL)
        }
        
        print(movie)
        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String
        overviewLabel.sizeToFit()
        print(movie["vote_average"] as? Int as Any)
        rating.text = "🌟 \(String(describing: movie["vote_average"] as! Double))"
        releaseDate.text = "🎬 \(movie["release_date"] as? String ?? "N/A")"
        
        // Animate title/overview section
        UIView.animate(withDuration: 0.7, animations: { () -> Void in
            let point = CGPoint(x: self.infoView.frame.origin.x, y: self.infoView.frame.origin.y - 110)
            self.infoView.frame = CGRect(origin: point, size: self.infoView.frame.size)
        }, completion: { (BOOL) -> Void in
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                let point = CGPoint(x: self.infoView.frame.origin.x, y: self.infoView.frame.origin.y + 20)
                self.infoView.frame = CGRect(origin: point, size: self.infoView.frame.size)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
