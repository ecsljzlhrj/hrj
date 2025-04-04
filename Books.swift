//
//  Books.swift
//  a p p
//
//  Created by Mac on 2025/3/28.
//
// Book.swift
// Book.swift
import SwiftUI

struct Book: Identifiable, Codable {
    var id = UUID()
    let isbn: String
    let title: String
    let author: String
    let category: String
    var rating: Double
    var isInBookmark: Bool
    let description: String?

    var coverImageURL: URL? {
        guard !isbn.isEmpty,
              isbn.count == 10 || isbn.count == 13,
              isbn.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            return nil
        }
        return URL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg")
    }
}
#if DEBUG
extension Book {
    static let demoBooks: [Book] = [
        Book(
            isbn: "9787536692930",
            title: "三体",
            author: "刘慈欣",
            category: "科幻",
            rating: 9.4,
            isInBookmark: false,
            description: "文化大革命如火如荼进行的同时，一个外星文明的故事展开。"
        ),
        Book(
            isbn: "9787506365437",
            title: "活着",
            author: "余华",
            category: "文学",
            rating: 9.2,
            isInBookmark: true,
            description: "讲述一个农村人在苦难中求生的故事。"
        )
    ]
}
#endif
