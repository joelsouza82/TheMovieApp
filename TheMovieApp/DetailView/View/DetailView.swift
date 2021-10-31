//
//  DetailView.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 28/10/21.
//

import UIKit
import RxSwift

class DetailView: UIViewController {

    @IBOutlet private weak var titleHeader: UILabel!
    @IBOutlet private weak var imageFilm: UIImageView!
    @IBOutlet private weak var descriptionMovie: UILabel!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var originalTitle: UILabel!
    @IBOutlet private weak var voteAverage: UILabel!
    
    var movieID: String?
    
    private var router = DetailRouter()
    private var viewModel = DetailViewModel()
    
    private var disposedbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataAndShowDetailMovie()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
    }
    
    func getDataAndShowDetailMovie() {
        guard let idMovie = movieID else { return  }
        return viewModel.getMovieData(movieID: idMovie).subscribe(
            onNext: { movie in
            self.showMovieData(movie: movie)
        }, onError: { error in
            print("Ocorreu erro: \(error)")
        }, onCompleted: {
        }).disposed(by: disposedbag)

    }

    func showMovieData(movie: MovieDetail) {
        DispatchQueue.main.async {
            self.titleHeader.text = movie.title
            self.imageFilm.imageFromServerURL(urlString: Constants.URL.urlImages+movie.posterPath, placeHolderImage: UIImage(named:"claquete")!)
            self.descriptionMovie.text = movie.overview
            self.releaseDate.text = movie.releaseDate
            self.originalTitle.text = movie.originalTitle
            self.voteAverage.text = String(movie.voteAverage)
        }
    }


}
