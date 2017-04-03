//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Sophia on 3/31/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

import AFNetworking
import MBProgressHUD

let API_KEY = "e74114dd330fceeffc8c709bc0d32fdf"
let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/"
let LARGE_IMAGE_SIZE_PARAM = "original/"
let SMALL_IMAGE_SIZE_PARAM = "w45/"

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var endpoint: String! = "now_playing"
    var backgroundColor: UIColor!
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var tabItemTitle: String! = "Now Playing"
    var searchActive : Bool = false
    var filtered:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        searchBar.delegate = self
        searchActive = false
        
        // Set up table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = backgroundColor
        tableView.addSubview(networkErrorView)
        
        // Set up network error message view
        networkErrorView.isHidden = true
        networkErrorLabel.text = "Network error. Please try refreshing again later."
        networkErrorLabel.textColor = UIColor.white
        
        // Customize navigation controler
        self.navigationItem.title = tabItemTitle
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            navigationBar.backgroundColor = self.backgroundColor
        }
        
        // Set up refresh control
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Make requests
        networkRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh control action method
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        networkRequest()
    }
    
    // MARK: - UITableViewDataSource methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            if(searchActive) {
                return filtered.count
            }
            return movies.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        var movie = movies![indexPath.row];
        if(searchActive && indexPath.row < filtered.count){
            movie = filtered[indexPath.row]
        }
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        self.loadImageIn(postView: cell.postView, posterPath: posterPath)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.titleLabel.textColor = UIColor.white
        cell.overviewLabel.textColor = UIColor.white
        cell.rating.text = "🌟 \(String(describing: movie["vote_average"] as! Double))"
        cell.releaseDate.text = "🎬 \(movie["release_date"] as? String ?? "N/A")"

        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // MARK: - Network request methods
    
    func loadImageIn(postView: UIImageView, posterPath: String) {
        let smallImageUrl = BASE_IMAGE_URL + SMALL_IMAGE_SIZE_PARAM + posterPath
        let largeImageUrl = BASE_IMAGE_URL + LARGE_IMAGE_SIZE_PARAM + posterPath
        
        let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl)! as URL)
        let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl)! as URL)

        postView.setImageWith(smallImageRequest as URLRequest,
                              placeholderImage: nil,
                              success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                                
                                // imageResponse will be nil if the image is cached
                                if smallImageResponse != nil {
                                    print("Image was NOT cached, fade in image")
                                    postView.alpha = 0.0
                                    postView.image = smallImage
                                    UIView.animate(withDuration: 0.4, animations: { () -> Void in
                                        postView.alpha = 1.0
                                    }, completion: { (success) -> Void in
                                        postView.setImageWith(
                                            largeImageRequest as URLRequest,
                                            placeholderImage: smallImage,
                                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                                postView.image = largeImage;
                                        },
                                            failure: nil)
                                    })
                                } else {
                                    print("Image was cached so just update the image")
                                    postView.image = smallImage
                                }
        },
                              failure: { (imageRequest, imageResponse, error) -> Void in
                                // do something for the failure condition
        })
    }
    
    func networkRequest() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(self.endpoint!)?api_key=\(API_KEY)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                        self.networkErrorView.isHidden = true
                    }
                } else {
                    // no response from api, handle with network error
                    self.networkErrorView.isHidden = false
                    self.tableView.bringSubview(toFront: self.networkErrorView)
                }
                self.refreshControl.endRefreshing()
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
        });
        task.resume()
    }
    
    // MARK: - Search bar methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = (movies?.filter({ (movie) -> Bool in
            let tmp: NSString = movie["title"] as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }))!
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        var movie = movies![indexPath!.row];
        if(searchActive && indexPath!.row < filtered.count){
            movie = filtered[indexPath!.row]
        }
        
        let detailViewController = segue.destination as! DetailsViewController
        detailViewController.movie = movie
    }

}
