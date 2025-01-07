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

    var body: some View {
        VStack {
            if feedState.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible(minimum: 150), spacing: 8),
                                  GridItem(.flexible(minimum: 150), spacing: 8)],
                        spacing: 8
                    ) {
                        if feedState.topicFeed.isEmpty {
                            ForEach(0..<12, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 150)
                                    .cornerRadius(12)
                            }
                        } else {
                            ForEach(feedState.topicFeed) { image in
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
                    .padding()
                }
            }
        }
        .navigationTitle(topic.title)
        .onAppear {
            feedState.fetchPhotosByTopic(topicId: topic.id)
        }
    }
}
