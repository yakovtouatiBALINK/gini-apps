//
//  PersonModel.swift
//  giniApps
//
//  Created by yacov touati on 23/10/2023.
//

import Foundation

struct PeopleResponse: Decodable {
    let next: String?
    let results: [Person]
}

struct Person: Decodable, Equatable {
    let name: String
    let height: String
    let mass: String
}
