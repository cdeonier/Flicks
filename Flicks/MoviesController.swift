import UIKit
import AFNetworking
import SVProgressHUD

class MoviesController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var nowPlaying: Bool = false
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    var gridViewEnabled: Bool = false;
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        setUpSearchBar()
        setUpRefreshControl()
        setUpNavigationItems()
        
        if (nowPlaying) {
            getNowPlayingMovies()
        } else {
            getTopRatedMovies()
        }
        
        
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpSearchBar() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
    }
    
    func setUpNavigationItems() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 204/255.0, green: 230/255.0, blue: 255/255.0, alpha: 1.0)
        
        navigationItem.title = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "selectSearchItem")
        
        displayViewMode()
    }
    
    func selectSearchItem() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func selectViewingMode() {
        gridViewEnabled = !gridViewEnabled
        displayViewMode()
    }
    
    func displayViewMode() {
        let viewImage = !gridViewEnabled ? UIImage(named: "Grid") : UIImage(named: "List")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: viewImage, style: .Plain, target: self, action: "selectViewingMode")
    }
    
    func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        let action: Selector = nowPlaying ? "getNowPlayingMovies" : "getTopRatedMovies"
        refreshControl!.addTarget(self, action: action, forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)
    }
    
    func getNowPlayingMovies() {
        SVProgressHUD.show()
        Movie.nowPlaying({ (movies: [Movie]) -> Void in
            self.self.handleResponse(movies)
            })
            { (error: NSError?) -> Void in
                SVProgressHUD.showErrorWithStatus("Error getting Now Playing movies")
        }
    }
    
    func getTopRatedMovies() {
        SVProgressHUD.show()
        Movie.topRated({ (movies: [Movie]) -> Void in
            self.self.handleResponse(movies)
            })
            { (error: NSError?) -> Void in
                SVProgressHUD.showErrorWithStatus("Error getting Top Rated movies")
        }
    }
    
    func handleResponse(movies: [Movie]) {
        SVProgressHUD.dismiss()
        self.movies = movies
        self.refreshControl!.endRefreshing()
        
        searchBar(searchBar, textDidChange: searchBar.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        cell.title.text = movie.title
        cell.overview.text = movie.overview
        
        let urlRequest = NSURLRequest(URL: movie.posterUrl())
        cell.posterImage.setImageWithURLRequest(urlRequest, placeholderImage: nil,
            success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                cell.posterImage.alpha = 0
                cell.posterImage.image = image
                [UIView .animateWithDuration(1, animations: { () -> Void in
                    cell.posterImage.alpha = 1
                })]
            },
            failure: { (request:NSURLRequest,response:NSHTTPURLResponse?, error:NSError) -> Void in

            }
        )
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies[indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter({ (movie: Movie) -> Bool in
                if (movie.title?.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil) {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchBar(searchBar, textDidChange: "")
        setUpNavigationItems()
    }
}

