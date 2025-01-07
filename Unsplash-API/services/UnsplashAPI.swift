////
////  UnsplashAPI.swift
////  Unsplash-API
////
////  Created by Lucas Goï on 07/01/2025.
////
//
//import Foundation
//
//struct UnsplashAPI {
//    // MARK: - Constantes de l'API
//    private let scheme = "https"
//    private let host = "api.unsplash.com"
//    private let clientId = ConfigurationManager.instance.plistDictionnary.clientId
//
//    // MARK: - URL de base de l'API Unsplash
//    /// Construit l'URL de base avec la clé d'API
//    func unsplashApiBaseUrl() -> URLComponents {
//        var components = URLComponents()
//        components.scheme = scheme
//        components.host = host
//        components.queryItems = [
//            URLQueryItem(name: "client_id", value: clientId)
//        ]
//        return components
//    }
//
//    // MARK: - URL pour récupérer les photos du feed
//    /// Construit l'URL complète pour récupérer les photos
//    /// - Parameters:
//    ///   - orderBy: Tri des images (par défaut "popular")
//    ///   - perPage: Nombre d'images par page (par défaut 10)
//    func feedUrl(orderBy: String = "popular", perPage: Int = 10) -> URL? {
//        var components = unsplashApiBaseUrl()
//        components.path = "/photos"
//        components.queryItems?.append(URLQueryItem(name: "order_by", value: orderBy))
//        components.queryItems?.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
//
//        return components.url
//    }
//
//    // MARK: - Requête générique
//    /// Effectue une requête réseau et renvoie les données
//    func fetchPhotos(orderBy: String = "popular", perPage: Int = 10) async throws -> [UnsplashPhoto] {
//        guard let url = feedUrl(orderBy: orderBy, perPage: perPage) else {
//            throw URLError(.badURL)
//        }
//
//        let (data, response) = try await URLSession.shared.data(from: url)
//
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//
//        let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
//        return photos
//    }
//}
