//
//  EditView.swift
//  BucketList
//
//  Created by Marvin Lee Kobert on 01.05.22.
//

import SwiftUI

struct EditView: View {
  @Environment(\.dismiss) var dismiss
  var onSave: (Location) -> Void

  @StateObject var viewModel: ViewModel

  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Place name", text: $viewModel.name)
          TextField("Place description", text: $viewModel.description)
        }

        Section("Nearby…") {
          switch viewModel.loadingState {
          case .loading:
            ProgressView("Loading…")
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(.vertical)
          case .loaded:
            ForEach(viewModel.pages, id: \.pageid) { page in
              Text(page.title)
                .font(.headline)
              + Text(":\n")
              + Text(page.description)
                .italic()
            }
          case .failed:
            Text("Try again later, it seems you have no connection to the internet.")
          }
        }
      }
      .navigationTitle("Place details")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Button("Save") {
          let newLocation = viewModel.saveChanges()
          onSave(newLocation)
          dismiss()
        }
      }
      .task {
        await viewModel.fetchNearbyLocations()
      }
    }
  }

  init(location: Location, onSave: @escaping (Location) -> Void) {
    _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    self.onSave = onSave
  }


}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView(location: Location.example) { _ in }
  }
}
