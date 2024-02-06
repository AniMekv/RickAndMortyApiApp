//
//  Episode.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 30/1/24.
//

import Foundation

struct Episode: Decodable {
    var id: Int?
    var name: String?
    var air_date: String?
    var episode: String?
    var characters: [String?]
    var url: String?
    var created: String?
}

