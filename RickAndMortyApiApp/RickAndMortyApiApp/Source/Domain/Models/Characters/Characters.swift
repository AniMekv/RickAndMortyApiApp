//
//  Characters.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 1/30/24.
//

import Foundation

struct Characters: Decodable {
    var info: Info?
    var results: [Character]?
}
