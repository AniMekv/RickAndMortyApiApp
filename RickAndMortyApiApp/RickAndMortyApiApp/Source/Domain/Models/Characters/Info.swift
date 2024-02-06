//
//  Info.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 1/30/24.
//

import Foundation

struct Info: Decodable {
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
}
