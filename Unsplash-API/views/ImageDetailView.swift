//
//  ImageDetailView.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import SwiftUI

struct ImageDetailView: View {
    let photo: UnsplashPhoto
    @State private var selectedFormat: ImageFormat = .regular

    enum ImageFormat: String, CaseIterable {
        case regular = "Regular"
        case full = "Full"
        case small = "Small"

        var displayName: String {
            self.rawValue
        }
    }

    var body: some View {
        VStack {
            Text("Une image de @\(photo.user.name)")
                .font(.headline)
                .padding()

            // Picker pour les formats
            Picker("", selection: $selectedFormat) {
                ForEach(ImageFormat.allCases, id: \.self) { format in
                    Text(format.displayName).tag(format)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Image affichée
            AsyncImage(url: URL(string: urlForSelectedFormat())) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }

            // Bouton de téléchargement
            Button(action: downloadImage, label: {
                Text("Télécharger")
            })
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func urlForSelectedFormat() -> String {
        switch selectedFormat {
        case .regular:
            return photo.urls.regular
        case .full:
            return photo.urls.full
        case .small:
            return photo.urls.small
        }
    }


    private func downloadImage() {
//        guard let url = URL(string: urlForSelectedFormat()) else { return }
//
//        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
//            guard let localURL = localURL, error == nil else {
//                print("Erreur lors du téléchargement: \(error?.localizedDescription ?? "Inconnue")")
//                return
//            }
//
//            do {
//                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                let destinationURL = documents.appendingPathComponent(url.lastPathComponent)
//
//                try FileManager.default.moveItem(at: localURL, to: destinationURL)
//
//                print("Image téléchargée à : \(destinationURL)")
//            } catch {
//                print("Erreur lors de l'enregistrement : \(error.localizedDescription)")
//            }
//        }
//        task.resume()
    }
}

struct UnsplashPhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePhoto = UnsplashPhoto(
            id: "sample-id",
            slug: "sample-slug",
            user: User(name: "lucas"),
            urls: UnsplashPhotoUrls(
            raw: "https://images.unsplash.com/photo-1736196074170-1946391dcbbd?ixlib=rb-4.0.3",
            full: "https://images.unsplash.com/photo-1736196074170-1946391dcbbd?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb",
            regular: "https://images.unsplash.com/photo-1736196074170-1946391dcbbd?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
            small: "https://images.unsplash.com/photo-1736196074170-1946391dcbbd?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
            thumb: "https://images.unsplash.com/photo-1736196074170-1946391dcbbd?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max"
            )
        )
        NavigationView {
            ImageDetailView(photo: samplePhoto)
        }
    }
}
