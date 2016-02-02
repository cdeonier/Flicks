//
//  Movie.swift
//  Flicks
//
//  Created by Christian Deonier on 2/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation
import AFNetworking

class Movie {
    
    var posterPath: String?
    var title: String?
    var overview: String?
    
    private static let params = ["api_key": "5a4ab6966024cce5191cca13f4452b85"]
    private static let nowPlayingURL = "http://api.themoviedb.org/3/movie/now_playing"
    
    init(jsonResult: NSDictionary) {
        posterPath = jsonResult["poster_path"] as? String
        title = jsonResult["title"] as? String
        overview = jsonResult["overview"] as? String
    }
    
    class func nowPlaying(successCallback: ([Movie]) -> Void, error: ((NSError?) -> Void)?) {
        let manager = AFHTTPRequestOperationManager()
        manager.GET(nowPlayingURL, parameters: params, success: { (operation, responseObject) -> Void in
            if let results = responseObject["results"] as? NSArray {
                var movies: [Movie] = []
                for result in results as! [NSDictionary] {
                    movies.append(Movie(jsonResult: result))
                }
                successCallback(movies)
            }
            }, failure: { (operation, requestError) -> Void in
                if let errorCallback = error {
                    errorCallback(requestError)
                }
        })
    }
}