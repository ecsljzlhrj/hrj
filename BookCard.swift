//
//  BookCard.swift
//  a p p
//
//  Created by Mac on 2025/3/28.
//

import SwiftUI

struct BookCard: View {
    let book: Book
    let cardType: CardType
    var onTap: (() -> Void)? = nil
    
    enum CardType {
        case small, medium, large
        
        var size: (width: CGFloat, height: CGFloat) {
            let screenWidth = UIScreen.main.bounds.width
            switch self {
            case .small: return (screenWidth/4, screenWidth/4*1.5)
            case .medium: return (screenWidth/3.2, screenWidth/3.2*1.5)
            case .large: return (screenWidth/2.5, screenWidth/2.5*1.5)
            }
        }
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: book.coverImageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Image(systemName: "book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .foregroundColor(.gray.opacity(0.5))
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(width: cardType.size.width, height: cardType.size.height)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                
                // 文字信息模块
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.system(size: cardType == .large ? 14 : 12))
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Text(book.author)
                        .font(.system(size: cardType == .large ? 12 : 10))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .frame(width: cardType.size.width)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
