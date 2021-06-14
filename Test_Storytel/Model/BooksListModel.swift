//
//  BooksList.swift
//  Test_Storytel
//
//  Created by Zain Ul Abideen on 12/06/2021.
//

import Foundation

struct BooksList: Codable {
    var query: String
    let filter: String
    var nextPageToken: String?
    let totalCount: Int
    var items: [Item]
}
