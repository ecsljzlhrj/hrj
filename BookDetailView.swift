//
//  BookDetailView.swift
//  a p p
//
//  Created by Mac on 2025/4/2.
//


import SwiftUI

struct BookDetailView: View {
    let book: Book
    @State private var showDescription = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 封面大图
                AsyncImage(url: book.coverImageURL) { phase in
                    Group {
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Image(systemName: "book.closed.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                }
                
                // 基本信息
                VStack(spacing: 12) {
                    Text(book.title)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    
                    Text(book.author)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 10) {
                        Text(book.category)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Color.blue.opacity(0.2)))
                        
                        RatingView(rating: book.rating)
                            .font(.title3)
                    }
                }
                
                // 收藏按钮
                Button {
                    // 收藏功能实现
                } label: {
                    Label(
                        book.isInBookmark ? "已收藏" : "收藏本书",
                        systemImage: book.isInBookmark ? "bookmark.fill" : "bookmark"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(book.isInBookmark ? .green : .blue)
                .padding(.horizontal)
                
                // 书籍简介
                if let description = book.description {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("内容简介")
                                .font(.headline.bold())
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    showDescription.toggle()
                                }
                            } label: {
                                Image(systemName: "chevron.right.circle")
                                    .rotationEffect(.degrees(showDescription ? 90 : 0))
                            }
                        }
                        
                        if showDescription {
                            Text(description)
                                .font(.body)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .padding()
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: shareContent)
            }
        }
    }
    
    private var shareContent: String {
        """
        《\(book.title)》- \(book.author)
        豆瓣评分：\(String(format: "%.1f", book.rating))
        ISBN：\(book.isbn)
        \(book.coverImageURL?.absoluteString ?? "")
        """
    }
}

// 预览
struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookDetailView(book: Book.demoBooks.first!)
        }
    }
}
