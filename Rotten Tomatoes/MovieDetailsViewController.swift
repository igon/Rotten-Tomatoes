//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Gonzalez, Ivan on 9/19/15.
//  Copyright © 2015 Gonzalez, Ivan. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title = movie["title"] as? String
        print("title: \(title)")
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        let imageUrl = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)
        let request = NSURLRequest(URL: imageUrl!)
        
        imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (urlRequest:NSURLRequest, urlResponse:NSHTTPURLResponse, image:UIImage) -> Void in
            let transition = CATransition()
            transition.type = kCATransitionFade;
            transition.duration = 1.0;
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.delegate = self
            self.imageView.layer.addAnimation(transition, forKey: nil)
            self.imageView.image = image

            }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
        }
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        var highResUrl = String(movie.valueForKeyPath("posters.thumbnail"))
        
        let range = highResUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            highResUrl = highResUrl.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let imageHighUrl = NSURL(string: highResUrl)
        //self.imageView.setImageWithURL(imageHighUrl!, placeholderImage: self.imageView.image)
        let request = NSURLRequest(URL: imageHighUrl!)
        self.imageView.setImageWithURLRequest(request, placeholderImage: imageView.image, success: { (urlRequest:NSURLRequest, urlResponse:NSHTTPURLResponse, image:UIImage) -> Void in
                self.imageView.image = image
            }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
        }
        
    }

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
