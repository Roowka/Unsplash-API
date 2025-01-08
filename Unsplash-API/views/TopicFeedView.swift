//
//  TopicFeedView.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import SwiftUI

struct TopicFeedView: View {
    let topic: Topic
    @ObservedObject var feedState: FeedState
    private let placeholderCount: Int = 12
    @State private var selectedPhoto: UnsplashPhoto?

    var body: some View {
        VStack {
            Button(action: {
                feedState.fetchPhotosByTopic(topicId: topic.id)
            }, label: {
                Text("Load photos for topic")
            })
            .padding()

            if let errorMessage = feedState.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible(minimum: 150), spacing: 8),
                              GridItem(.flexible(minimum: 150), spacing: 8)],
                    spacing: 8
                ) {
                    if feedState.topicFeed.isEmpty {
                        ForEach(0..<placeholderCount, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(height: 150)
                                .cornerRadius(12)
                        }
                    } else {
                        ForEach(feedState.topicFeed) { image in
                            Button(action: {
                                selectedPhoto = image
                            }) {
                                AsyncImage(url: URL(string: image.urls.small)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 150)
                                            .frame(maxWidth: .infinity)
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
                    }
                }
                .padding()
            }
        }
        .navigationTitle(topic.title)
        .sheet(item: $selectedPhoto) { photo in
            ImageDetailView(photo: photo)
        }
    }
}


#Preview {
    TopicFeedView(topic: Topic(id: "1", title: "Nature", cover_photo: UnsplashPhoto(id: "1", slug: "test", user: User(name: "Test"), urls: UnsplashPhotoUrls(raw: "", full: "", regular: "", small: "", thumb: ""))), feedState: FeedState())
}
