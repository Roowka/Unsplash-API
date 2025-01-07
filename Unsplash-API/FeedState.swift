//
//  FeedState.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import SwiftUI

@MainActor
class FeedState: ObservableObject {
    @Published var topics: [Topic] = []
    @Published var topicFeed: [UnsplashPhoto] = []
    @Published var homeFeed: [UnsplashPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let unsplashAPI = UnsplashAPI()

    // MARK: - Fonction pour charger les photos
    func fetchHomeFeed(orderBy: String = "popular", perPage: Int = 10) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let photos = try await unsplashAPI.fetchPhotos(orderBy: orderBy, perPage: perPage)
                self.homeFeed = photos
            } catch {
                self.errorMessage = "Erreur lors du chargement : \(error.localizedDescription)"
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Fonction pour charger les topics
    func fetchTopics() {
            isLoading = true
            Task {
                do {
                    self.topics = try await unsplashAPI.fetchTopics()
                } catch {
                    errorMessage = "Failed to load topics"
                }
                isLoading = false
            }
        }
    
    // MARK: - Fonction pour charger les images topics
    func fetchPhotosByTopic(topicId: String) {
            isLoading = true
            Task {
                do {
                    self.topicFeed = try await unsplashAPI.fetchPhotosByTopic(topicId: topicId)
                } catch {
                    errorMessage = "Failed to load photos"
                }
                isLoading = false
            }
        }
}
