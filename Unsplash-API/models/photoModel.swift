//
//  photo.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import Foundation

struct Photo: Codable, Identifiable {
    let id: String
    let urls: PhotoURLs
}

struct PhotoURLs: Codable {
    let regular: String
}
