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
  @StateObject private var viewModel = ViewModel()

  var body: some View {
    if viewModel.isUnlocked {
      ZStack {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
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
              viewModel.selectedPlace = location
            }
          }
        }
        .ignoresSafeArea()

        Circle()
          .fill(.blue)
          .opacity(0.3)
          .frame(width: 32, height: 32)
          .allowsHitTesting(false)
      }
      .overlay(addButton, alignment: .bottomTrailing)
      .alert("Unlock failed", isPresented: $viewModel.failedUnlockAlertIsShown, actions: {
        Button("Cancel", role: .cancel) { }
        Button("Try again") { viewModel.authenticate() }
      }, message: {
        Text("Authentication failed.")
      })
      .sheet(item: $viewModel.selectedPlace) { place in
        EditView(location: place) { newLocation in
          viewModel.updateLocation(location: newLocation)
        }
      }
    } else {
      Button("Unlock Places") {
        viewModel.authenticate()
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
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
    Button {
      viewModel.addLocation()
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
