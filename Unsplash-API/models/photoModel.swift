//
//  photo.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import Foundation

struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let slug: String
    let user: User
    let urls: UnsplashPhotoUrls
}

struct User: Codable {
    let name: String
}

struct UnsplashPhotoUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
