//
//  HomeViewModel.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 26/10/21.
//

import Foundation
import RxSwift

class HomeViewModel {
    private weak var view: HomeView?
    private var router: HomeRouter?
    private var managerConnections = ManagerConnections()
    
    func bind(view: HomeView, router: HomeRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getListMoviesData() -> Observable<[Movie]> {
        return managerConnections.getPopularMovies()
    }
    
    func makeDetailView(movieID: String) {
        router?.navigateToDetailView(movieID: movieID)
    }
}
