//
//  ManagerConnections.swift
//  TheMovieApp
//
//  Created by Joel de Almeida Souza on 26/10/21.
//

import Foundation
import RxSwift


class ManagerConnections {
    
    func getPopularMovies() -> Observable<[Movie]> {
        
        return Observable.create { observer in
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: Constants.URL.main + Constants.EndPoints.urlListPopularMovies+Constants.apiKey)!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request) { (data, response, error) in
                guard case let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
                
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let movies = try decoder.decode(Movies.self, from: data!)
                
                        observer.onNext(movies.listOfMovies)
                        
                    } catch let error {
                        observer.onError(error)
                        print("Error: \(error.localizedDescription)")
                    }
                }else if response.statusCode == 401 {
                    print("Error 401")
                }
                observer.onCompleted()
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    
    }
    
    func getDetailMovies(movieID: String) -> Observable<MovieDetail> {
        return Observable.create { observer in
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: Constants.URL.main + Constants.EndPoints.urlDetailMovie+movieID+Constants.apiKey)!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
                
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let detailMovie = try decoder.decode(MovieDetail.self, from: data)
                
                        observer.onNext(detailMovie)
                        
                    } catch let error {
                        observer.onError(error)
                        print("Error: \(error.localizedDescription)")
                    }
                }else if response.statusCode == 401 {
                    print("Error 401")
                }
                observer.onCompleted()
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
}
