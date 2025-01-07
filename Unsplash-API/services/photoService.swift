//
//  photoService.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import Foundation

class PhotoService: ObservableObject {
    @Published var photos: [Photo] = []
    private let accessKey = "-DUABiHEkdVIFThXnfjqDgq_eEIa9AXe3CNrxln9cgM" // Remplace par ta clé API
    
    func fetchPhotos() {
        guard let url = URL(string: "https://api.unsplash.com/photos/random?count=20&client_id=\(accessKey)") else {
            print("URL invalide")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedPhotos = try JSONDecoder().decode([Photo].self, from: data)
                    DispatchQueue.main.async {
                        self.photos = decodedPhotos
                    }
                } catch {
                    print("Erreur de décodage : \(error.localizedDescription)")
                }
            } else {
                print("Erreur réseau : \(error?.localizedDescription ?? "Inconnue")")
            }
        }.resume()
    }
}
