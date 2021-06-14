//
//  ItemModel.swift
//  Test_Storytel
//
//  Created by Zain Ul Abideen on 13/06/2021.
//

import Foundation
struct Item: Codable {
  let id: String
  let title: String
  let authors: [Authors]
  let narrators: [Narrators]
  let cover: Cover
}
