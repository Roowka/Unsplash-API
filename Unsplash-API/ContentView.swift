//
//  ContentView.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State var imageList: [UnsplashPhoto] = []

        // Déclaration d'une fonction asynchrone
        func loadData() async {
            // Créez une URL avec la clé d'API
            let url = URL(string: "https://api.unsplash.com/photos?client_id=\(ConfigurationManager.instance.plistDictionnary.clientId)")!

            do {
                // Créez une requête avec cette URL
                let request = URLRequest(url: url)

                // Faites l'appel réseau
                let (data, _) = try await URLSession.shared.data(for: request)

                // Transformez les données en JSON
                let deserializedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)

                // Mettez à jour l'état de la vue
                imageList = deserializedData

            } catch {
                print("Error: \(error)")
            }
        }
    
    var body: some View {
        VStack {
            // le bouton va lancer l'appel réseau
            Button(action: {
                Task {
                    await loadData()
                }
            }, label: {
                Text("Load Data")
            })
            //-----------------------------------------
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible(minimum: 150), spacing: 8),
                              GridItem(.flexible(minimum: 150), spacing: 8)],
                    spacing: 8
                ) {
                    ForEach(imageList, id: \.id) {image  in
                        AsyncImage(url: URL(string: image.urls.full)) { phase in
                            switch phase {
                            case .empty:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 150)
                                    .cornerRadius(12)
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(height: 150)
                                    .clipped()
                                    .cornerRadius(12)
                            case .failure:
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .frame(height: 150)
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .padding()
            }
            //-----------------------------------------
        }
    }
}

#Preview {
    ContentView()
}
