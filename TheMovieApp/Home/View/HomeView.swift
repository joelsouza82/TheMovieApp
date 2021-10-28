//
//  HomeView.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 26/10/21.
//

import UIKit
import RxSwift

class HomeView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private var router = HomeRouter()
    private var viewModel = HomeViewModel()
    
    private var disposeBag = DisposeBag()
    private var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuretableView()
        viewModel.bind(view: self, router: router)
        getData()
        
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
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomMovieCell.self)) as! CustomMovieCell
        cell.imageMovie.imageFromServerURL(urlString: "\(Constants.URL.urlImages+self.movies[indexPath.row].image)", placeHolderImage: UIImage(named: "claquete")!)
        cell.titleMovie.text = movies[indexPath.row].title
        cell.descriptionMovie.text = movies[indexPath.row].sinopsis
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
