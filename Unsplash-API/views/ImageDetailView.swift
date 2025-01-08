//
//  ImageDetailView.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import SwiftUI
import PhotosUI

struct ImageDetailView: View {
    let photo: UnsplashPhoto
    @State private var selectedFormat: ImageFormat = .regular
    @State private var downloadSuccessMessage: String?

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

            Picker("", selection: $selectedFormat) {
                ForEach(ImageFormat.allCases, id: \.self) { format in
                    Text(format.displayName).tag(format)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

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

            Button(action: {
                downloadImage(from: photo.urls.full)
            }, label: {
                Text("\(Image(systemName: "square.and.arrow.up")) Télécharger")
            })
            .padding()
            
            // Message de succès
            if let message = downloadSuccessMessage {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
            }
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


    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL invalide.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur de téléchargement : \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.downloadSuccessMessage = "Erreur lors du téléchargement."
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Impossible de convertir l'image téléchargée.")
                DispatchQueue.main.async {
                    self.downloadSuccessMessage = "Échec lors de la conversion de l'image."
                }
                return
            }
            
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    DispatchQueue.main.async {
                        self.downloadSuccessMessage = "✅ Image téléchargée avec succès !"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.downloadSuccessMessage = "⚠️ Permission refusée pour sauvegarder l'image."
                    }
                }
            }
        }.resume()
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
