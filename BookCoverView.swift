//
//  BookCoverView.swift
//  a p p
//
//  Created by Mac on 2025/3/30.
//
import SwiftUI

struct BookCoverView: View {
    let book: Book
    let size: CGSize
    
    var body: some View {
        ZStack {
            if let url = book.coverImageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .transition(.opacity)
                    case .failure(_):
                        errorView
                    case .empty:
                        loadingView
                    @unknown default:
                        loadingView
                    }
                }
            } else {
                placeholderView
            }
        }
        .frame(width: size.width, height: size.height)
    }
    
    // 加载中状态
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // 错误状态
    private var errorView: some View {
        Image(systemName: "exclamationmark.triangle")
            .foregroundColor(.red)
    }
    
    // 无效ISBN占位符
    private var placeholderView: some View {
        Image(systemName: "text.book.closed")
            .resizable()
            .scaledToFit()
            .padding()
            .foregroundColor(.gray.opacity(0.5))
    }
}

