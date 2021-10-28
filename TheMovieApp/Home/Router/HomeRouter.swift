//
//  HomeRouter.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 26/10/21.
//

import Foundation
import UIKit

class HomeRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
        let view = HomeView(nibName: "HomeView", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error desconhecido")}
        self.sourceView = view
    }
}
