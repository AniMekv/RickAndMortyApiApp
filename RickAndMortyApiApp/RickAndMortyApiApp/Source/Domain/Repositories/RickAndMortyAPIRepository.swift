//
//  RickAndMortyAPIRepository.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 1/31/24.
//

import Foundation

protocol RickAndMortyRepository {
    func getEpisode(episode: String, completion: @escaping (Result<Episode, FactorError>) -> ())
    func getCharacter(character: String, completion: @escaping (Result<Character, FactorError>) -> ()) 
    func getCharactersPage(page: Int, completion: @escaping (Result<[Character], FactorError>) -> ())

}


class RickAndMortyAPIRepository: RickAndMortyRepository {

    func getCharactersPage(page: Int, completion: @escaping (Result<[Character], FactorError>) -> ()) {
        guard let url = URL(string: Constants.EndPoints.characters + "?page=\(page)") else {
            return completion(Result.failure(.url))
        }

        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: url) { data, response, error in
            do {
                guard let data = data, let response = try? JSONDecoder().decode(Characters.self, from: data)
                    else { return completion(Result.failure(.data)) }
                guard let response = response.results else { return }
                completion(Result.success(response))
            }
        }.resume()
    }
    
    func getEpisode(episode: String, completion: @escaping (Result<Episode, FactorError>) -> ()) {
        guard let url = URL(string: episode) else {
            return completion(Result.failure(.url))
        }

        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: url) { data, response, error in
            do {
                guard let data = data, let response = try? JSONDecoder().decode(Episode.self, from: data)
                    else { return completion(Result.failure(.data)) }

                completion(Result.success(response))
            }
        }.resume()
    }
    
    func getCharacter(character: String, completion: @escaping (Result<Character, FactorError>) -> ()) {
        guard let url = URL(string: character) else {
            return completion(Result.failure(.url))
        }

        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: url) { data, response, error in
            do {
                guard let data = data, let response = try? JSONDecoder().decode(Character.self, from: data)
                    else { return completion(Result.failure(.data)) }

                completion(Result.success(response))
            }
        }.resume()
    }
}
