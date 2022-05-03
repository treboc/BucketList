//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 03.05.22.
//

import Foundation

extension EditView {
  class ViewModel: ObservableObject {
    enum LoadingState {
      case loading, loaded, failed
    }

    var location: Location

    @Published var name: String
    @Published var description: String

    @Published var loadingState: LoadingState = .loading
    @Published var pages: [Page] = []

    init(location: Location) {
      self.location = location
      self.name = location.name
      self.description = location.description
    }

    func saveChanges() -> Location {
      var newLocation = location
      newLocation.id = UUID()
      newLocation.name = name
      newLocation.description = description
      return newLocation
    }

    func fetchNearbyLocations() async {
      let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

      guard let url = URL(string: urlString) else {
        print("Bad URL: \(urlString)")
        return
      }

      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let items = try JSONDecoder().decode(Result.self, from: data)
        Task { @MainActor in
          pages = items.query.pages.values.sorted { $0.title < $1.title }
          loadingState = .loaded
        }
      } catch {
        Task { @MainActor in
          loadingState = .failed
        }
      }
    }
  }
}
