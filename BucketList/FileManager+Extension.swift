//
//  FileManager+Extension.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 30.04.22.
//

import Foundation

extension FileManager {
  static var DocumentsDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }

  func save(to file: String, content: String) {
    let url = FileManager.DocumentsDirectory.appendingPathComponent(file)

    do {
      try content.write(to: url, atomically: true, encoding: .utf8)
    } catch {
      print(error.localizedDescription)
    }
  }

  func load(from file: String) -> String? {
    let url = FileManager.DocumentsDirectory.appendingPathComponent(file)

    do {
      return try String(contentsOf: url)
    } catch {
      print(error.localizedDescription)
    }

    return nil
  }
}

extension Bundle {
  func decode<T: Codable>(_ file: String) -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      fatalError("Failed to locate \(file) in bundle.")
    }

    guard let data = try? Data(contentsOf: url) else {
      fatalError("Failed to load \(file) from bundle.")
    }

    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    formatter.dateFormat = "y-MM-dd"
    decoder.dateDecodingStrategy = .formatted(formatter)

    guard let loaded = try? decoder.decode(T.self, from: data) else {
      fatalError("Failed to decode \(file) from bundle.")
    }

    return loaded
  }
}
