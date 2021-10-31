//
//  Constants.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 26/10/21.
//

import Foundation

struct Constants {
    static let apiKey = "?api_key=79a738efa73fac0938a93408cf3c5895"
    
    struct URL {
        static let main = "https://api.themoviedb.org/"
        static let urlImages = "https://image.tmdb.org/t/p/w200"
    }
    
    struct EndPoints {
        static let urlListPopularMovies = "3/movie/popular"
        static let urlDetailMovie = "3/movie/"
    }
}
