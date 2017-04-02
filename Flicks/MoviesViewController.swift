//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Sophia on 3/31/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking

let API_KEY = "e74114dd330fceeffc8c709bc0d32fdf"
let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w500/"

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var endpoint: String! = "now_playing"
    var backgroundColor: UIColor!
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = backgroundColor
        tableView.addSubview(networkErrorView)
        
        networkErrorView.isHidden = true
        networkErrorLabel.text = "Network error. Please try refreshing again later."
        networkErrorLabel.textColor = UIColor.white
        
        // Initialize a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        networkRequest()
    }
    
    func networkRequest() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(self.endpoint!)?api_key=\(API_KEY)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
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
        });
        task.resume()
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
            return movies.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = self.movies![indexPath.row];
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let imageUrl = NSURL(string: BASE_IMAGE_URL + posterPath)
        
        cell.postView.setImageWith(imageUrl! as URL)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.titleLabel.textColor = UIColor.white
        cell.overviewLabel.textColor = UIColor.white
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = self.movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailsViewController
        detailViewController.movie = movie
    }

}
