//
//  DetailViewModel.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 30/10/21.
//

import Foundation
import RxSwift

class DetailViewModel {
    
    private var managerConnections = ManagerConnections()
    private(set) weak var view: DetailView?
    private var router: DetailRouter?
    
    func bind(view: DetailView, router: DetailRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getMovieData(movieID: String) -> Observable<MovieDetail> {
        return managerConnections.getDetailMovies(movieID: movieID)
    }
    
}
