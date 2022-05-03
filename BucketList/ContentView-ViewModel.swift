//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 03.05.22.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
  class ViewModel: ObservableObject {
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @Published private(set) var locations: [Location]
    @Published var selectedPlace: Location?
    @Published var isUnlocked = false
    @Published var failedUnlockAlertIsShown = false

    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")

    init() {
      do {
        let data = try Data(contentsOf: savePath)
        locations = try JSONDecoder().decode([Location].self, from: data)
      } catch {
        locations = []
      }
    }

    func save() {
      do {
        let data = try JSONEncoder().encode(locations)
        try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
      } catch {
        print("Unable to save data.")
      }
    }

    func addLocation() {
      let newLocation = Location(
        name: "New Location",
        description: "",
        latitude: mapRegion.center.latitude,
        longitude: mapRegion.center.longitude)
      locations.append(newLocation)
      save()
    }

    func updateLocation(location: Location) {
      guard let selectedPlace = selectedPlace else { return }

      if let index = locations.firstIndex(of: selectedPlace) {
        locations[index] = location
        save()
      }
    }

    func authenticate() {
      let context = LAContext()
      var error: NSError?

      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Please authenticate yourself to show your places."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
          Task { @MainActor in
            if success {
              self.isUnlocked = true
            } else {
              self.failedUnlockAlertIsShown = true
            }
          }
        }
      } else {
        // no biometrics
      }
    }
  }
}
