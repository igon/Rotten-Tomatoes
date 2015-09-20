//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Gonzalez, Ivan on 9/19/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var networkErrorView: UIView!
    
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "loadMovies", forControlEvents: UIControlEvents.ValueChanged)
        loadMovies()
    }

    
    func loadMovies() {
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        
        let request = NSURLRequest(URL: url)
        
        networkErrorView.hidden = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
            if error == nil {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                    print(json)
                    self.movies = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                    self.indicatorView.hidden = true
                } catch {
                    
                }
            } else {
                self.networkErrorView.hidden = false
                self.indicatorView.hidden = true
            }
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            if (self.refreshControl.refreshing == true) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        
        return 0;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let imageUrl = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)
        let request = NSURLRequest(URL: imageUrl!)
        cell.posterView.setImageWithURL(imageUrl!)
     
        cell.posterView.setImageWithURLRequest(request, placeholderImage: UIImage(named: "waiting"), success: { (urlRequest:NSURLRequest , urlResponse: NSHTTPURLResponse, image:UIImage) -> Void in
            
                cell.posterView.image = image
            
            }) { (urlRequest: NSURLRequest, urlResponse: NSHTTPURLResponse, error:NSError) -> Void in
                
        }
        
        
      /*  movieImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: imageUrl)), placeholderImage: UIImage(named: "Waiting"), success: { (urlRequest: NSURLRequest!, httpUrlResponse: NSHTTPURLResponse!, image: UIImage!) -> Void in {
            
            }
        */
        return cell;
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let movie = movies![indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        print(indexPath)
        
    }

}
