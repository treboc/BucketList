//
//  ContentView.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 30.04.22.
//

import MapKit
import LocalAuthentication
import SwiftUI

struct ContentView: View {
  @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
  @State private var locations = [Location]()

  @State private var selectedPlace: Location?

  var body: some View {
    ZStack {
      Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
        MapAnnotation(coordinate: location.coordinate) {
          VStack {
            Image(systemName: "star.circle")
              .resizable()
              .foregroundColor(.red)
              .frame(width: 44, height: 44)
              .background(.white)
              .clipShape(Circle())

            Text(location.name)
              .fixedSize()
          }
          .onTapGesture {
            selectedPlace = location
          }
        }
      }
      .ignoresSafeArea()

      Circle()
        .fill(.blue)
        .opacity(0.3)
        .frame(width: 32, height: 32)
        .allowsHitTesting(false)

      addButton
    }
    .sheet(item: $selectedPlace) { place in
      EditView(location: place) { newLocation in
        if let index = locations.firstIndex(of: place) {
          locations[index] = newLocation
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

extension ContentView {
  private var addButton: some View {
    VStack {
      Spacer()

      HStack {
        Spacer()

        Button {
          let newLocation = Location(name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
          locations.append(newLocation)
          print(locations)
        } label: {
          Image(systemName: "plus")
            .padding()
            .background(.black.opacity(0.75))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Circle())
            .padding(.trailing)
        }
      }
    }
  }
}
