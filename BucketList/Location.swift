//
//  Location.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 01.05.22.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
  var id: UUID = UUID()
  var name: String
  var description: String

  let latitude: Double
  let longitude: Double

  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  static let example = Location(name: "Buckingham Palace", description: "Where Queen Elisabeth lives with her dorgis", latitude: 51.501, longitude: -0.141)

  static func ==(lhs: Location, rhs: Location) -> Bool {
    lhs.id == rhs.id
  }
}
