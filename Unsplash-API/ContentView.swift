//
//  ContentView.swift
//  Unsplash-API
//
//  Created by Lucas Goï on 07/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var feedState = FeedState()
    @State private var selectedPhoto: UnsplashPhoto?
    private let placeholderCount = 12
    private let nbTopics = 10
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    feedState.fetchHomeFeed()
                    feedState.fetchTopics()
                }, label: {
                    Text("Load Data")
                })
                
                if let errorMessage = feedState.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                HStack {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 16){
                            if feedState.topics.isEmpty {
                                ForEach(0..<nbTopics, id: \.self) { _ in
                                    VStack{
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(width: 100, height: 50)
                                            .cornerRadius(12)
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(width: 75, height: 10)
                                            .cornerRadius(12)
                                    }
                                }
                            } else {
                                ForEach(feedState.topics) { topic in
                                    NavigationLink(destination: TopicFeedView(topic: topic, feedState: feedState)) {
                                        
                                        VStack {
                                            AsyncImage(url: URL(string: topic.cover_photo.urls.small)) { phase in
                                                switch phase {
                                                case .empty:
                                                    Rectangle()
                                                        .fill(Color.gray.opacity(0.5))
                                                        .frame(width: 100, height: 50)
                                                        .cornerRadius(12)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 50)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                case .failure:
                                                    Image(systemName: "exclamationmark.triangle.fill")
                                                        .frame(width: 100, height: 50)
                                                        .foregroundColor(.red)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            Text(topic.title)
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                
                //-----------------------------------------
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible(minimum: 150), spacing: 8),
                                  GridItem(.flexible(minimum: 150), spacing: 8)],
                        spacing: 8
                    ) {
                        if feedState.homeFeed.isEmpty {
                            ForEach(0..<placeholderCount, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 150)
                                    .cornerRadius(12)
                            }
                        } else {
                            ForEach(feedState.homeFeed) {image  in
                                Button(action: {
                                    selectedPhoto = image
                                }){
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
                //-----------------------------------------
            }
            .navigationTitle("Feed")
            .sheet(item: $selectedPhoto) { photo in
                ImageDetailView(photo: photo)
            }
        }
    }
}

#Preview {
    ContentView()
}
