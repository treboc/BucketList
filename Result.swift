//
//  Result.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 03.05.22.
//

import Foundation
import UIKit

struct Result: Codable {
  let query: Query
}

struct Query: Codable {
  let pages: [Int: Page]
}

struct Page: Codable, Comparable {
  let pageid: Int
  let title: String
  let terms: [String: [String]]?

  var description: String {
    terms?["description"]?.first ?? "No further information"
  }

  static func < (lhs: Page, rhs: Page) -> Bool {
    return lhs.title < rhs.title
  }
}
