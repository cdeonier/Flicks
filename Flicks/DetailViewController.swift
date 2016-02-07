//
//  DetailViewController.swift
//  Flicks
//
//  Created by Christian Deonier on 2/2/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = movie.title
        overview.text = movie.overview
        
        loadLowResImage()
    }
    
    func loadLowResImage() {
        let lowResUrlRequest = NSURLRequest(URL: movie.lowResUrl())
        posterView.setImageWithURLRequest(lowResUrlRequest, placeholderImage: nil,
            success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                self.posterView.image = image
                
                let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.loadHighResImage()
                })
            },
            failure: { (request:NSURLRequest,response:NSHTTPURLResponse?, error:NSError) -> Void in
                
            }
        )
    }
    
    func loadHighResImage() {
        let highResUrlRequest = NSURLRequest(URL: movie.posterUrl())
        posterView.setImageWithURLRequest(highResUrlRequest, placeholderImage: self.posterView.image,
            success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                UIView.transitionWithView(self.posterView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.posterView.image = image
                }, completion: nil)
            },
            failure: { (request:NSURLRequest,response:NSHTTPURLResponse?, error:NSError) -> Void in
                
            }
        )
    }
}
