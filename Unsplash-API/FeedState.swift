////
////  FeedState.swift
////  Unsplash-API
////
////  Created by Lucas Goï on 07/01/2025.
////
//
//import SwiftUI
//
//@MainActor
//class FeedState: ObservableObject {
//    @Published var imageList: [UnsplashPhoto] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//
//    private let unsplashAPI = UnsplashAPI()
//
//    // MARK: - Fonction pour charger les photos
//    func loadPhotos(orderBy: String = "popular", perPage: Int = 10) {
//        isLoading = true
//        errorMessage = nil
//
//        Task {
//            do {
//                let photos = try await unsplashAPI.fetchPhotos(orderBy: orderBy, perPage: perPage)
//                self.imageList = photos
//            } catch {
//                self.errorMessage = "Erreur lors du chargement : \(error.localizedDescription)"
//            }
//            self.isLoading = false
//        }
//    }
//}
