//
//  ContentView.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 30.04.22.
//

import MapKit
import LocalAuthentication
import SwiftUI

struct PointOfInterest: Identifiable {
  let id = UUID()
  let name: String
  let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
  @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
  @State private var detailViewIsShown: Bool = false
  @State private var locationToShow: PointOfInterest?
  @State private var isUnlocked: Bool = false

  let locations: [PointOfInterest] = [
    PointOfInterest(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
    PointOfInterest(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
  ]

  var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        if isUnlocked {
          Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coordinate, anchorPoint: .zero) {
              Circle()
                .stroke(.red, lineWidth: 2)
                .frame(width: 44, height: 44)
                .onTapGesture {
                  withAnimation {
                    locationToShow = location
                    detailViewIsShown.toggle()
                  }
                }
            }
          }
        }

        if locationToShow != nil {
          DetailOverlay(location: locationToShow!)
            .offset(x: 0, y: detailViewIsShown ? 0 : 400)
        }
      }
      .onAppear(perform: authenticate)
      .ignoresSafeArea()
      .navigationTitle("London Explorer")
    }
      // Overlay button to change mapViewStyle
  }

  func authenticate() {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      let reaon = "We need to unlock your data."

      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reaon) { success, authenticationError in
        if success {
          isUnlocked = true
        } else {
          // ERROR HERE
        }
      }
    } else {
      // If no authentication is possible (old iPhone, iPod, etc.)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct DetailOverlay: View {
  let location: PointOfInterest

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .fill(.ultraThinMaterial)

      Text(location.name)
    }
    .shadow(color: .black, radius: 5, x: 5, y: 5)
    .frame(height: 300)
    .frame(maxWidth: .infinity)
    .padding()
  }
}
