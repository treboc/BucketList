//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 03.05.22.
//

import Foundation

extension FileManager {
  static var documentsDirectory: URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
