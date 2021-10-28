//
//  HomeView.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 26/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private var router = HomeRouter()
    private var viewModel = HomeViewModel()
    
    private var disposeBag = DisposeBag()
    private var movies = [Movie]()
    private var filteredMovies = [Movie]()
    
    lazy var searchController: UISearchController = ({
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.barStyle = .black
        controller.searchBar.backgroundColor = .clear
        controller.searchBar.placeholder = "Buscar filme"
        
        return controller
    })()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "The Movie App"
        configuretableView()
        viewModel.bind(view: self, router: router)
        getData()
        manageSearchBarController()
    }
    
    func configuretableView()  {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CustomMovieCell", bundle: nil), forCellReuseIdentifier: "CustomMovieCell")
    }
    
    func getData() {
        return viewModel.getListMoviesData().subscribeOn(MainScheduler.instance).observeOn(MainScheduler.instance).subscribe(
           onNext: { movies in
            self.movies = movies
            self.reloadTableView()
        }, onError: { error in
            print(error.localizedDescription)
        }, onCompleted: {
        }).disposed(by: disposeBag)

    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    private func manageSearchBarController() {
        let searchBar = searchController.searchBar
        searchController.delegate = self
        tableView.tableHeaderView = searchBar
        tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
        
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { (result) in
                self.filteredMovies = self.movies.filter({ movie in
                    self.reloadTableView()
                    return movie.title.contains(result)
                })
                
            }).disposed(by: disposeBag)

    }
}
extension HomeView: UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        reloadTableView()
    }
}
extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredMovies.count
        }else {
            return self.movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomMovieCell.self)) as! CustomMovieCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.imageMovie.imageFromServerURL(urlString: "\(Constants.URL.urlImages+self.filteredMovies[indexPath.row].image)", placeHolderImage: UIImage(named: "claquete")!)
            cell.titleMovie.text = filteredMovies[indexPath.row].title
            cell.descriptionMovie.text = filteredMovies[indexPath.row].sinopsis
        } else {
            cell.imageMovie.imageFromServerURL(urlString: "\(Constants.URL.urlImages+self.movies[indexPath.row].image)", placeHolderImage: UIImage(named: "claquete")!)
            cell.titleMovie.text = movies[indexPath.row].title
            cell.descriptionMovie.text = movies[indexPath.row].sinopsis
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
