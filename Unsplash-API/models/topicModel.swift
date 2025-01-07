//
//  topicModel.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import Foundation

struct Topic: Codable, Identifiable {
    let id: String
    let title: String
    let cover_photo: UnsplashPhoto
}
