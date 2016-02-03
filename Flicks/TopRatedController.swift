import UIKit

class TopRatedController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var topRatedTableView: UITableView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topRatedTableView.dataSource = self
        topRatedTableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        Movie.topRated({ (movies: [Movie]) -> Void in
            self.movies = movies
            self.topRatedTableView.reloadData()
            })
            { (error: NSError?) -> Void in
                //Error
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopRatedCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        cell.title.text = movie.title
        cell.overview.text = movie.overview
        cell.posterImage.setImageWithURL(movie.posterUrl())

        return cell
    }
}

