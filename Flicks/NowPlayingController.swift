import UIKit

class NowPlayingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
        
        Movie.nowPlaying({ (movies: [Movie]) -> Void in
            self.movies = movies
            self.nowPlayingTableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("NowPlayingCell", forIndexPath: indexPath)
        let title = movies[indexPath.row].title
        cell.textLabel?.text = title
        return cell
    }
}

