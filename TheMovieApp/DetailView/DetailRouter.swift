//
//  DetailRouter.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 30/10/21.
//

import Foundation
import UIKit

class DetailRouter {
    
    var viewController: UIViewController {
        return createViewController()
    }
    private var movieID: String?
    
    init(movieID: String? = "" ) {
        self.movieID = movieID
    }
    

    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
        let view = DetailView(nibName: "DetailView", bundle: Bundle.main)
        view.movieID = self.movieID 
        return view
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error desconhecido")}
        self.sourceView = view
    }
    
}
